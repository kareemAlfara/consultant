  
  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';

Widget buildChatContent() {
    // TODO: Replace with BlocBuilder<ChatCubit, ChatState>
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // "Today" Label
          Container(
            // width: 70.w,
            // height: 25.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
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
          // Promotional Text
          Text(
            "لديك 30 دقيقة الآن لإرسال استفسارك، وستحصل على إجابة مجانية من المستشار!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              height: 1.5.h,
              fontWeight: FontWeight.w400,
              fontFamily:Keys.TextFontfamily,
            ),
          ),
          // Action Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black87,
                    height: 1.6.h,
                    fontFamily:Keys.TextFontfamily,
                  ),
                  children: [
                    TextSpan(
                      text: "احجز جلسة",
                      style: TextStyle(
                        fontFamily: Keys.TextFontfamily,
                        color: AppColors.primary500,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                        decorationStyle: TextDecorationStyle.solid,
                      
                      ),
                    ),
                    TextSpan(text: "  للحصول على المزيد من الاستشارات، "),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // TODO: Add messages list here
        ],
      ),
    );
  }