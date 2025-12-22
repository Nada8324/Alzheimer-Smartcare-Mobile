import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../../utils/constants/assets.dart';
import 'controller.dart';

class DoctorLayoutScreen extends StatelessWidget {
  final DoctorLayoutController controller = Get.put(DoctorLayoutController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorLayoutController>(
        init: DoctorLayoutController(),
        builder: (controller) {
          return AppScreen(
            bgColor: AppColors.white,
            body: controller.screens[controller.index],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.index,
              onTap: controller.changeTab,
              items: [
                BottomNavigationBarItem(
                  icon: AppImage(
                    svgAsset:  AssetsPaths.Scan,
                    color: controller.index == 0
                        ? AppColors.secondary
                        : AppColors.inActiveIconPatient,
                    width: 25.w,
                    height: 25.h,
                  ),
                  activeIcon: AppImage(
                    svgAsset:AssetsPaths.Scan,
                    color: AppColors.secondary,
                    width: 25.w,
                    height: 25.h,
                  ),
                  label: 'Scan'.tr,
                ),
                BottomNavigationBarItem(
                  icon: AppImage(
                    svgAsset: AssetsPaths.profile,
                    width: 25.w,
                    height: 25.h,
                    color: controller.index == 1
                        ? AppColors.secondary
                        : AppColors.inActiveIconPatient,
                  ),
                  activeIcon: AppImage(
                    svgAsset:AssetsPaths.profile,
                    color: AppColors.secondary,
                    width: 25.w,
                    height: 25.h,
                  ),
                  label: 'Profile'.tr,
                ),
              ],
              selectedItemColor: AppColors.secondary,
              unselectedItemColor: AppColors.inActiveIconPatient,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
            ),
          );
        }
    );
    }
  }