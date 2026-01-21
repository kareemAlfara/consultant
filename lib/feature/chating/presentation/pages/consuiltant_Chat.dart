import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:marriage/feature/chating/presentation/cubit/chatcubit.dart';
import 'package:marriage/feature/chating/presentation/cubit/chatstate.dart';
import 'package:marriage/feature/chating/presentation/widgets/chat_bubble.dart';
import 'package:marriage/feature/myspace/presentation/widgets/buildInputAreaChat.dart';
import '../../../myspace/presentation/widgets/buildHeaderChatPageStateWidget.dart';
import 'dart:async';

class ConsultantChatPage extends StatefulWidget {
  final String consultantId;
  final String consultantName;
  final String consultantImage;

  const ConsultantChatPage({
    super.key,
    required this.consultantId,
    required this.consultantName,
    required this.consultantImage,
  });

  @override
  State<ConsultantChatPage> createState() => _ConsultantChatPageState();
}

class _ConsultantChatPageState extends State<ConsultantChatPage> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingDebounce;
  bool _isTyping = false;
  
  late ChatCubit _chatCubit;
  String _currentUserId = '';
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    
    if (_currentUserId.isNotEmpty) {
      _chatCubit.cleanupChat(
        userId: _currentUserId,
        otherUserId: widget.consultantId,
      );
    }
    
    WidgetsBinding.instance.removeObserver(this);
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_currentUserId.isEmpty) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _chatCubit.setPresence(
          userId: _currentUserId,
          otherUserId: widget.consultantId,
          isInChat: true,
        );
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _chatCubit.setPresence(
          userId: _currentUserId,
          otherUserId: widget.consultantId,
          isInChat: false,
        );
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onTextChanged() {
    if (_currentUserId.isEmpty || _currentUserName.isEmpty) return;

    final isCurrentlyTyping = _messageController.text.trim().isNotEmpty;
    
    if (isCurrentlyTyping != _isTyping) {
      _isTyping = isCurrentlyTyping;
      
      _chatCubit.updateTypingStatus(
        userId: _currentUserId,
        userName: _currentUserName,
        otherUserId: widget.consultantId,
        isTyping: isCurrentlyTyping,
      );
    }

    _typingDebounce?.cancel();
    if (isCurrentlyTyping) {
      _typingDebounce = Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        _isTyping = false;
        _chatCubit.updateTypingStatus(
          userId: _currentUserId,
          userName: _currentUserName,
          otherUserId: widget.consultantId,
          isTyping: false,
        );
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<AuthCubit>().state;
        final userId = authState is AuthAuthenticated ? authState.user.id : '';
        final userName = authState is AuthAuthenticated ? authState.user.name : '';
        
        _currentUserId = userId;
        _currentUserName = userName;
        
        _chatCubit = GetIt.instance<ChatCubit>();
        
        _chatCubit.listenToMessages(
          userId: userId,
          otherUserId: widget.consultantId,
        );
        
        _chatCubit.listenToTypingStatus(
          userId: userId,
          otherUserId: widget.consultantId,
        );
        
        _chatCubit.listenToOtherUserPresence(
          userId: userId,
          otherUserId: widget.consultantId,
        );
        
        if (userId.isNotEmpty) {
          _chatCubit.markAllAsRead(
            userId: userId,
            otherUserId: widget.consultantId,
          );
          
          _chatCubit.setPresence(
            userId: userId,
            otherUserId: widget.consultantId,
            isInChat: true,
          );
        }
        
        return _chatCubit;
      },
      child: Scaffold(
        body: BG(
          child: SafeArea(
            child: Column(
              children: [
                buildHeaderChatPageStateWidget(
                  context: context,
                  consultantName: widget.consultantName,
                  consultantImage: widget.consultantImage,
                ),
                Expanded(child: _buildChatContent()),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    return buildInputAreaChat(
                      messageController: _messageController,
                      sendMessage: () => _sendMessage(context, authState),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        // ✅ Using general enum getters
        if (state.isSuccess) {
          _scrollToBottom();
        } else if (state.isError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'حدث خطأ'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          // ✅ Using general enum getters
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    state.errorMessage ?? 'حدث خطأ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (state.otherUserTyping != null)
                _buildTypingIndicator(state.otherUserTyping!.userName),
              
              Expanded(
                child: !state.hasMessages
                    ? _buildEmptyState()
                    : _buildMessagesWithDates(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator(String userName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '$userName يكتب',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xffD64B67),
                fontStyle: FontStyle.italic,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 20.w,
            height: 10.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 4.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Color(0xffD64B67).withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesWithDates(ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final reversedIndex = state.messages.length - 1 - index;
        final message = state.messages[reversedIndex];
        final showDateSeparator = _shouldShowDateSeparator(state.messages, index);

        return ChatBubble(
          message: message,
          isMe: message.senderId == _currentUserId,
          showDateSeparator: showDateSeparator,
        );
      },
    );
  }

  bool _shouldShowDateSeparator(List messages, int index) {
    final reversedIndex = messages.length - 1 - index;
    if (reversedIndex == 0) return true;

    final currentMessage = messages[reversedIndex];
    final previousMessage = messages[reversedIndex - 1];

    final currentDate = DateTime(
      currentMessage.timestamp.year,
      currentMessage.timestamp.month,
      currentMessage.timestamp.day,
    );

    final previousDate = DateTime(
      previousMessage.timestamp.year,
      previousMessage.timestamp.month,
      previousMessage.timestamp.day,
    );

    return currentDate != previousDate;
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              "اليوم",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xffD64B67),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "لديك 30 دقيقة الآن لإرسال استفسارك، وستحصل على إجابة مجانية من المستشار!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              height: 1.5,
              fontWeight: FontWeight.w400,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
                height: 1.6,
              ),
              children: [
                TextSpan(
                  text: "احجز جلسة",
                  style: TextStyle(
                    color: Color(0xffD64B67),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: "  للحصول على المزيد من الاستشارات."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, AuthState authState) {
    if (_messageController.text.trim().isEmpty) return;

    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
      );
      return;
    }

    context.read<ChatCubit>().sendMessage(
      senderId: authState.user.id,
      senderName: authState.user.name,
      receiverId: widget.consultantId,
      message: _messageController.text.trim(),
    );

    _messageController.clear();
    _scrollToBottom();
  }
}