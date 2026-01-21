import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/enums/enums_state.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/core/widgets/CustomButtom.dart';
import 'package:marriage/core/widgets/defultAppBar.dart';
import 'package:marriage/core/widgets/dialogmethod.dart';
import 'package:marriage/feature/myspace/presentation/cubit/Ratingcubit/rating_cubit.dart';
import 'package:marriage/feature/myspace/presentation/cubit/Ratingcubit/rating_state.dart';
import 'package:svg_flutter/svg.dart';

/// Consultant evaluation page - StatefulWidget for form + Cubit for submission
class ConsultantEvaluationPage extends StatefulWidget {
  final String consultationId;
  final String consultantName;
  final String consultantImage;

  const ConsultantEvaluationPage({
    super.key,
    required this.consultationId,
    required this.consultantName,
    required this.consultantImage,
  });

  @override
  State<ConsultantEvaluationPage> createState() =>
      _ConsultantEvaluationPageState();
}

class _ConsultantEvaluationPageState extends State<ConsultantEvaluationPage> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BG(
        child: BlocListener<RatingCubit, RatingState>(
          listener: (context, state) {
            switch (state.status) {
              case RatingEnum.initial:
              case RatingEnum.loading:
              case RatingEnum.success:
                commentController.clear();
                DialogmethodClass.showSuccessDialog(context);
              case RatingEnum.error:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                DefaultAppBar(
                  title: "تقييم الاستشاري",
                  leadingWidget: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/images/arrow.svg",
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                ),
              
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: SafeArea(
                        child: Column(
                          children: [
                            // Profile Image
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF8B5C5),
                                ),
                                child: CircleAvatar(
                                  radius: 75.r,
                                  backgroundImage: AssetImage(
                                    widget.consultantImage,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Name with verified badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.consultantName,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF19295C),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xFF1DA1F2),
                                  size: 18,
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            // Star Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () => setState(
                                    () => selectedRating = index + 1,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    child: Icon(
                                      Icons.star,
                                      color: index < selectedRating
                                          ? const Color(0xFFFFD700)
                                          : Colors.white,
                                      size: 45,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 40.h),
                            Row(
                              children: [
                                Text(
                                  "شاركنا رأيك",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            // Comment TextField
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: TextField(
                                controller: commentController,
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 14.sp, // أو 15.sp حسب ذوقك
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "يساعد رأيك المرضى الآخرين في اختيار المعالج المناسب، كما يساعد المعالج على تحسين خدماته",
                                  hintStyle: TextStyle(
                                    fontSize: 13.sp,
                                    color: Color(0xFFD9D9D9),
                                    height: 1.5.r,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16.w),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            BlocBuilder<RatingCubit, RatingState>(
                              builder: (context, state) {
                                final isSubmitting =
                                    state.status == RatingEnum.loading;
                                return buildPrimaryButton(
                                  isSubmitting
                                      ? "جاري الإرسال..."
                                      : "ارسال التقييم",
                                  context,
                                  onPressed: isSubmitting
                                      ? null
                                      : _handleSubmit,
                                );
                              },
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (selectedRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text('يرجى اختيار التقييم',style: TextStyle(fontSize: 16.h),)));
      return;
    }

    if (commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar( SnackBar(content: Text('يرجى كتابة تعليق',style: TextStyle(fontSize: 16.h),)));
      return;
    }

    context.read<RatingCubit>().submitRating(
      consultationId: widget.consultationId,
      rating: selectedRating,
      comment: commentController.text.trim(),
    );
  }
}
