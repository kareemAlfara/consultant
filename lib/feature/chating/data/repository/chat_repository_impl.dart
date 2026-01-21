// ========================================
// 📋 CHAT REPOSITORY IMPLEMENTATION
// ========================================
import 'package:marriage/feature/chating/data/datasource/chat_remote_data_source.dart';
import 'package:marriage/feature/chating/domain/repository/chat_repository.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
  }) async {
    try {
      await remoteDataSource.sendMessage(
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        message: message,
      );
    } catch (e) {
      print('❌ Repository error sending message: $e');
      rethrow;
    }
  }

  @override
  Stream<List<MessageModel>> getMessagesStream({
    required String userId,
    required String otherUserId,
  }) {
    return remoteDataSource.getMessagesStream(
      userId: userId,
      otherUserId: otherUserId,
    );
  }


  @override
  Future<void> markAllMessagesAsRead({
    required String userId,
    required String otherUserId,
  }) async {
    await remoteDataSource.markAllMessagesAsRead(
      userId: userId,
      otherUserId: otherUserId,
    );
  }

  // ✅ NEW: Presence tracking
  @override
  Future<void> setUserPresence({
    required String userId,
    required String otherUserId,
    required bool isInChat,
  }) async {
    await remoteDataSource.setUserPresence(
      userId: userId,
      otherUserId: otherUserId,
      isInChat: isInChat,
    );
  }

  @override
  Stream<bool> isOtherUserInChat({
    required String userId,
    required String otherUserId,
  }) {
    return remoteDataSource.isOtherUserInChat(
      userId: userId,
      otherUserId: otherUserId,
    );
  }

  // ✅ NEW: Typing indicators
  @override
  Future<void> setTypingStatus({
    required String userId,
    required String userName,
    required String otherUserId,
    required bool isTyping,
  }) async {
    await remoteDataSource.setTypingStatus(
      userId: userId,
      userName: userName,
      otherUserId: otherUserId,
      isTyping: isTyping,
    );
  }
@override
Future<void> markMessagesAsReadWhenInChat({
  required String userId,
  required String otherUserId,
}) {
  return remoteDataSource.markMessagesAsReadWhenInChat(
    userId: userId,
    otherUserId: otherUserId,
  );
}
  @override
  Stream<TypingStatus?> getTypingStatus({
    required String userId,
    required String otherUserId,
  }) {
    return remoteDataSource.getTypingStatus(
      userId: userId,
      otherUserId: otherUserId,
    );
  }
}