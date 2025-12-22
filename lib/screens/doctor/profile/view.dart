import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/constants/endpoints.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/cache_helper.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/custom_widgets/customLogOutDialog.dart';
import '../../../utils/custom_widgets/custom_app_image.dart';
import '../../../utils/custom_widgets/when_change_lang_dialog.dart';
import '../../auth/login/view.dart';
import 'controller.dart';

class DoctorProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorProfileController>(
      init: DoctorProfileController(),
      builder: (controller) {
        return AppScreen(
          padding:  EdgeInsets.symmetric(horizontal: 20.w,vertical:MediaQuery.of(context).padding.top.h),
          bgColor: AppColors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppButton(
                      buttonType: ButtonType.inkwell,
                      child: Container(
                        height: 42.h,
                        width: 42.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.DoctorButtons,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          IconsaxPlusLinear.setting_2,
                          color:AppColors.settingIcon,
                          size: 24.0.r,
                        ),
                      ),
                      onPressed: () {
                       return  showLanguageDialog();

                      },
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 69.w,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 29.h,
                        ),
                        Container(
                          width: 115.w,
                          height: 115.h,
                          decoration: BoxDecoration(
                            color: AppColors.bgImageColor,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: AppImage(
                              assetImage: AssetsPaths.patientPicture,
                              width: 115.w,
                              height: 115.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 59.w,
                      ),
                    ),
                    AppButton(
                      buttonType: ButtonType.inkwell,
                      child: Container(
                        height: 42.h,
                        width: 42.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lightBink,
                        ),
                        alignment: Alignment.center,
                        child: AppImage(
                          svgAsset: AssetsPaths.logout,
                          height:24.h,
                          width: 24.h,
                        ),
                      ),
                      onPressed: () {
                        showConfirmationDialog(
                          isPatient: false,
                          title: "are you sure you want to log out?",
                          confirmButtonText: "logout",
                          onConfirm: () {
                            Get.offAll(() => LoginScreen());
                            CacheHelper().removeData(key: ApiKey.email);
                          },

                        );
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 9.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: AppText(
                    controller.Name,
                      color: AppColors.black,
                      fontSize: 20.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: AppText(
                      "doctor".tr,
                      color: AppColors.grey,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                ),
                SizedBox(
                  height: 51.h,
                ),
                AppText("full name".tr,
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 12.h,
                ),
                AppTextFormField(
                  controller: controller.Name_controller,
                  isPrefixIcon: false,
                  prefixIcon:Icon(IconsaxPlusLinear.user,size: 24,),
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  hintText: "",
                ),
                SizedBox(
                  height: 25.h,
                ),
                AppText("email".tr,
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 12.h,
                ),
                AppTextFormField(
                  controller: controller.Email_controller,
                  isPrefixIcon: true,
                  prefixIconPath: AssetsPaths.mail,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  hintText: "",
                ),
                SizedBox(
                  height: 25.h,
                ),
                AppText("password".tr,
                fontSize: 14.sp,
                  color: AppColors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: 12.h,
                ),
                AppTextFormField(
                  controller: controller.Password_controller,
                  isPrefixIcon: true,
                  prefixIconPath: AssetsPaths.lock,
                  keyboardType: TextInputType.visiblePassword,
                  readOnly: !controller.isEditingPassword,
                  obscureText: !controller.isEditingPassword,
                  hintText: controller.isEditingPassword ? "enter new password".tr : "",
                ),
                SizedBox(
                  height: 23.h,
                ),
                AppButton(
                  buttonType: ButtonType.inkwell,
                  onPressed: () {
                    if (controller.isEditingPassword) {
                      controller.savePassword();
                    } else {
                      controller.toggleEditPassword();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColors.DoctorButtons,
                    ),
                    height: 38.h,
                    child: Center(
                      child: AppText(
                        controller.isEditingPassword ? "save".tr : "change Password".tr,
                          color: AppColors.settingIcon,
                          fontFamily: "Kaleko",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
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
void showLanguageDialog() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'Select Language'.tr,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
            SizedBox(height: 20.h),
            const WhenChangeLangDialog(),
            SizedBox(height: 20.h),
            AppButton(
              text: 'Close'.tr,
              onPressed: Get.back,
              width: double.infinity,
              buttonType: ButtonType.outlined,
              borderColor: AppColors.secondary,
              textColor: AppColors.secondary,
            ),
          ],
        ),
      ),
    ),
  );
}
