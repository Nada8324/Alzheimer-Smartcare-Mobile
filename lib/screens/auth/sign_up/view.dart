import 'package:alzheimer_smartcare/screens/auth/sign_up/controller.dart';
import 'package:alzheimer_smartcare/screens/auth/sign_up/model.dart';
import 'package:alzheimer_smartcare/screens/auth/sign_up/widgets/user_type_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/constants/alerts.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/app_logo.dart';
import '../../../utils/custom_widgets/custom_app_image.dart';
import '../../../utils/custom_widgets/custom_app_screen.dart';
import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import '../../../utils/custom_widgets/custom_text_form_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (controller) {
        return AppScreen(
          padding: EdgeInsets.zero,
          bgColor: AppColors.primary,
          body: Stack(
            children: [
              AppImage(
                svgAsset: AssetsPaths.splashItem1,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 10.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: AppButton(
                            buttonType: ButtonType.icon,
                            onPressed: () {
                              Get.back();
                            },
                            borderRadius: BorderRadius.circular(100),
                            bgColor: AppColors.lightGrey,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Form(
                            key: controller.loginFormkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppLogo(
                                  isAnimated: false,
                                  color: AppColors.secondary,
                                ),
                                SizedBox(height: 16.h),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          "signup".tr,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                          textAlign: TextAlign.start,
                                          padding: EdgeInsets.zero,
                                        ),
                                        AppText(
                                          "we_need_this_data".tr,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGrey2,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 21.h),
                                AppTextFormField(
                                  hintText: 'full name'.tr,
                                  controller: controller.nameController,
                                  prefixIcon:
                                      Icon(Icons.account_circle_outlined),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'User name is required.'.tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    controller.loginFormkey.currentState
                                        ?.validate();
                                  },
                                ),
                                SizedBox(height: 22.h),
                                AppTextFormField(
                                  hintText: 'email'.tr,
                                  controller: controller.emailController,
                                  prefixIcon: Icon(Icons.email_outlined),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email'.tr;
                                    }
                                    if (!RegExp(
                                            r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address'.tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    controller.loginFormkey.currentState
                                        ?.validate();
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9._%+\-@]'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22.h),
                                AppTextFormField(
                                  hintText: 'password'.tr,
                                  obscureText: true,
                                  controller: controller.passwordController,
                                  prefixIcon: Icon(Icons.lock_outline),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'enter_password'.tr;
                                    }
                                    if (value.length < 8) {
                                      return 'Passwords must be at least 8 characters.'.tr;
                                    }
                                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                                      return 'Passwords must have at least one lowercase letter (a-z).'.tr;
                                    }
                                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                      return 'Passwords must have at least one uppercase letter (A-Z).'.tr;
                                    }
                                    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]')
                                        .hasMatch(value)) {
                                      return 'Passwords must have at least one special character (!@#\$%^&*).'.tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    controller.loginFormkey.currentState
                                        ?.validate();
                                  },
                                ),
                                SizedBox(height: 22.h),
                                AppTextFormField(
                                  hintText: 're_enter_password'.tr,
                                  obscureText: true,
                                  controller:
                                      controller.reEnterPasswordController,
                                  prefixIcon: Icon(Icons.lock_outline),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'enter_password'.tr;
                                    }
                                    if (value !=
                                        controller.passwordController.text) {
                                      return 'passwords_do_not_match'.tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    controller.loginFormkey.currentState
                                        ?.validate();
                                  },
                                ),
                                SizedBox(height: 22.h),
                                Row(
                                  children: [
                                    CountryCodePicker(
                                      initialSelection: 'EG',
                                      onChanged: (country) {
                                        controller.changeCountryCode(
                                            country.dialCode!);
                                      },
                                      showDropDownButton: true,
                                      builder: (countryCode) {
                                        return Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: AppColors.textFieldColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          child: Row(
                                            children: [
                                              if (countryCode != null)
                                                Image.asset(
                                                  countryCode.flagUri!,
                                                  package:
                                                      'country_code_picker',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              const SizedBox(width: 8),
                                              // Dial code
                                              Text(
                                                countryCode?.dialCode ?? '',
                                                style: const TextStyle(
                                                    color: AppColors.black),
                                              ),
                                              const Icon(Icons.arrow_drop_down,
                                                  color: AppColors.black),
                                            ],
                                          ),
                                        );
                                      },
                                      boxDecoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    Expanded(
                                      child: AppTextFormField(
                                        controller: controller.phoneController,
                                        hintText: 'phone number'.tr,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your phone number'.tr;
                                          }
                                          if (value.length < 7) {
                                            return 'Invalid phone number'.tr;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          controller.loginFormkey.currentState
                                              ?.validate();
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9+\-\(\)\s]')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                                Row(
                                  children: [
                                    UserTypeButton(controller: controller),
                                    Expanded(
                                      child: AppButton(
                                        buttonType: ButtonType.elevated,
                                        text: "signup".tr,
                                        onPressed: () {
                                          if (controller
                                              .loginFormkey.currentState!
                                              .validate()) {
                                            if (controller.selectedUserType ==
                                                'User Type') {
                                              showAppSnackBar(
                                                alertType: AlertType.warning,
                                                message:
                                                    "Please select a user type".tr,
                                                borderRadius: 30,
                                              );
                                              //Get.snackbar("Error", "Please select a user type");
                                              return;
                                            }
                                            controller.register();
                                          }
                                        },
                                        width: double.infinity,
                                        height: 60,
                                        borderRadius: BorderRadius.circular(30),
                                        bgColor: AppColors.primary,
                                        textColor: AppColors.white,
                                        shadowColor: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
