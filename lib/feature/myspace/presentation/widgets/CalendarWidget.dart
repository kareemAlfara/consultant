import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Calendar widget - StatefulWidget for local UI state
/// Added callback to notify parent of date selection
class CalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

    const CalendarWidget({
    super.key,
    this.onDateSelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late int selectedDay;
  late String currentMonth;
  late int currentYear;
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    selectedDay = currentDate.day;
    currentYear = currentDate.year;
    currentMonth = _getArabicMonth(currentDate.month);
  }

  String _getArabicMonth(int month) {
    List<String> months = [
      "يناير",
      "فبراير",
      "مارس",
      "إبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];
    return months[month - 1];
  }

  int _getMonthNumber(String arabicMonth) {
    List<String> months = [
      "يناير",
      "فبراير",
      "مارس",
      "إبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];
    return months.indexOf(arabicMonth) + 1;
  }

  void _previousMonth() {
    setState(() {
      int monthNum = _getMonthNumber(currentMonth);
      if (monthNum > 1) {
        currentMonth = _getArabicMonth(monthNum - 1);
      } else {
        currentMonth = _getArabicMonth(12);
        currentYear--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      int monthNum = _getMonthNumber(currentMonth);
      if (monthNum < 12) {
        currentMonth = _getArabicMonth(monthNum + 1);
      } else {
        currentMonth = _getArabicMonth(1);
        currentYear++;
      }
    });
  }

  void _onDaySelected(int day) {
    setState(() {
      selectedDay = day;
    });

    // Notify parent widget
    if (widget.onDateSelected != null) {
      final selectedDate = DateTime(
        currentYear,
        _getMonthNumber(currentMonth),
        day,
      );
      widget.onDateSelected!(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.r,
            spreadRadius: 5.r,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Month and Arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon:   Icon(Icons.chevron_left, color: Colors.grey,size: 14.sp,),
                onPressed: _previousMonth,
              ),
              Text(
                currentMonth,
                style:   TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  fontFamily: 'IBM Plex Sans Arabic',
                ),
              ),
              IconButton(
                icon:   Icon(Icons.chevron_right, color: Colors.grey,size: 14.sp,),
                onPressed: _nextMonth,
              ),
            ],
          ),
            SizedBox(height: 20.h),
          // Weekdays Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["س", "ح", "ن", "ث", "ر", "خ", "ج"]
                .map((d) => Expanded(
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style:   TextStyle(
                          fontFamily: 'IBM Plex Sans Arabic',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ))
                .toList(),
          ),
            SizedBox(height: 10.h),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    int daysInMonth =
        DateTime(currentYear, _getMonthNumber(currentMonth) + 1, 0).day;
    int firstDayOfWeek =
        DateTime(currentYear, _getMonthNumber(currentMonth), 1).weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics:   NeverScrollableScrollPhysics(),
      gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        int day = index - firstDayOfWeek + 1;
        bool isCurrentMonth = day > 0 && day <= daysInMonth;

        DateTime cellDate =
            DateTime(currentYear, _getMonthNumber(currentMonth), day);
        DateTime now = DateTime.now();
        DateTime todayDate = DateTime(now.year, now.month, now.day);

        bool isPastDay = isCurrentMonth && cellDate.isBefore(todayDate);
        bool isToday = isCurrentMonth &&
            day == now.day &&
            currentMonth == _getArabicMonth(now.month) &&
            currentYear == now.year;

        bool isSelected = isCurrentMonth && day == selectedDay;

        String displayText = "";
        if (isCurrentMonth) {
          displayText = "$day";
        } else if (day <= 0) {
          int prevMonthDays =
              DateTime(currentYear, _getMonthNumber(currentMonth), 0).day;
          displayText = "${prevMonthDays + day}";
        } else {
          displayText = "${day - daysInMonth}";
        }

        return GestureDetector(
          onTap: (isCurrentMonth && !isPastDay)
              ? () => _onDaySelected(day)
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ?   Color(0xFFE9728B)
                  : (isToday
                      ?   Color(0xFFFFE5EC)
                      : Colors.transparent),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'IBM Plex Sans Arabic',
                  color: isSelected
                      ? Colors.white
                      : (isPastDay || !isCurrentMonth
                          ? Colors.grey[300]
                          : Colors.black),
                  fontWeight:
                      isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}