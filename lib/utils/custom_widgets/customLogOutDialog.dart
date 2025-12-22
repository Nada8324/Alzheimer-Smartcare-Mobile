import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../screens/auth/login/view.dart';
import '../../screens/patient/AddReminders/controller.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import 'custom_app_image.dart';
import 'custom_button.dart';
import 'custom_text.dart';

void showConfirmationDialog({
  bool isPatient=true,
  required String title,
  String description = "",
  required String confirmButtonText,
  String cancelButtonText = "cancel",
  required VoidCallback onConfirm,
  Color confirmColor = AppColors.logoutButton,
  Color cancelColor = AppColors.cancelButton,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.r),
      ),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(confirmButtonText=="logout".tr)
                AppImage(
              height: 97.h,
              width: 97.w,
              svgAsset: AssetsPaths.logout1,
            ),
            SizedBox(height: 22.h),
            AppText(
              title.tr,
              textAlign: TextAlign.center,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
            if (description.isNotEmpty) SizedBox(height: 16.h),
            if (description.isNotEmpty)
              AppText(
                description,
                textAlign: TextAlign.center,
                fontSize: 16.sp,
                color: AppColors.grey,
              ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AppButton(
                    buttonType: ButtonType.elevated,
                    onPressed: () => Get.back(),
                    bgColor: cancelColor,
                    borderRadius: BorderRadius.circular(49.r),
                    child: AppText(
                      cancelButtonText.tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppButton(
                    buttonType: ButtonType.elevated,
                    onPressed: () {
                      if(isPatient)
                          Get.delete<TaskController>();
                      onConfirm();
                    },
                    bgColor: confirmColor,
                    borderRadius: BorderRadius.circular(49.r),
                    child: AppText(
                      confirmButtonText.tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}