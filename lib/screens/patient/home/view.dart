import 'dart:convert';
import 'dart:ui';

import 'package:alzheimer_smartcare/screens/patient/home/MemoriesScreen.dart';
import 'package:alzheimer_smartcare/screens/patient/home/controller.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/bottom_sheet.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../global_controllers/main_app_controller.dart';
import '../AddReminders/controller.dart';
import '../layout/controller.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskController());
    return GetBuilder<PatientHomeController>(
      init: PatientHomeController(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(child: MainAppController.showLoading());
        }
        return AppScreen(
            padding: EdgeInsets.only(bottom: 75.h),
            bgColor: AppColors.white,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r)),
                      color: AppColors.secondary,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top.h,
                        ),
                        Row(
                          children: [
                            AppText(
                              "Hello".tr,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ),
                            AppText(
                              " ${controller.user.value?.fullName}",
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ),
                            Spacer(),
                            Container(
                              height: 36.h,
                              padding: EdgeInsets.symmetric(horizontal: 9.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: AppColors.white,
                              ),
                              child: Row(
                                children: [
                                  AppImage(
                                    svgAsset: AssetsPaths.starsSVG,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  AppText(
                                    "${controller.patientGameController.highScore == 99999 ? "0" : "${controller.patientGameController.highScore}"} ${"Points".tr}",
                                    fontSize: 13.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        FutureBuilder<Widget>(
                          future: controller.BuildSliderSection(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: MainAppController
                                      .showLoading()); // Show loading
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      "Error: ${snapshot.error}")); // Handle error
                            } else {
                              EasyLoading.dismiss();
                              return snapshot.data ??
                                  Center(child: Text("No reminders found"));
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(
                              "Memories".tr,
                              height: 29.05 / 24.sp,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              color: AppColors.homeGreyText,
                            ),
                            Spacer(),
                            AppButton(
                              fontWeight: FontWeight.w700,
                              padding: EdgeInsets.zero,
                              textColor: AppColors.secondary,
                              bgColor: AppColors.transparent,
                              buttonType: ButtonType.text,
                              text: "View All".tr,
                              width: 50.w,
                              height: 15.h,
                              onPressed: () {
                                Get.to(() => MemoriesScreen());
                              },
                            )
                          ],
                        ),
                        Container(
                          height: 175.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.bgImageColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ]),
                          child: Obx(() {
                            if (controller.randomFace.value == null) {
                              return Column(
                                children: [
                                  AppImage(
                                    assetImage: AssetsPaths.memoriesPNG,
                                    width: double.infinity,
                                    height: 147,
                                    borderRadius: BorderRadius.circular(10.r),
                                    fit: BoxFit.cover,
                                  ),
                                  Center(
                                      child: AppText(
                                    "No Memories found",
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.homeGreyText,
                                  )),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                AppButton(

                                  child: AppImage(
                                    memoryImageBytes: base64Decode(
                                        controller.randomFace.value!.imageBase64),
                                    width: double.infinity,
                                    height: 147,
                                    borderRadius: BorderRadius.circular(10.r),

                                  ),
                                  buttonType: ButtonType.inkwell,
                                  height: 147,
                                  borderRadius: BorderRadius.circular(10.r),
                                  onPressed: () => Get.to(()=>MemoriesScreen()),
                                ),
                                AppText(
                                  controller.randomFace.value!.name,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.homeGreyText,
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        AppText(
                          "Game".tr,
                          height: 29.05 / 24.sp,
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: AppColors.homeGreyText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AppButton(
                          buttonType: ButtonType.inkwell,
                          onPressed: () {
                            Get.find<PatientLayoutController>().changeTab(0);
                          },
                          child: Container(
                            height: 147.h,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                    child: AppImage(
                                      assetImage: AssetsPaths.gamesPNG,
                                      height: 147.h,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 147.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.photoShadow
                                          .withValues(alpha: 0.36),
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                ),
                                AppText(
                                  "${"High score".tr} : ${controller.patientGameController.highScore == 99999 ? "0" : "${controller.patientGameController.highScore}"}",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp,
                                  color: AppColors.white,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
