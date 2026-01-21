import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/enums/enums_state.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_cubit.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_state.dart';
import 'package:marriage/feature/myspace/presentation/widgets/constultan_data_section.dart';
import '../../../../core/utils/manager/style_manager/text_style_manager.dart';
import '../widgets/ConstultantDatabuildEmptyState.dart';
import '../widgets/buildConsultationsListINConstultantData.dart';

class ConsultantDataBody extends StatelessWidget {
  const ConsultantDataBody({
    super.key,
    required this.consultantImage,
    required this.consultantName,
    required this.consultantUsername,
  });
  final String consultantImage;
  final String consultantName;
  final String consultantUsername;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25.h),
            // Profile Image
            CircleAvatar(
              radius: 80.r,
              backgroundImage: AssetImage(consultantImage),
            ),
            SizedBox(height: 5.h),
            // Name with verified badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  consultantName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff19295C),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(Icons.check_circle, size: 14.w, color: Colors.blue),
              ],
            ),
            // Stats Section
            Padding(
              padding: EdgeInsets.all(22.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ConsultantDataSection(
                    icon: "assets/images/star.svg",
                    title: "4.5",
                    subtitle: "التقييم",
                  ),
                  ConsultantDataSection(
                    icon: "assets/images/message.svg",
                    title: "398",
                    subtitle: "الاستشارات",
                  ),
                  ConsultantDataSection(
                    icon: "assets/images/exper.svg",
                    title: "10+",
                    subtitle: "سنوات الخبرة",
                  ),
                  ConsultantDataSection(
                    icon: "assets/images/followers.svg",
                    title: "1621",
                    subtitle: "المتابعين",
                  ),
                ],
              ),
            ),
            // Sessions History Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "سجل الجلسات",
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16.sp,
                      fontFamily: Keys.TextFontfamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to full sessions list
                    },
                    child: Text(
                      "عرض الكل",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14.sp,
                        fontFamily: Keys.TextFontfamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Sessions List or Empty State
            BlocBuilder<ConsultationCubit, ConsultationState>(
              builder: (context, state) {
                switch (state.status) {
                  case ConsultationStatusEnum.initial:
                  case ConsultationStatusEnum.loading:
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.w),
                        child: CircularProgressIndicator(
                          color: AppColors.primary300,
                        ),
                      ),
                    );
                  case ConsultationStatusEnum.success:
                    // ✅ تصفية الجلسات: فقط جلسات المستشار المحدد
                    final allConsultations = [
                      ...state.activeConsultations,
                      ...state.previousConsultations,
                    ];
                    // ✅ فلترة بناءً على اسم المستشار أو ID
                    final consultantConsultations = allConsultations
                        .where(
                          (consultation) =>
                              consultation.consultantName == consultantName ||
                              consultation.consultantUsername ==
                                  consultantUsername,
                        )
                        .toList();

                    return buildConsultationsListINConstultantData(
                      consultantConsultations: consultantConsultations,
                    );
                  case ConsultationStatusEnum.empty:
                    return ConstultantDatabuildEmptyState();
                  case ConsultationStatusEnum.error:
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'خطأ',
                        style: TextStyleManager.style24BoldWhite,
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
