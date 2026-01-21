import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessengerNotificationWidget extends StatelessWidget {
  final int notificationCount; // عدد الإشعارات
  
    const MessengerNotificationWidget({
    super.key,
    this.notificationCount = 0, // القيمة الافتراضية 0
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.only(right: 12.w),
      child: Center(
        child: SizedBox(
          width: 48.w,
          height: 48.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Messenger Icon
              GestureDetector(
                onTap: () {
                  // Handle messenger icon tap
                },
                child: Container(
                  width: 48.w,
                  height: 48.h,
                  decoration:   BoxDecoration(
                    color: Color(0xFFF8D3DA), // لون وردي فاتح
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/messanger.png',
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              // Notification Badge - يظهر فقط إذا كان العدد أكبر من 0
              if (notificationCount > 0)
                Positioned(
                  right: 5.w,
                  top: 4.h,
                  child: Container(
                    padding:   EdgeInsets.all(3),
                    decoration:   BoxDecoration(
                      color: Color(0xFFFF5C93), // لون وردي غامق للـ badge
                      shape: BoxShape.circle,
                    ),
                  constraints:  BoxConstraints(
                      minWidth: 17.w,
                      minHeight: 17.h,
                    ),
                    child: Center(
                      child: Text(
                        '$notificationCount', // عرض العدد الفعلي
                        style:   TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.h,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
