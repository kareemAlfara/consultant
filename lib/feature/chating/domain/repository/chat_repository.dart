import 'package:marriage/feature/chating/data/models/message_model.dart';

abstract class ChatRepository {
  Stream<List<MessageModel>> getMessagesStream({
    required String userId,
    required String otherUserId,
  });

  Future<void> sendMessage({
    required String senderId,
    required String senderName,
    required String receiverId,
    required String message,
  });

  Future<void> markAllMessagesAsRead({
    required String userId,
    required String otherUserId,
  });

  Future<void> markMessagesAsReadWhenInChat({
    required String userId,
    required String otherUserId,
  });

  Future<void> setTypingStatus({
    required String userId,
    required String userName,
    required String otherUserId,
    required bool isTyping,
  });

  Stream<TypingStatus?> getTypingStatus({
    required String userId,
    required String otherUserId,
  });

  Future<void> setUserPresence({
    required String userId,
    required String otherUserId,
    required bool isInChat,
  });

  Stream<bool> isOtherUserInChat({
    required String userId,
    required String otherUserId,
  });
}
