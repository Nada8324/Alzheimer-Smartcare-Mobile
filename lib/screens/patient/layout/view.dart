import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/custom_widgets/custom_bottom_nav_bar.dart';
import 'controller.dart';
class PatientLayoutScreen extends StatelessWidget {

  final PatientLayoutController controller = Get.put(PatientLayoutController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientLayoutController>(
      builder: (controller) {
        return AppScreen(
          extendBody: true,
          bgColor: AppColors.white,
          bottomNavigationBar: buildBottomNavBar(
            changeTab: controller.changeTab,
            currentIndex: controller.index,
            items: controller.navItems,
            FABColor: AppColors.secondary,
            FABOutlineColor:AppColors.lightBlue,
            FABAsset: AssetsPaths.home,
            inActiveColor: AppColors.inActiveIconPatient,
            activeColor: AppColors.secondary,
            FABImageColor: controller.index == 2 ? AppColors.white : AppColors.inActiveIconPatient
          ),
          body: controller.screens[controller.index],
        );
      },
    );
  }
}
