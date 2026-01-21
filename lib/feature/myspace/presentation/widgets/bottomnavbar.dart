import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Consulting_page.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Interactions_Page.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Social_page.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/marriaging_Page.dart';
// emulator -avd Pixel_9a -gpu swiftshader_indirect -no-snapshot-load

  
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 10.h),
      decoration:  BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10.r, spreadRadius: 1.r),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem("assets/images/social.png", "سوشيال", 0),
            _navItem("assets/images/marriage.png", "زواج", 1),
            _navItem("assets/images/my_space.png", "مساحتي", 2), // Active item
            _navItem("assets/images/interactions.png", "التفاعلات", 3),
            _navItem("assets/images/user.png", "صفحتي", 4),
          ],
        ),
      ),
    );
  }


  Widget _navItem(String assetPath, String label, int index) {
     final bool isActive = currentIndex == index;
    return InkWell(
    
          onTap: () => onTap(index),
        // Handle navigation here
    
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            assetPath,
            width: 30.w,
            height: 30.h,
            // Applies a pink tint to the PNG if it's the active tab
            color: isActive ? const Color(0xFFD84B6B) : Color(0xff4D4D4D), 
          ),
           SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,

              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? const Color(0xFFD84B6B) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
 List<Widget>layouts = [
  SocialPage(),
  MarriagingPage(),
  ConsultingPage(),
  InteractionsPage()
 ]; 