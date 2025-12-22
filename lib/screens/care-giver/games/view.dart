import 'dart:ui';
import 'package:alzheimer_smartcare/screens/patient/games/controller.dart';
import 'package:card_game/card_game.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/bottom_sheet.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants/alerts.dart';
import '../../patient/games/game.dart';


class CareGiverGameScreen extends StatelessWidget {
  const CareGiverGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientGameController>(
      init: PatientGameController(),
      builder: (controller) {
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      "High score".tr,
                      color: AppColors.white,
                      fontSize: 64.sp,
                      height: 77.45 / 64.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      controller.highScore==99999?"0":"${controller.highScore}",
                      color: AppColors.white,
                      fontSize: 64.sp,
                      height: 77.45 / 64.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    AppButton(
                      buttonType: ButtonType.elevated,
                      borderRadius: BorderRadius.circular(10.r),
                      height: 59.h,
                      width: 201.w,
                      bgColor: AppColors.lightBlue,
                      child: AppText(
                        fontSize: 32.sp,
                        "New Game".tr,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      onPressed: () {

                        MemoryMatch.savedState = null;
                        Get.to(MemoryMatch());
                      },
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    AppButton(
                      buttonType: ButtonType.elevated,
                      borderRadius: BorderRadius.circular(10.r),
                      height: 59.h,
                      width: 201.w,
                      bgColor: AppColors.secondary,
                      child: AppText(
                        fontSize: 32.sp,
                        "Continue".tr,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      onPressed: () {
                        if (MemoryMatch.savedState != null) {
                          Get.to(MemoryMatch(
                            initialState: MemoryMatch.savedState,
                          ));
                        } else {
                          showAppSnackBar(
                            alertType: AlertType.fail,
                            message: "No Saved Game.".tr,
                            borderRadius: 30.r,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    AppButton(
                      buttonType: ButtonType.elevated,
                      borderRadius: BorderRadius.circular(10.r),
                      height: 59.h,
                      width: 201.w,
                      bgColor: AppColors.lightBlue,
                      child: AppText(
                        fontSize: 32.sp,
                        "Scores".tr,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      onPressed: () {
                        // Navigate to scores page
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

