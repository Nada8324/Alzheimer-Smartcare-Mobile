import 'package:alzheimer_smartcare/screens/auth/login/view.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/app_logo.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      padding: EdgeInsets.zero,
      bgColor: AppColors.primary,
      body: GetBuilder<ForgotPasswordController>(
        init: ForgotPasswordController(),
        builder: (controller) {
          return Stack(
            children: [
              AppImage(svgAsset: AssetsPaths.splashItem1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
                  height: 686.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Form(
                    key: controller.resetFormKey,
                    child: Column(
                      children: [
                        AppLogo(
                          isAnimated: false,
                          color: AppColors.secondary,
                        ),
                        SizedBox(height: 58.h),
                        Text(
                          "Reset Password".tr,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        AppTextFormField(
                          hintText: 'New Password'.tr,
                          obscureText: true,
                          controller: controller.newPasswordController,
                          prefixIcon: Icon(Icons.lock_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password'.tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.resetFormKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: 22.h),
                        AppTextFormField(
                          hintText: 'Re-enter Password'.tr,
                          obscureText: true,
                          controller: controller.reEnterPasswordController,
                          prefixIcon: Icon(Icons.lock_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter password'.tr;
                            }
                            if (value != controller.newPasswordController.text) {
                              return 'Passwords do not match'.tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.resetFormKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: 22.h),
                        AppButton(
                          buttonType: ButtonType.elevated,
                          text: "Reset Password".tr,
                          onPressed: () {
                            if (controller.resetFormKey.currentState!.validate()) {
                              controller.resetPassword();
                              Get.offAll(() => LoginScreen());
                            }
                          },
                          width: double.infinity,
                          height: 60,
                          borderRadius: BorderRadius.circular(30),
                          bgColor: AppColors.primary,
                          textColor: AppColors.white,
                          shadowColor: AppColors.grey,
                        ),
                        const Spacer(),
                        AppButton(
                          buttonType: ButtonType.text,
                          text: "Back".tr,
                          onPressed: () {
                            Get.back();
                          },
                          textColor: AppColors.primary,
                          bgColor: AppColors.transparent,
                          width: 20,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}