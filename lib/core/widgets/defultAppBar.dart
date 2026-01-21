
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    super.key,
    required this.title,
    this.leadingWidget,
    this.trailingWidget,
    this.height = 77,
  });

  final String title;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      padding: EdgeInsets.only(top: 18.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: Keys.TextFontfamily,
                fontWeight: FontWeight.w500,
                fontSize: 22.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),

          // ✅ Leading widget على اليمين
          if (leadingWidget != null)
            Positioned(
            right: 16.w,
              child: leadingWidget!,
            ),

          // ✅ Trailing widget على الشمال
          if (trailingWidget != null)
            Positioned(
              left: 16.w,
              child: trailingWidget!,
            ),
        ],
      ),
    );
  }
}