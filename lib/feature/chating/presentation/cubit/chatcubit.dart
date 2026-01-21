import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/core/utils/enums/cubit_status.dart';
import 'package:marriage/feature/chating/data/datasource/chat_remote_data_source.dart';
import 'package:marriage/feature/chating/data/models/message_model.dart';
import 'package:marriage/feature/chating/presentation/cubit/chatstate.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRemoteDataSource remoteDataSource;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;
  StreamSubscription<TypingStatus?>? _typingSubscription;
  StreamSubscription<bool>? _presenceSubscription;
  Timer? _typingTimer;

  ChatCubit({required this.remoteDataSource}) : super(const ChatState());

  // ========================================
  // ✅ LISTEN TO MESSAGES (Real-time)
  // ========================================
  void listenToMessages({
    required String userId,
    required String otherUserId,
  }) {
    try {
      print('👂 Starting to listen to messages...');
      emit(state.copyWith(status: CubitStatus.loading));

      _messagesSubscription?.cancel();

      _messagesSubscription = remoteDataSource
          .getMessagesStream(
            userId: userId,
            otherUserId: otherUserId,
          )
          .listen(
            (messages) {
              print('📨 Received ${messages.length} messages');
              emit(state.copyWith(
                status: CubitStatus.success,
                messages: messages,
              ));
            },
            onError: (error) {
              print('❌ Error in messages stream: $error');
              emit(state.copyWith(
                status: CubitStatus.error,
                errorMessage: 'فشل في تحميل الرسائل: $error',
              ));
            },
          );
    } catch (e) {
      print('❌ Error listening to messages: $e');
      emit(state.copyWith(
        status: CubitStatus.error,
        errorMessage: 'حدث خطأ: $e',
      ));
    }
  }

  // ========================================
  // ✅ LISTEN TO TYPING STATUS
  // ========================================
  void listenToTypingStatus({
    required String userId,
    required String otherUserId,
  }) {
    try {
      print('👂 Listening to typing status...');
      
      _typingSubscription?.cancel();
      
      _typingSubscription = remoteDataSource
          .getTypingStatus(
            userId: userId,
            otherUserId: otherUserId,
          )
          .listen(
            (typingStatus) {
              emit(state.copyWith(
                otherUserTyping: typingStatus,
                clearTyping: typingStatus == null,
              ));
            },
          );
    } catch (e) {
      print('❌ Error listening to typing status: $e');
    }
  }

  // ========================================
  // ✅ LISTEN TO OTHER USER PRESENCE
  // ========================================
  void listenToOtherUserPresence({
    required String userId,
    required String otherUserId,
  }) {
    _presenceSubscription?.cancel();

    _presenceSubscription = remoteDataSource
        .isOtherUserInChat(
          userId: userId,
          otherUserId: otherUserId,
        )
        .listen((isInChat) {
      emit(state.copyWith(otherUserInChat: isInChat));

      // ✅ Auto-mark messages as read when other user enters chat
      if (isInChat) {
        markMessagesAsReadWhenInChat(
          userId: userId,
          otherUserId: otherUserId,
        );
      }
    });
  }

  // ========================================
  // ✅ SET USER PRESENCE
  // ========================================
  Future<void> setPresence({
    required String userId,
    required String otherUserId,
    required bool isInChat,
  }) async {
    try {
      await remoteDataSource.setUserPresence(
        userId: userId,
        otherUserId: otherUserId,
        isInChat: isInChat,
      );

      // ✅ When entering chat, mark all messages as read
      if (isInChat) {
        await markAllAsRead(
          userId: userId,
          otherUserId: otherUserId,
        );
      }
    } catch (e) {
      print('❌ Error setting presence: $e');
    }
  }

  // ========================================
  // ✅ UPDATE TYPING STATUS
  // ========================================
  Future<void> updateTypingStatus({
    required String userId,
    required String userName,
    required String otherUserId,
    required bool isTyping,
  }) async {
    try {
      _typingTimer?.cancel();

      await remoteDataSource.setTypingStatus(
        userId: userId,
        userName: userName,
        otherUserId: otherUserId,
        isTyping: isTyping,
      );

      if (isTyping) {
        _typingTimer = Timer(const Duration(seconds: 3), () {
          remoteDataSource.setTypingStatus(
            userId: userId,
            userName: userName,
            otherUserId: otherUserId,
            isTyping: false,
          );
        });
      }
    } catch (e) {
      print('❌ Error updating typing status: $e');
    }
  }

  // ========================================
  // ✅ SEND MESSAGE
  // ========================================
  Future<void> sendMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
  }) async {
    try {
      if (message.trim().isEmpty) {
        print('⚠️ Cannot send empty message');
        return;
      }

      print('📤 Sending message: $message');

      await remoteDataSource.sendMessage(
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        message: message,
      );

      print('✅ Message sent successfully');
    } catch (e) {
      print('❌ Error sending message: $e');
      emit(state.copyWith(
        status: CubitStatus.error,
        errorMessage: 'فشل في إرسال الرسالة: $e',
      ));
    }
  }

  // ========================================
  // ✅ MARK ALL MESSAGES AS READ
  // ========================================
  Future<void> markAllAsRead({
    required String userId,
    required String otherUserId,
  }) async {
    try {
      print('📖 Marking all messages as read...');
      await remoteDataSource.markAllMessagesAsRead(
        userId: userId,
        otherUserId: otherUserId,
      );
      print('✅ All messages marked as read');
    } catch (e) {
      print('❌ Error marking all messages as read: $e');
    }
  }

  // ========================================
  // ✅ MARK MESSAGES AS READ WHEN IN CHAT
  // ========================================
  Future<void> markMessagesAsReadWhenInChat({
    required String userId,
    required String otherUserId,
  }) async {
    try {
      print('📖 Marking messages as read (other user in chat)...');
      await remoteDataSource.markMessagesAsReadWhenInChat(
        userId: userId,
        otherUserId: otherUserId,
      );
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  // ========================================
  // ✅ CLEANUP ON LEAVING CHAT
  // ========================================
  Future<void> cleanupChat({
    required String userId,
    required String otherUserId,
  }) async {
    try {
      // Clear typing status
      await remoteDataSource.setTypingStatus(
        userId: userId,
        userName: '',
        otherUserId: otherUserId,
        isTyping: false,
      );

      // Set presence to "not in chat"
      await remoteDataSource.setUserPresence(
        userId: userId,
        otherUserId: otherUserId,
        isInChat: false,
      );

      print('🧹 Chat cleanup completed');
    } catch (e) {
      print('❌ Error during cleanup: $e');
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _typingSubscription?.cancel();
    _presenceSubscription?.cancel();
    _typingTimer?.cancel();
    return super.close();
  }
}