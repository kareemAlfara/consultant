import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';

/// Reusable consultation card widget - Pure UI component
class ConsultationCard extends StatelessWidget {
  final ConsultationEntity consultation;
  final bool isActive;
  final VoidCallback onTap;

  const ConsultationCard({
    super.key,
    required this.consultation,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.w),
      padding:  EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFF2A6B5)
            : Color.fromRGBO(255, 255, 255, 0.46),
        borderRadius: BorderRadius.circular(24),
        border: isActive
            ? Border.all(color: AppColors.primary300)
            : Border.all(color: AppColors.primary100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 24.h),
              CircleAvatar(
                radius: 28.r,
                backgroundImage: AssetImage(consultation.consultantImage),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultation.consultantName,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    consultation.consultantUsername,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildDetailsButton(context),
            ],
          ),
           SizedBox(height: 13.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            decoration: BoxDecoration(
              border: isActive
                  ? Border.all(color: Color(0xffF2F2F2))
                  : Border.all(color: Color(0xffF2F2F2)),
              color: isActive
                  ? Color.fromRGBO(255, 255, 255, 0.17)
                  : Color.fromRGBO(255, 255, 255, 0.49),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoRow(Icons.calendar_month_outlined, consultation.date),
                Container(width: 1.w, height: 20.h, color: Colors.black12),
                _infoRow(Icons.access_time, consultation.time),
              ],
            ),
          ),
          SizedBox(height: 9.h),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    if (isActive) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary300, AppColors.primary500],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 6.h),
              child: Text(
                "التفاصيل",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

   return Container(
      decoration: BoxDecoration(
        color: AppColors.primary200,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF85142B)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 6.h),
            child: Text(
              "التفاصيل",
              style: TextStyle(
                color: const Color(0xFFD84B6B),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: Color(0xff757575)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff757575),
          ),
        ),
      ],
    );
  }
}
