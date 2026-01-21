import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';

Widget buildInputAreaChat({
  required TextEditingController messageController,
  required VoidCallback sendMessage,
}) {
  return Container(
    color: Color(0xffF9EEFA),
    padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end, // ✅ Align to bottom
      children: [
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 48.h, // ✅ Minimum height (1 line)
              maxHeight: 120.h, // ✅ Maximum height (about 5 lines)
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end, // ✅ Align icons to bottom
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    // ✅ MULTI-LINE CONFIGURATION
                    maxLines: null, // ✅ Allow unlimited lines
                    minLines: 1, // ✅ Start with 1 line
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline, // ✅ Enter creates new line
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: Keys.TextFontfamily,
                      height: 1.4, // ✅ Line height for better spacing
                    ),
                    decoration: InputDecoration(
                      hintText: "نص الرسالة",
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.h, // ✅ Vertical padding for better spacing
                      ),
                      hintStyle: TextStyle(
                        color: Color(0xffCCCCCC),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                
                // ========================================
                // ACTION ICONS
                // ========================================
                SizedBox(width: 8.w),
                Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xffCCCCCC),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xffCCCCCC),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.attach_file,
                  color: Color(0xffCCCCCC),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        
        // ========================================
        // SEND BUTTON
        // ========================================
        SizedBox(width: 12.w),
        IconButton(
          onPressed: sendMessage,
          icon: Icon(
            Icons.send_rounded,
            color: AppColors.primary300,
            size: 32.sp,
          ),
          padding: EdgeInsets.zero, // ✅ Remove extra padding
          constraints: BoxConstraints(), // ✅ Remove min size constraints
        ),
      ],
    ),
  );
}