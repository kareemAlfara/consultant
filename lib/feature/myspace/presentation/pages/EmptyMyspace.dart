import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';

import 'package:marriage/core/widgets/Background.dart';

import '../../../chating/presentation/pages/Consultations_list_Page .dart';

/// Empty MySpace Page - StatefulWidget for tab selection
class EmptyMySpacePage extends StatefulWidget {
  const EmptyMySpacePage({super.key});

  @override
  State<EmptyMySpacePage> createState() => _EmptyMySpacePageState();
}

class _EmptyMySpacePageState extends State<EmptyMySpacePage> {
  // ✅ متغير لتتبع التاب المختار
  int selectedTabIndex = 1; // 0: الزواج, 1: الاستشارات, 2: الأحداث

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // bottomNavigationBar: const CustomBottomNav(),
      body: BG(
        child: SafeArea(
            child: Column(
              children: [
          
                SizedBox(height: 18.h,),
          Center(
            child: Text(
              "مساحتي",
              style: TextStyle(
                fontFamily: Keys.TextFontfamily,
                fontWeight: FontWeight.w500,
                fontSize: 22.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 44.w, vertical: 12.h),
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.primary100),
                    boxShadow: [
                      BoxShadow(
                        
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildTab('الزواج', 0),
                      _buildTab('الاستشارات', 1),
                      _buildTab('الأحداث', 2),
                    ],
                  ),
                ),
                Expanded(child: _buildTabContent()),
              ],
            ),
          ),
      ),
      
    );
  }

  // ✅ بناء التاب مع إمكانية الضغط عليه
  Widget _buildTab(String title, int index) {
    final isSelected = selectedTabIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ?AppColors.primary300 : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              color: isSelected ? Colors.white : const Color(0xFF000000),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ عرض المحتوى بناءً على التاب المختار
  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0: // الزواج
        return _buildEmptyState(
          "لا يوجد أحداث زواج حالياً",
          "لم تشترك في أي أحداث زواج بعد، اشترك معنا للعثور على شريك حياتك",
        );
      
      case 1: // الاستشارات
        return ConsultationsListPage();
      
      case 2: // الأحداث
        return _buildEmptyState(
          "لا يوجد أحداث حالياً",
          "لم تشترك في أي أحداث بعد، تابعنا لمعرفة الأحداث القادمة",
        );
      
      default:
        return const SizedBox();
    }
  }

  // ✅ بناء حالة Empty مع رسائل مخصصة
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Container  (
        
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.4,
              child: Transform.rotate(
                angle: 0.5,
                child: Image.asset(
                  "assets/images/emptyMySpace.png",
                  width: 286.w,
                            height: 286.h,
                            fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: const Color(0xFF999999),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans Arabic',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: const Color(0xFFCCCCCC),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
