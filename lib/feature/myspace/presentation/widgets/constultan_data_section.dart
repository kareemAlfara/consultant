import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:svg_flutter/svg.dart';

/// Consultant Data Section Widget - Pure UI component
class ConsultantDataSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;

    const ConsultantDataSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.primary100,
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              width: 23.w,
              height: 23.h,
            ),
          ),
        ),
          SizedBox(height: 4.h),
        Text(
          title,
        style:   TextStyle(
            color: AppColors.primary300,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: Keys.TextFontfamily,
            color:   Color(0xff757575),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
