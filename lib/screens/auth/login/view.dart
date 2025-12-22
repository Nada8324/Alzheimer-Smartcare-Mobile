import 'package:alzheimer_smartcare/screens/auth/forgot_password/view.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/get_utils.dart';
import '../../../global_controllers/auth_controller.dart';
import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/custom_app_image.dart';
import '../../../utils/custom_widgets/custom_app_screen.dart';
import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text_form_field.dart';
import '../../../utils/translation/translation.dart';
import '../sign_up/view.dart';

class LoginScreen extends StatelessWidget {
  final loginFormkey = GlobalKey<FormState>();
   LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        return AppScreen(
          padding: EdgeInsets.zero,
          bgColor: AppColors.primary,
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: AppButton(
                    buttonType: ButtonType.elevatedWithIconRow,
                    fontWeight: FontWeight.bold,
                    text: "En-ar".tr,
                    textSize: 18,
                    onPressed: ()
                    {
                      debugPrint("LANG PRESSED");
                      MainAppController mainAppController = Get.find();
                      if (Get.locale?.languageCode == "en") {
                        mainAppController.changeAppLang(Lang.ar);
                      } else if (Get.locale?.languageCode == "ar") {
                        mainAppController.changeAppLang(Lang.en);
                      }
                    },
                    width: 73.w,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(50),
                    bgColor: AppColors.white,
                    textColor: AppColors.black,
                    shadowColor: AppColors.grey,
                    svgImageIcon: AssetsPaths.onboardingLanguageSVG,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: AppImage(
                    svgAsset: AssetsPaths.splashItem1,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(30),
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
                        key: loginFormkey,
                        child: Column(
                          children: [
                            AppLogo(
                              isAnimated: false,
                              color: AppColors.secondary,
                            ),
                            SizedBox(height: 58.h),
                            AppTextFormField(
                              hintText: 'email'.tr,
                              controller: controller.emailController,
                              prefixIcon: Icon(Icons.email_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email'.tr;
                                }
                                // Full email validation on final input.
                                if (!RegExp(
                                    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address'.tr;
                                }
                                return null;
                              },
                              onChanged: (value) {
                               loginFormkey.currentState?.validate();
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9._%+\-@]'),
                                ),
                              ],
                            ),
                            SizedBox(height: 28),
                            AppTextFormField(
                              hintText: 'password'.tr,
                              obscureText: true,
                              controller: controller.passwordController,
                              prefixIcon: Icon(Icons.lock_outline),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'enter_password'.tr;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                loginFormkey.currentState?.validate();
                              },
                            ),
                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: AppButton(
                            //     buttonType: ButtonType.text,
                            //     text: "Forgot_password".tr,
                            //     textColor: AppColors.primary,
                            //     bgColor: AppColors.transparent,
                            //     width: 20,
                            //     onPressed: () {
                            //       Get.to(ForgotPasswordScreen());
                            //     },
                            //   ),
                            // ),
                            const Spacer(),
                            AppButton(
                              buttonType: ButtonType.elevated,
                              text: "login".tr,
                              onPressed: () {
                                if (loginFormkey.currentState!.validate()) {
                                  controller.login();
                                }
                              },
                              // Styling
                              width: double.infinity,
                              height: 60,
                              borderRadius: BorderRadius.circular(30),
                              bgColor: AppColors.primary,
                              textColor: AppColors.white,
                              shadowColor: AppColors.grey,
                            ),
                            const SizedBox(height: 16),
                            AppButton(
                              buttonType: ButtonType.elevated,
                              text: "create_account".tr,
                              onPressed: () {
                                Get.to(RegisterScreen());
                              },
                              width: double.infinity,
                              height: 60,
                              borderRadius: BorderRadius.circular(30),
                              bgColor: AppColors.lightGrey,  // Light background color
                              textColor: AppColors.black,
                              shadowColor: AppColors.grey,
                            ),
                            const Spacer(), //
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}