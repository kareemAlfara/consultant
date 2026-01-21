import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/core/widgets/CustomButtom.dart';
import 'package:marriage/core/widgets/defultAppBar.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../widgets/ConsultantDatabody.dart';

/// Consultant Data Page - StatelessWidget using Cubit
class ConsultantDataPage extends StatelessWidget {
  final String consultantId;
  final String consultantName;
  final String consultantImage;
  final String consultantUsername;

  const ConsultantDataPage({
    super.key,
    required this.consultantId,
    this.consultantName = "Dr /Anna Mary",
    this.consultantImage = "assets/images/profile_image.jpg",
    this.consultantUsername = "@anna_mary",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BG(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefaultAppBar(
                title: "بيانات المستشار",
                leadingWidget: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/images/arrow.svg",
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.arrow_back, size: 22.w,color: Colors.black,fontWeight: FontWeight.bold,),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ),
              ConsultantDataBody(
                consultantName: consultantName,
                consultantImage: consultantImage,
                consultantUsername: consultantUsername,
              ),
              buildPrimaryButton(
                "حجز استشارة",
                context,
                onPressed: () {
                  // Navigate to booking page
                },
              ),
              SizedBox(height: 22.h),
            ],
          ),
        ),
      ),
    );
  }
}
