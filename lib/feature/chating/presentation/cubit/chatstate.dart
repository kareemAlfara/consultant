import 'package:marriage/core/utils/enums/cubit_status.dart';
import 'package:marriage/feature/chating/data/models/message_model.dart';

// ========================================
// 📋 CHAT STATE CLASS
// ========================================
class ChatState {
  final CubitStatus status;
  final List<MessageModel> messages;
  final TypingStatus? otherUserTyping;
  final bool otherUserInChat;
  final String? errorMessage;

  const ChatState({
    this.status = CubitStatus.initial,
    this.messages = const [],
    this.otherUserTyping,
    this.otherUserInChat = false,
    this.errorMessage,
  });

  // ✅ copyWith method for state updates
  ChatState copyWith({
    CubitStatus? status,
    List<MessageModel>? messages,
    TypingStatus? otherUserTyping,
    bool? otherUserInChat,
    String? errorMessage,
    bool clearTyping = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      otherUserTyping: clearTyping ? null : (otherUserTyping ?? this.otherUserTyping),
      otherUserInChat: otherUserInChat ?? this.otherUserInChat,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // ✅ Convenience getters using extension
  bool get isInitial => status.isInitial;
  bool get isLoading => status.isLoading;
  bool get isSuccess => status.isSuccess;
  bool get isEmpty => status.isEmpty;
  bool get isError => status.isError;
  bool get hasMessages => messages.isNotEmpty;
}