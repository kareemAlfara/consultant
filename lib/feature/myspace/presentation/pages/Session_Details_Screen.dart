import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/core/widgets/CustomButtom.dart';
import 'package:marriage/core/widgets/defultAppBar.dart';
import 'package:marriage/core/widgets/dialogmethod.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';
import 'package:marriage/feature/myspace/presentation/pages/Consultant_data._page.dart';
import 'package:marriage/feature/myspace/presentation/pages/Consultant_evaluation.dart';
import 'package:marriage/feature/myspace/presentation/pages/ReschedulePage.dart';

import 'package:svg_flutter/svg_flutter.dart';

import '../cubit/BookingCubit/booking_cubit.dart';
import '../cubit/BookingCubit/booking_state.dart';
import '../cubit/SessionDetailscubit/session_details_cubit.dart';
import '../cubit/SessionDetailscubit/session_details_state.dart';

/// Session Details Page - StatelessWidget using Cubit
class SessionDetailsPage extends StatelessWidget {
  final String consultationId;

  const SessionDetailsPage({super.key, required this.consultationId});

  @override
  Widget build(BuildContext context) {
    // Fetch session details when page loads
    context.read<SessionDetailsCubit>().fetchSessionDetails(consultationId);

    return Scaffold(
      body: BG(
        child: BlocListener<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message,style: TextStyle(fontSize: 22.sp),),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh session details
              context.read<SessionDetailsCubit>().fetchSessionDetails(
                consultationId,
              );
            }
            if (state is BookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message,style: TextStyle(fontSize: 22.sp),),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<SessionDetailsCubit, SessionDetailsState>(
            builder: (context, state) {
              if (state is SessionDetailsLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary300),
                );
              }

              if (state is SessionDetailsError) {
                return _buildErrorState(context, state.message);
              }

              if (state is SessionDetailsLoaded) {
                return _buildContent(context, state.session);
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SessionDetailsEntity session) {
    return SingleChildScrollView(
    
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultAppBar(
              title: "تفاصيل الجلسة",
              leadingWidget: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/images/arrow.svg",
                  width: 18.w,
                  height: 18.h,
                ),
              ),
            ),
            SizedBox(height: 22.h),
            _sectionTitle("بيانات الشخص"),
            Padding(
              padding:  EdgeInsets.all(20.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Color.fromRGBO(255, 255, 255, 0.73),
                ),
                padding: EdgeInsets.all(16.w),
              
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConsultantDataPage(
                        consultantId: consultationId,
                        consultantName: session.consultant.name,
                        consultantImage: session.consultant.image,
                        consultantUsername: session.consultant.username,
                      ),
                    ),
                  ),
                  child: _profileCard(session.consultant),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _sectionTitle("حالة الحجز"),
            Padding(
               padding:  EdgeInsets.all(20.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Color.fromRGBO(255, 255, 255, 0.73),
                ),
                padding: EdgeInsets.all(16.w),
              
                child: _glassCard(BookingStatusCard(status: session.status)),
              ),
            ),
            SizedBox(height: 20.h),
            _sectionTitle("بيانات الجلسة"),
            Padding(
              padding:  EdgeInsets.all(20.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Color.fromRGBO(255, 255, 255, 0.73),
                ),
                padding: EdgeInsets.all(16.w),
              
                child: _glassCard(_sessionData(session.sessionData)),
              ),
            ),
            SizedBox(height: 20.h),
            _sectionTitle("بيانات السعر"),
            Padding(
              padding:  EdgeInsets.all(20.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Color.fromRGBO(255, 255, 255, 0.73),
                ),
                padding: EdgeInsets.all(16.w),
              
                child: _glassCard(_pricing(session.pricing)),
              ),
            ),
            SizedBox(height: 20.h),
            _sectionTitle("وسيلة الدفع"),
            Padding(
              padding:  EdgeInsets.all(20.0.w),
              child: _paymentMethods(session.paymentMethods),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding:  EdgeInsets.all(20.0.w),
              child: _actionButtons(context, session),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<SessionDetailsCubit>().fetchSessionDetails(
                consultationId,
              );
            },
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xff4D4D4D),
      ),
    ),
  );

  Widget _glassCard(Widget child) => Container(
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.75),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: child,
  );

  Widget _profileCard(ConsultantInfoEntity consultant) => Container(
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundImage: AssetImage(consultant.image),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              consultant.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            Text(
              consultant.username,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _sessionData(SessionDataEntity data) => Column(
    children: [
      _InfoRow("assets/images/date1.svg", data.date),
      SizedBox(height: 12.h),
      _InfoRow(
        "assets/images/clock.svg",
        "${data.timeStart} - ${data.timeEnd}",
      ),
      SizedBox(height: 12.h),
      if (data.isAnonymous)
        _InfoRow("assets/images/Capa_1.svg", "مجهول الهوية"),
    ],
  );

  Widget _pricing(PricingEntity pricing) => Column(
    children: [
      _priceRow("سعر الجلسة", "${pricing.sessionPrice} ر.س"),
      _priceRow("الضرائب", "${pricing.taxes} ر.س"),
      _priceRow("الرسوم", "${pricing.fees} ر.س"),
      _priceRow("الخصم", "-${pricing.discount} ر.س"),
      SizedBox(height: 20.h),
      DottedLine(dashColor: Color(0xFFEEEEEE)),
      SizedBox(height: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "الإجمالي",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff757575),
            ),
          ),
          Text(
            "${pricing.total} ر.س",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE44E6C),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _paymentMethods(List<PaymentMethodEntity> methods) => Column(
    children: methods
        .map(
          (method) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _paymentItem(method.name, method.icon),
          ),
        )
        .toList(),
  );

  Widget _paymentItem(String text, String icon) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        SvgPicture.asset(icon, height: 24.h),
        SizedBox(width: 12.w),
        Text(text, style: TextStyle(fontSize: 15.sp)),
      ],
    ),
  );

  Widget _actionButtons(BuildContext context, SessionDetailsEntity session) {
    switch (session.status) {
      case BookingStatus.completed:
        return Column(
          children: [
            buildPrimaryButton(
              "إعادة حجز",
              context,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReschedulePage(
                      consultationId: consultationId,
                      consultantId: session.id,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            _outlinedButton(
              "تقييم الاستشاري",
              context,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultantEvaluationPage(
                      consultationId: consultationId,
                      consultantName: session.consultant.name,
                      consultantImage: session.consultant.image,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
          ],
        );

      case BookingStatus.cancelled:
      case BookingStatus.waitingPayment:
        return Column(
          children: [
            buildPrimaryButton(
              "إعادة جدولة",
              context,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReschedulePage(
                      consultationId: consultationId,
                      consultantId: session.id,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
          
            _outlinedButton(
              "إلغاء الحجز ",
              context,
              onPressed: () => DialogmethodClass.showdialogfunction(
                context,
                title: "هل تريد أرشفة المحادثة ؟",
                subtilte:
                    "في حالة ارشفة المحادثة لن يظهر لك رسائل من الشخص في الاشعارات .",
                fct: () {
                  // Navigator.pop(context);
                },
                iserror: true,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        );

      default:
        return Column(
          children: [
            buildPrimaryButton("إعادة حجز", context, onPressed: () {}),
            SizedBox(height: 12.h),
            _outlinedButton(
              "تقييم الاستشاري",
              context,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultantEvaluationPage(
                      consultationId: consultationId,
                      consultantName: session.consultant.name,
                      consultantImage: session.consultant.image,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
          ],
        );
    }
  }


  Widget _outlinedButton(
    String text,
    BuildContext context, {
    required void Function()? onPressed,
  }) => Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 52.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFFF8D3DA),
          side: BorderSide(color: Color(0xFF85142B)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF85142B),
          ),
        ),
      ),
    ),
  );

  Widget _priceRow(String label, String value) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xff757575),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xff757575),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: 16.h, width: 16.w),
        SizedBox(width: 12.w),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: Color(0xff757575)),
        ),
      ],
    );
  }
}

/// Booking Status Card Widget
class BookingStatusCard extends StatelessWidget {
  final BookingStatus status;

  const BookingStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(_statusIcon(status), width: 20.w, height: 20.h),
        SizedBox(width: 8.w),
        Text(
          _statusText(status),
          style: TextStyle(color: _statusColor(status), fontSize: 14.sp),
        ),
      ],
    );
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.waitingPayment:
        return Colors.orange;
      default:
        return Color(0xFFEB7A91);
    }
  }

  String _statusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed:
        return "مكتملة";
      case BookingStatus.cancelled:
        return "مرفوضة - يرجى اختيار موعد آخر";
      case BookingStatus.waitingPayment:
        return "قيد المراجعة -بانتظار تأكيد الطبيب للموعد";
      default:
        return "مؤكدة - تم التأكيد الموعد من الاستشاري";
    }
  }

  String _statusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed:
        return "assets/images/statusComplete.svg";
      case BookingStatus.cancelled:
        return "assets/images/statusError.svg";
      case BookingStatus.waitingPayment:
        return "assets/images/statusWait.svg";
      default:
        return "assets/images/status.svg";
    }
  }
}
