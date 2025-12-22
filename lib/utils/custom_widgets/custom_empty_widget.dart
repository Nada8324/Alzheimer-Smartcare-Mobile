import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import 'custom_app_image.dart';
import 'custom_text.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String? image;
  final String? text;
  final double? imageWidth;
  final double opacity;
  final Color? textColor;
  const CustomEmptyWidget(
      {Key? key,
      this.imageWidth,
      this.textColor,
      this.opacity = 0.2,
      this.image,
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 0, maxHeight: Get.height / 2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: imageWidth ?? Get.width / 2, child: _image()),
              AppText(
                text ?? "no_results".tr,
                fontSize: 14,
                color: textColor ?? AppColors.lightColor,
                fontWeight: FontWeight.w600,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    return Opacity(
      opacity: opacity,
      child: AppImage(
        assetImage: image ?? AssetsPaths.appLogo,
        fit: BoxFit.contain,
        width: imageWidth ?? Get.width / 2,
      ),
    );
  }
}
