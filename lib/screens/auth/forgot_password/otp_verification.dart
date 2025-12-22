import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/app_logo.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:alzheimer_smartcare/screens/auth/forgot_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String email;
  OTPVerificationScreen({Key? key, required this.email}) : super(key: key);

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
                    key: controller.otpFormKey,
                    child: Column(
                      children: [
                        AppLogo(
                          isAnimated: false,
                          color: AppColors.secondary,
                        ),
                        SizedBox(height: 58.h),
                        AppText(
                          "OTP Verification".tr,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        AppText(
                          "An OTP has been sent to your email".tr,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        AppTextFormField(
                          hintText: 'Enter OTP'.tr,
                          controller: controller.otpController,
                          prefixIcon: Icon(Icons.message_outlined),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter OTP'.tr;
                            }
                            if (value != controller.demoOtp) {
                              return 'Incorrect OTP'.tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.otpFormKey.currentState?.validate();
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: 22.h),
                        AppButton(
                          buttonType: ButtonType.elevated,
                          text: "Verify OTP".tr,
                          onPressed: () {
                            if (controller.otpFormKey.currentState!.validate()) {
                              Get.to(() => ResetPasswordScreen(email: email));
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