import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import 'custom_app_image.dart';
import 'custom_text.dart';

class AppLogo extends StatelessWidget {

  final int logoSize;
  final Color color;
  final int primaryTextSize;
  final int secondaryTextSize;
  final bool isAnimated;
  final MainAxisAlignment alignment;


  const AppLogo({
    super.key ,
    this.logoSize = 90,
    this.color = AppColors.white,
    this.primaryTextSize = 30,
    this.secondaryTextSize = 14,
    this.isAnimated = false,
    this.alignment = MainAxisAlignment.center
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment,
      children: [
        isAnimated ? Lottie.asset(AssetsPaths.loadingJSON) : AppImage(
          svgAsset: AssetsPaths.appLogo,
          color: color,
          height: logoSize.h,
          width: logoSize.w,
        ) ,
        AppText(
          "alzheimer".tr,
          fontSize: primaryTextSize.sp,
          fontWeight: FontWeight.w900,
          color: color,
        ),
        AppText(
          "smartcare".tr,
          fontSize: secondaryTextSize.sp ,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ],
    );
  }
}
