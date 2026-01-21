
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';

import '../pages/Session_Details_Screen.dart';
import 'Consultation_Card .dart';

class buildConsultationsListINConstultantData extends StatelessWidget {
  const buildConsultationsListINConstultantData({
    super.key,
    required this.consultantConsultations,
  });

  final List<ConsultationEntity> consultantConsultations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: ConsultationCard(
          consultation: consultantConsultations[index],
          isActive: consultantConsultations[index].isActive,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SessionDetailsPage(
                  consultationId: consultantConsultations[index].id,
                ),
              ),
            );
          },
        ),
      ),
      itemCount: consultantConsultations.length > 5
          ? 5
          : consultantConsultations.length,
    );
  }
}
