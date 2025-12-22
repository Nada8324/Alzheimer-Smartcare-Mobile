import 'dart:ui';

import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alzheimer_smartcare/screens/patient/games/controller.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';

class ScoresPage extends StatelessWidget {
  const ScoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientGameController>();

    return AppScreen(
      bgColor: AppColors.primary,
      padding: EdgeInsets.zero,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: AppImage(
              svgAsset: AssetsPaths.splashItem1,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AppImage(
                  assetImage: AssetsPaths.LogoPNG,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h,vertical: MediaQuery.of(context).padding.top.h),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.white, size: 30.w),
                      onPressed: () => Get.back(),
                    ),
                    SizedBox(width: 20.w),
                    AppText(
                      "Memory Match Scores".tr,
                      color: AppColors.white,
                      fontSize: 24.sp,
                      maxLines: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                // High Score Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AppText(
                        "Best Score".tr,
                        color: AppColors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 10.h),
                      Obx(() => AppText(
                        controller.highScore.value == 99999
                            ? "0"
                            : "${controller.highScore.value}",
                        color: AppColors.white,
                        fontSize: 42.sp,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Scores Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      AppText(
                        "Game ".tr,
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      Spacer(),
                      AppText(
                        "Attempts".tr,
                        color: AppColors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),

                // Scores List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator(color: AppColors.white));
                    }

                    if (controller.allScores.isEmpty) {
                      return Center(
                        child: AppText(
                          "No scores yet".tr,
                          color: AppColors.white,
                          fontSize: 24.sp,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: controller.allScores.length,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.white.withOpacity(0.3),
                        height: 1.h,
                      ),
                      itemBuilder: (context, index) {
                        final score = controller.allScores[index];
                        final isBestScore = score == controller.highScore.value;

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: isBestScore
                                ? AppColors.lightBlue.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondary,
                                ),
                                alignment: Alignment.center,
                                child: AppText(
                                  "${index + 1}",
                                  color: AppColors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              AppText(
                                "${"Game ".tr} ${index + 1}",
                                color: AppColors.white,
                                fontSize: 20.sp,
                              ),
                              Spacer(),
                              Container(
                                  child: AppText(
                                    "$score",
                                    color: AppColors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkBlue,
                                    borderRadius: BorderRadius.circular(10.r),

                                  ),),
                                  if (isBestScore) ...[
                                SizedBox(width: 10.w),
                                Icon(Icons.star, color: Colors.yellow, size: 24.w),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}