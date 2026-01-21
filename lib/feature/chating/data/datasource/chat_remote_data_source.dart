import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marriage/feature/chating/data/models/message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ========================================
  // 🔧 HELPER: Generate Chat Room ID
  // ========================================
  String _getChatRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  // ========================================
  // ✅ GET MESSAGES STREAM
  // ========================================
  Stream<List<MessageModel>> getMessagesStream({
    required String userId,
    required String otherUserId,
  }) {
    final chatRoomId = _getChatRoomId(userId, otherUserId);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
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
      final chatRoomId = _getChatRoomId(senderId, receiverId);
      final chatDoc = _firestore.collection('chats').doc(chatRoomId);

      // ✅ Check if receiver is in chat
      final presenceDoc = await chatDoc
          .collection('presence')
          .doc(receiverId)
          .get();

      final isReceiverInChat = presenceDoc.exists &&
          (presenceDoc.data()?['isInChat'] == true);

      print('📤 Sending message | Receiver in chat: $isReceiverInChat');

      // ✅ Create message with auto-read if receiver is in chat
      final messageData = MessageModel(
        id: '',
        senderId: senderId,
        senderName: senderName,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
        isRead: isReceiverInChat, // ✅ Auto-read if receiver is in chat
      );

      // Add message to Firestore
      await chatDoc.collection('messages').add(messageData.toFirestore());

      // Update chat metadata
      await chatDoc.set({
        'participants': [senderId, receiverId],
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSenderId': senderId,
      }, SetOptions(merge: true));

      print('✅ Message sent successfully');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ MARK SINGLE MESSAGE AS READ
  // ========================================
  Future<void> markMessageAsRead({
    required String userId,
    required String otherUserId,
    required String messageId,
  }) async {
    try {
      final chatRoomId = _getChatRoomId(userId, otherUserId);

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});

      print('✅ Message $messageId marked as read');
    } catch (e) {
      print('❌ Error marking message as read: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ MARK ALL MESSAGES AS READ
  // ========================================
  Future<void> markAllMessagesAsRead({
    required String userId,
    required String otherUserId,
  }) async {
    try {
      final chatRoomId = _getChatRoomId(userId, otherUserId);

      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      if (unreadMessages.docs.isEmpty) {
        print('ℹ️ No unread messages to mark');
        return;
      }

      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      print('✅ Marked ${unreadMessages.docs.length} messages as read');
    } catch (e) {
      print('❌ Error marking all messages as read: $e');
      rethrow;
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
      final chatRoomId = _getChatRoomId(userId, otherUserId);

      // ✅ Mark all unread messages from otherUser as read
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: userId)
          .where('senderId', isEqualTo: otherUserId)
          .where('isRead', isEqualTo: false)
          .get();

      if (unreadMessages.docs.isEmpty) {
        print('ℹ️ No unread messages from other user');
        return;
      }

      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      print('✅ Marked ${unreadMessages.docs.length} messages as read (other user in chat)');
    } catch (e) {
      print('❌ Error marking messages as read when in chat: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ SET USER PRESENCE
  // ========================================
  Future<void> setUserPresence({
    required String userId,
    required String otherUserId,
    required bool isInChat,
  }) async {
    try {
      final chatRoomId = _getChatRoomId(userId, otherUserId);

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('presence')
          .doc(userId)
          .set({
        'userId': userId,
        'isInChat': isInChat,
        'lastSeen': FieldValue.serverTimestamp(),
      });

      print('✅ Presence updated: $userId in chat = $isInChat');
    } catch (e) {
      print('❌ Error setting presence: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ CHECK IF OTHER USER IS IN CHAT
  // ========================================
  Stream<bool> isOtherUserInChat({
    required String userId,
    required String otherUserId,
  }) {
    final chatRoomId = _getChatRoomId(userId, otherUserId);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('presence')
        .doc(otherUserId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return false;

      final data = doc.data()!;
      final isInChat = data['isInChat'] == true;

      print('👁️ Other user ($otherUserId) in chat: $isInChat');
      return isInChat;
    });
  }

  // ========================================
  // ✅ SET TYPING STATUS
  // ========================================
  Future<void> setTypingStatus({
    required String userId,
    required String userName,
    required String otherUserId,
    required bool isTyping,
  }) async {
    try {
      final chatRoomId = _getChatRoomId(userId, otherUserId);

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('typing')
          .doc(userId)
          .set({
        'userId': userId,
        'userName': userName,
        'isTyping': isTyping,
        'lastUpdate': FieldValue.serverTimestamp(),
      });

      print('⌨️ Typing status updated: $userName is ${isTyping ? 'typing' : 'not typing'}');
    } catch (e) {
      print('❌ Error setting typing status: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ GET TYPING STATUS
  // ========================================
  Stream<TypingStatus?> getTypingStatus({
    required String userId,
    required String otherUserId,
  }) {
    final chatRoomId = _getChatRoomId(userId, otherUserId);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('typing')
        .doc(otherUserId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;

      final data = doc.data()!;
      final typingStatus = TypingStatus.fromFirestore(data);

      // Check if typing status is stale (older than 5 seconds)
      final now = DateTime.now();
      final difference = now.difference(typingStatus.lastUpdate);

      if (difference.inSeconds > 5) {
        print('⌨️ Typing status is stale, ignoring');
        return null; // Consider as not typing
      }

      return typingStatus.isTyping ? typingStatus : null;
    });
  }
}