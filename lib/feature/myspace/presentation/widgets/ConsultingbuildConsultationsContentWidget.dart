  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_cubit.dart';
import 'package:marriage/feature/myspace/presentation/pages/Session_Details_Screen.dart';

import 'Consultation_Card .dart';

Widget ConsultingbuildConsultationsContentWidget(
    BuildContext context,
    List activeConsultations,
    List previousConsultations,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ConsultationCubit>().refreshConsultations();
      },
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          if (activeConsultations.isNotEmpty) ...[
            Text(
              "القادمة",
              style: TextStyle(
                color: Color(0xFF4D4D4D),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            SizedBox(height: 12.h),
            ...activeConsultations.map(
              (consultation) => ConsultationCard(
                consultation: consultation,
                isActive: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SessionDetailsPage(consultationId: consultation.id),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],
          if (previousConsultations.isNotEmpty) ...[
            Text(
              "الجلسات السابقة",
              style: TextStyle(
                color: Color(0xFF4D4D4D),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBM Plex Sans Arabic',
              ),
            ),
            SizedBox(height: 12.h),
            ...previousConsultations.map(
              (consultation) => ConsultationCard(
                consultation: consultation,
                isActive: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SessionDetailsPage(consultationId: consultation.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
