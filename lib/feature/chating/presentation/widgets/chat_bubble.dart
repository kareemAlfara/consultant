import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../data/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showDateSeparator; // ✅ NEW: Show date on this message

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showDateSeparator = false, // ✅ Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ========================================
        // MESSAGE BUBBLE (الرسالة نفسها)
        // ========================================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for other user
              // if (!isMe) ...[
              //   CircleAvatar(
              //     radius: 16.r,
              //     backgroundColor: Color(0xffD64B67).withOpacity(0.2),
              //     child: Text(
              //       message.senderName.isNotEmpty
              //           ? message.senderName[0].toUpperCase()
              //           : '?',
              //       style: TextStyle(
              //         color: Color(0xffD64B67),
              //         fontSize: 14.sp,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              //   SizedBox(width: 8.w),
              // ],

              // // Message bubble
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 280.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isMe ? Color(0xffD64B67) : Color(0xfffffffff),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    topRight: isMe
                          ? Radius.circular(20.r)
                          : Radius.circular(4.r),
                      topLeft: isMe
                          ? Radius.circular(4.r)
                          : Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message text
                      Text(
                        message.message,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 14.sp,
                          height: 1.4,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Time and read status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.timestamp),
                            style: TextStyle(
                              color: isMe ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 11.sp,
                              fontFamily: 'IBM Plex Sans Arabic',
                            ),
                          ),
                          if (isMe) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              message.isRead ? Icons.done_all : Icons.done,
                              size: 14.sp,
                              color: message.isRead
                                  ? Color(0xff4FC3F7) // Light blue when read
                                  : Colors.white70,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (isMe) SizedBox(width: 8.w),
            ],
          ),
        ),

        // ========================================
        // ✅ DATE SEPARATOR (بعد الرسالة - يعني فوقها في القائمة المعكوسة)
        // ========================================
        if (showDateSeparator) _buildDateSeparator(),
      ],
    );
  }

  // ========================================
  // BUILD DATE SEPARATOR
  // ========================================
  Widget _buildDateSeparator() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      message.timestamp.year,
      message.timestamp.month,
      message.timestamp.day,
    );

    String dateText;
    if (messageDate == today) {
      dateText = "اليوم";
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      dateText = "أمس";
    } else if (messageDate.isAfter(today.subtract(Duration(days: 7)))) {
      dateText = DateFormat('EEEE', 'ar').format(message.timestamp);
    } else {
      dateText = DateFormat('dd MMMM yyyy', 'ar').format(message.timestamp);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: Container(
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
          dateText,
          style: TextStyle(
            color: Color(0xffD64B67),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ),
    );
  }

  // ========================================
  // FORMAT TIME
  // ========================================
  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    return DateFormat('HH:mm').format(localTime);
  }
}