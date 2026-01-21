import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg_flutter.dart';

Widget buildHeaderChatPageStateWidget({
  required BuildContext context,
  required String consultantImage,
  required String consultantName,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
    child: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 22.w, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        //  SizedBox(width: 3.w),
        CircleAvatar(
          backgroundImage: AssetImage(consultantImage),
          radius: 25.r,
        ),
        SizedBox(width: 7.w),
        Text(
          consultantName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Color(0xFF2D3142),
          ),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.check_circle, size: 11.w, color: Colors.blue),
        const Spacer(),
        SvgPicture.asset("assets/images/call.svg", width: 26.w, height: 26.h),
        // IconButton(
        //   onPressed: () {
        //     // TODO: Implement voice call
        //   },
        //   icon: const Icon(Icons.call, color: Colors.grey),
        // ),
        // SizedBox(width: 8.w),
        IconButton(
          onPressed: () {
            // TODO: Show more options
          },
          icon: Icon(Icons.more_vert, color: Colors.black, size: 22.w),
        ),
      ],
    ),
  );
}
