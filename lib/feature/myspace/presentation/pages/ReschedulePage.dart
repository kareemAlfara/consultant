import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/core/widgets/CustomButtom.dart';
import 'package:marriage/core/widgets/defultAppBar.dart';

import 'package:marriage/feature/myspace/presentation/cubit/BookingCubit/booking_state.dart';
import 'package:marriage/feature/myspace/presentation/widgets/CalendarWidget.dart';
import 'package:svg_flutter/svg.dart';

import '../cubit/BookingCubit/booking_cubit.dart';

/// Reschedule page - StatefulWidget for local UI + Cubit for business logic
class ReschedulePage extends StatefulWidget {
  final String consultationId;
  final String consultantId;

  const ReschedulePage({
    super.key,
    required this.consultationId,
    required this.consultantId,
  });

  @override
  State<ReschedulePage> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  // Local UI state
  bool isAnonymous = false;
  int selectedTimeIndex = -1;
  String selectedDuration = "90 دقيقة";
  DateTime? selectedDate;
  String? selectedTimeSlotId;

  @override
  void initState() {
    super.initState();
    // Fetch initial time slots
    _fetchTimeSlots();
  }

  void _fetchTimeSlots() {
    if (selectedDate != null) {
      final duration = selectedDuration == "45 دقيقة" ? 45 : 90;
      context.read<BookingCubit>().fetchAvailableTimeSlots(
        consultantId: widget.consultantId,
        date: selectedDate!,
        duration: duration,
      );
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedTimeIndex = -1;
      selectedTimeSlotId = null;
    });
    _fetchTimeSlots();
  }

  void _onDurationChanged(String duration) {
    setState(() {
      selectedDuration = duration;
      selectedTimeIndex = -1;
      selectedTimeSlotId = null;
    });
    _fetchTimeSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BG(
        child: BlocListener<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }

            if (state is BookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                DefaultAppBar(
                  title: "إعادة جدولة",
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
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "التاريخ",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Keys.TextFontfamily,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          CalendarWidget(onDateSelected: _onDateSelected),
                          SizedBox(height: 20.h),
                          Text(
                            "مدة الجلسة",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Keys.TextFontfamily,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildDurationToggle(),
                          SizedBox(height: 20.h),
                          Text(
                            "الوقت",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: Keys.TextFontfamily,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildTimeSlotsGrid(),
                          SizedBox(height: 20.h),
                          _buildAnonymousToggle(),
                          SizedBox(height: 20.h),
                          BlocBuilder<BookingCubit, BookingState>(
                            builder: (context, state) {
                              final isLoading = state is BookingInProgress;
                              return buildPrimaryButton(
                                isLoading ? "جاري الحجز..." : "حجز",
                                context,
                                // onPressed: () {},
                                onPressed:
                                    isLoading ||
                                        selectedDate == null ||
                                        selectedTimeSlotId == null
                                    ? null
                                    : _handleBooking,
                              );
                            },
                          ),
                          SizedBox(height: 40.h),
                        ],
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

  void _handleBooking() {
    if (selectedDate == null || selectedTimeSlotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى اختيار التاريخ والوقت',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
      return;
    }

    context.read<BookingCubit>().rescheduleConsultation(
      consultationId: widget.consultationId,
      newDate: selectedDate!,
      newTimeSlotId: selectedTimeSlotId!,
    );
  }

  Widget _buildDurationToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _onDurationChanged("45 دقيقة"),
            child: _toggleButton("45 دقيقة", selectedDuration == "45 دقيقة"),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: GestureDetector(
            onTap: () => _onDurationChanged("90 دقيقة"),
            child: _toggleButton("90 دقيقة", selectedDuration == "90 دقيقة"),
          ),
        ),
      ],
    );
  }

  Widget _toggleButton(String label, bool isActive) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary300 : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isActive ? null : Border.all(color: Colors.white),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.primaryText,
          fontFamily: 'IBM Plex Sans Arabic',
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingLoadingSlots) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: CircularProgressIndicator(color: AppColors.primary300),
            ),
          );
        }

        if (state is BookingSlotsLoaded) {
          final timeSlots = state.timeSlots;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final slot = timeSlots[index];
              final isSelected = selectedTimeIndex == index;

              return GestureDetector(
                onTap: slot.isAvailable
                    ? () {
                        setState(() {
                          selectedTimeIndex = index;
                          selectedTimeSlotId = slot.id;
                        });
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: slot.isAvailable
                        ? (isSelected
                              ? AppColors.primary300
                              : Color(0xffFFFFFF))
                        : Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    slot.time,
                    style: TextStyle(
                      color: slot.isAvailable
                          ? (isSelected ? Colors.white : Colors.black)
                          : Colors.grey[350],
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: Text(
            'اختر تاريخاً لعرض الأوقات المتاحة',
            style: TextStyle(fontSize: 16.sp),
          ),
        );
      },
    );
  }

  Widget _buildAnonymousToggle() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "هل تريد التعامل كمجهول الهوية ؟",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
              Text(
                "في حالة تفعيل الميزة تقدر تحجز الجلسة وتحضرها\nبدون معرفة بياناتك من الاستشاري",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10.sp, color: Color(0xFF666666)),
              ),
            ],
          ),
          Spacer(),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isAnonymous,
              activeThumbColor: Colors.white,
              activeTrackColor: Color(0xFFE9728B),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
              onChanged: (val) {
                setState(() {
                  isAnonymous = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
