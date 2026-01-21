import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marriage/feature/auth/data/models/userModel.dart';

class UsersRemoteDataSource {
  final FirebaseFirestore _firestore;

  UsersRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ========================================
  // ✅ GET ALL USERS EXCEPT CURRENT USER
  // ========================================
  Future<List<UserModel>> getAllUsersExceptCurrent(String currentUserId) async {
    try {
      print('👥 Fetching all users except: $currentUserId');

      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          .get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
          .toList();

      print('✅ Found ${users.length} users');
      return users;
    } catch (e) {
      print('❌ Error fetching users: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ GET USERS WITH LAST MESSAGE (For Chat List)
  // ========================================
  Stream<List<UserWithLastMessage>> getUsersWithLastMessage(String currentUserId) {
    try {
      print('👥 Streaming users with last messages for: $currentUserId');

      // Listen to all chats where current user is a participant
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .asyncMap((chatSnapshot) async {
        List<UserWithLastMessage> usersWithMessages = [];

        for (var chatDoc in chatSnapshot.docs) {
          final chatData = chatDoc.data();
          final participants = List<String>.from(chatData['participants'] ?? []);

          // Get the other user ID
          final otherUserId = participants.firstWhere(
            (id) => id != currentUserId,
            orElse: () => '',
          );

          if (otherUserId.isEmpty) continue;

          // Fetch the other user's data
          final userDoc = await _firestore.collection('users').doc(otherUserId).get();
          if (!userDoc.exists) continue;

          final user = UserModel.fromFirestore(userDoc.data()!, otherUserId);
          final lastMessage = chatData['lastMessage'] as String? ?? '';
          final lastMessageTime = (chatData['lastMessageTime'] as Timestamp?)?.toDate();
          final lastMessageSenderId = chatData['lastMessageSenderId'] as String? ?? '';

          // ✅ Get unread count (with real-time accuracy)
          final unreadCount = await _getUnreadCount(
            chatRoomId: chatDoc.id,
            currentUserId: currentUserId,
          );

          usersWithMessages.add(UserWithLastMessage(
            user: user,
            lastMessage: lastMessage,
            lastMessageTime: lastMessageTime ?? DateTime.now(),
            hasUnreadMessages: unreadCount > 0,
            unreadCount: unreadCount,
            isLastMessageFromMe: lastMessageSenderId == currentUserId,
          ));
        }

        return usersWithMessages;
      });
    } catch (e) {
      print('❌ Error streaming users with messages: $e');
      rethrow;
    }
  }

  // ========================================
  // 🔧 HELPER: Get Unread Message Count
  // ========================================
  Future<int> _getUnreadCount({
    required String chatRoomId,
    required String currentUserId,
  }) async {
    try {
      // ✅ Only count messages where:
      // - receiverId is current user
      // - isRead is false
      final snapshot = await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .get();

      final count = snapshot.docs.length;
      
      if (count > 0) {
        print('📊 Unread count for $chatRoomId: $count');
      }

      return count;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }
}

// ========================================
// 📦 USER WITH LAST MESSAGE MODEL
// ========================================
class UserWithLastMessage {
  final UserModel user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;
  final int unreadCount;
  final bool isLastMessageFromMe;

  UserWithLastMessage({
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.hasUnreadMessages,
    required this.unreadCount,
    required this.isLastMessageFromMe,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} د';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ي';
    } else {
      return '${(difference.inDays / 7).floor()} أ';
    }
  }
}