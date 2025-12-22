import 'package:alzheimer_smartcare/screens/care-giver/layout/view.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/app_logo.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/endpoints.dart';
import '../../utils/custom_helpers/cache_helper.dart';
import '../auth/login/view.dart';
import '../doctor/layout/view.dart';
import '../on-boarding/view.dart';
import '../patient/layout/view.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      String? token = CacheHelper().getDataString(key: ApiKey.email);
      String? userType = CacheHelper().getUserInfo()?.userType;

      if (token != null && userType != null) {
        if (userType == "Doctor") {
          Get.off(() => DoctorLayoutScreen());
        } else if (userType == "Patient") {
          Get.off(() => PatientLayoutScreen());
        } else {
          Get.off(() => CareGiverLayoutScreen());
        }
      } else {
        Get.off(() => OnBoardingScreen());
      }
    });
    return AppScreen(
      padding: EdgeInsets.zero,
      bgColor: AppColors.primary,
      body: Stack(
        children: [
          AppImage(
            svgAsset: AssetsPaths.splashItem1,
          ),
          Center(
            child: AppLogo(
              isAnimated: true,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AppImage(
              svgAsset: AssetsPaths.splashItem2,
            ),
          ),
        ],
      ),
    );
  }
}