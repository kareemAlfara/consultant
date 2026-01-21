
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPrimaryButton(
  String label,
  BuildContext context, {
  required void Function()? onPressed,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 55.h,
    decoration: BoxDecoration(
      // Linear Gradient implementation from Figma data
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFEB7A91), // primary/300
          Color(0xFFAC1A37), // primary/500
        ],
      ),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.transparent, // Required to show the container gradient
        shadowColor: Colors.transparent, // Removes shadow to keep it clean
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      ),
      child: Text(
        label,
        style:  TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'IBM Plex Sans Arabic', // Consistent with your text style
        ),
      ),
    ),
  );
}

