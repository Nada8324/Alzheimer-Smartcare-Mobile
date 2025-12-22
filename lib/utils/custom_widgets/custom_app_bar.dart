import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../global_controllers/auth_controller.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import 'custom_app_image.dart';
import 'custom_button.dart';
import 'custom_text.dart';

AppBar customAppBar(
    BuildContext context, {
      Function? onWillPop,
      Widget? leading,
      Widget? titleWidget,
      Widget? bottomWidget,
      bool titleHero = false,
      bool hideLogo = false,
      String? titleImageIcon,
      Color backgroundColor = AppColors.secondary,
      Color? iconImageColor,
      bool? withoutBackButton,
      List<Widget>? actions,
      double? trailingSpace,
      double? bottomHeight,
      double? leadingSpace,
      String? title,
    }) {
  return AppBar(
    titleSpacing: 0,
    bottom: PreferredSize(
      preferredSize: Size(Get.width, bottomWidget == null ? 0 : (bottomHeight ?? 65)),
      child: bottomWidget ?? const SizedBox(),
    ),
    backgroundColor: Get.isDarkMode ? AppColors.darkBlue : backgroundColor,
    automaticallyImplyLeading: false,
    title: GetBuilder<AuthController>(
      init: AuthController(),
      builder: (auth) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: leadingSpace ?? 20),
            if (withoutBackButton != true)
              AppButton.back(
                onPressed: onWillPop == null
                    ? () {
                  EasyLoading.dismiss();
                  Get.back();
                }
                    : () {
                  EasyLoading.dismiss();
                  onWillPop();
                },
              ),
            SizedBox(width: trailingSpace ?? (withoutBackButton == true ? 80 : 0)),
            if (leading != null) leading,
            Expanded(
              child: titleWidget ??
                  (title != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (titleImageIcon != null)
                        AppImage(
                          assetImage: titleImageIcon,
                          color: iconImageColor,
                          height: 20,
                        ),
                      if (titleImageIcon != null) const SizedBox(width: 5),
                      titleHero
                          ? Hero(
                        tag: title,
                        child: AppText(
                          title,
                          fontSize: 15,
                          maxLines: 1,
                          autoSized: true,
                          color: AppColors.greyText,
                          textAlign: TextAlign.start,
                        ),
                      )
                          : AppText(
                        title,
                        fontSize: 15,
                        maxLines: 1,
                        autoSized: true,
                        color: AppColors.greyText,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
                      : const SizedBox()),
            ),
            if (actions != null) ...actions,

            if (!hideLogo)
              AppImage(
                svgAsset: AssetsPaths.appLogo,
                isHero: true,
                height: 40,
              ),
            SizedBox(width: trailingSpace ?? (hideLogo != true ? 20 : 0)),

          ],
        );
      },
    ),
    elevation: 0,
  );
}
