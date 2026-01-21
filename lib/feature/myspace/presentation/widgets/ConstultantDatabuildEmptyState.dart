import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget ConstultantDatabuildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(
          opacity: 0.4,
          child: Transform.rotate(
            angle: 0.5,
            child: Image.asset("assets/images/emptyMySpace.png", width: 280.w),
          ),
        ),
        Text(
          "لا يوجد جلسات حتى الان",
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Color(0xFF999999),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          "احجز جلسة لتتمكن من حل مشاكلك النفسية",
          style: TextStyle(
            fontFamily: 'IBM Plex Sans Arabic',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Color(0xFFCCCCCC),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 33.h),
      ],
    );
  }
