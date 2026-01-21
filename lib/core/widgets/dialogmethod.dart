import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';

class DialogmethodClass {
  static Future<void> showdialogfunction(
  BuildContext  context, {
    required String subtilte,
    bool iserror = false,
    required Function fct,
    required String title,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Icon
                  Image.asset("assets/images/warning.png", width: 70.w, height: 70.h),
             SizedBox(height: 12.h),
            
              // Title
               Text(
                'هل تريد إلغاء الحجز ؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Keys.TextFontfamily,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0A0A),
                ),
              ),
               SizedBox(height: 12.h),
            
              // Description
               Text(
            "هل انت متأكد انك تريد إلغاء حجز الجلسه مع المستشار لحل مشاكل علاقاتك التي تواجهها !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: Keys.TextFontfamily,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  height: 1.5.h,
                ),
              ),
      
            SizedBox(height: 11.h,),
              // Buttons Row
              Row(
                children: [
                    Expanded(
                    child: Container(
                      padding:  EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D6D),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4D6D).withOpacity(0.3),
                            blurRadius: 8.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                                Navigator.pop(context);
                            // Handle confirm cancellation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:  Text(
                                  'تم إلغاء الجلسة بنجاح',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: const Color(0xFFFF4D6D),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child:  Center(
                            child: Text(
                              'لا',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Cancel Button (Green)
                 SizedBox(width: 12.w),
            
                  // Confirm Button (Red)
                Expanded(
                    child: Container(
                      padding:  EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C853).withOpacity(0.3),
                            blurRadius: 8.r,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
  onTap: () {
                                Navigator.pop(context);
                            // Handle confirm cancellation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:  Text(
                                  'تم إلغاء الجلسة بنجاح',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: const Color(0xFFFF4D6D),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child:  Center(
                            child: Text(
                              'نعم',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                ],
              ),
            ],
          ),

      
      ),
    );
  }


static void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        child: Container(
          padding:  EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              // 1. Close Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child:  Icon(Icons.close, color: Color(0xFF8E1B3B), size: 24.w),
                ),
              ),
        
               Text(
                "تم ارسال تقييمك بنجاح !",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary500, // Deep red/maroon color
                  fontFamily: Keys.TextFontfamily,
                ),
                textAlign: TextAlign.center,
              ),
              // 2. Success Icon with Sparkles
              Stack(
                alignment: Alignment.center,
                children: [
                  // Circular background for the checkmark
                  SizedBox(
                    width: 150.w,
                    height: 150.h,
                    
                    child: Image.asset("assets/images/done.png"),
                  ),
                  // You can add sparkles here using small positioned Icons/Images
                ],
              ),
               SizedBox(height: 24.h),
              
            
            ],
          ),
        ),
      );
    },
  );
}
}
