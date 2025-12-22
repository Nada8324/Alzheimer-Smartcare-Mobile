import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../constants/colors.dart';
import '../constants/styles_and_themes.dart';
import 'custom_app_image.dart';
import 'custom_text.dart';

enum ButtonType {
  outlined,
  elevated,
  elevatedWithIconRow,
  text,
  inkwell,
  icon,
  back,
  floating,
}

class AppButton extends StatelessWidget {
  final Color? textColor, bgColor, iconColor, shadowColor, borderColor;
  final String? text;
  final double? width, height, iconSize, textSize;
  final IconData? iconData;
  final String? imageIcon;
  final String? svgImageIcon;
  final Widget? child;
  final ButtonType? buttonType;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double borderWidth;
  final int index;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final Function()? onPressed;
  const AppButton(
      {Key? key,
      this.textSize,
      this.svgImageIcon,
      this.index = 0,
      this.textDecoration = TextDecoration.none,
      this.imageIcon,
      this.borderWidth = 0,
      this.width,
      this.height,
      this.fontWeight = FontWeight.bold,
      this.borderRadius,
      this.iconSize,
      this.onPressed,
      required this.buttonType,
      this.text,
      this.textColor,
      this.bgColor,
      this.iconColor,
      this.shadowColor,
      this.borderColor,
      this.iconData,
      this.padding,
      this.child})
      : super(key: key);
  factory AppButton.back(
          {Function()? onPressed,
          Color? iconColor,
          double? width,
          height,
          iconSize,
          textSize,
          IconData? iconData,
          String? imageIcon,
          Widget? child,
          BorderRadius? borderRadius,
          EdgeInsets? padding}) =>
      AppButton(
        buttonType: ButtonType.icon,
        iconColor: AppColors.greyText,
        borderColor: AppColors.secondary,
        iconData: IconsaxPlusLinear.arrow_left,
        onPressed: onPressed ?? () => Get.back(),
        iconSize: iconSize,
        imageIcon: imageIcon,
        padding: padding,
        textSize: textSize,
        bgColor: AppColors.transparent,
        width: width,
        height: height,
        borderRadius: borderRadius,
        child: child,
      );
  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.back:
        return LimitedBox(
            maxWidth: Get.width,
            child: AppButton(
              buttonType: ButtonType.icon,
              iconColor: AppColors.primary,
              iconData: Icons.arrow_back_ios_rounded,
              onPressed: onPressed ?? () => Get.back(),
            )
        );
      case ButtonType.inkwell:
        return LimitedBox(
            maxWidth: Get.width,
            child: InkWell(
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              onTap: onPressed,
              child: Container(
                  width: width,
                  height: height,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: text != null
                      ? AppText(
                          text ?? "",
                          textDecoration: textDecoration,
                          autoSized: true,
                          fontSize: textSize ?? 16,
                          maxLines: 1,
                          color: (textColor ?? AppColors.secondary),
                          darkModeColor: textColor ?? AppColors.white,
                        )
                      : (child??(iconData != null
                      ? Icon(
                          iconData,
                          color: iconColor,
                          size: iconSize,
                        )
                      : svgImageIcon != null
                          ? AppImage(
                              svgAsset: svgImageIcon,
                              color: iconColor,
                              width: iconSize,
                              fit: BoxFit.contain,
                            )
                          : (imageIcon != null
                              ? ImageIcon(
                                  AssetImage(imageIcon ?? ""),
                                  color: iconColor,
                                  size: iconSize,
                                )
                              : const SizedBox())))),
            ));
      case ButtonType.text:
        return LimitedBox(
            maxWidth: Get.width,
            child: TextButton(
              onPressed: onPressed,
              style: buttonStyle(
                bgColor: bgColor,
                borderColor: borderColor,
                borderRadius: borderRadius,
                padding: padding,
                width: width,
                height: height,
                shadowColor: shadowColor,
              ),
              child: child ??
                  AppText(
                    text ?? "",
                    textDecoration: textDecoration,
                    fontWeight: fontWeight,
                    autoSized: true,
                    maxLines: 1,
                    fontSize: textSize ?? 16,
                    color: (textColor ?? AppColors.white),
                    darkModeColor: textColor ?? AppColors.white,
                  ),
            ));
      case ButtonType.elevated:
        return LimitedBox(
            maxWidth: Get.width,
            child: ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle(
                bgColor: bgColor,
                width: width,
                height: height,
                borderColor: borderColor,
                borderRadius: borderRadius,
                padding: padding,
                shadowColor: shadowColor,
              ),
              child: child ??
                  AppText(
                    text ?? "",
                    textDecoration: textDecoration,
                    autoSized: true,
                    maxLines: 1,
                    fontSize: textSize ?? 16,
                    color: (textColor ?? AppColors.white),
                    darkModeColor: textColor ?? AppColors.white,
                  ),
            ));
      case ButtonType.elevatedWithIconRow:
        return LimitedBox(
            maxWidth: Get.width,
            child: ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle(
                bgColor: bgColor,
                width: width,
                height: height,
                borderColor: borderColor,
                borderRadius: borderRadius,
                padding: padding,
                shadowColor: shadowColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  child ??
                      AppText(
                        text ?? "",
                        textDecoration: textDecoration,
                        autoSized: true,
                        maxLines: 1,
                        fontSize: textSize ?? 16,
                        color: (textColor ?? AppColors.white),
                        darkModeColor: textColor ?? AppColors.white,
                      ),
                  const SizedBox(
                    width: 6,
                  ),
                  iconData != null
                      ? Icon(
                          iconData,
                          color: iconColor,
                          size: iconSize,
                        )
                      : svgImageIcon != null
                          ? AppImage(
                              svgAsset: svgImageIcon,
                              color: iconColor,
                              width: iconSize,
                              fit: BoxFit.contain,
                            )
                          : (imageIcon != null
                              ? ImageIcon(
                                  AssetImage(imageIcon ?? ""),
                                  color: iconColor,
                                  size: iconSize,
                                )
                              : const SizedBox())
                ],
              ),
            ));
      case ButtonType.outlined:
        return LimitedBox(
            maxWidth: Get.width,
            child: OutlinedButton(
              onPressed: onPressed,
              style: buttonStyle(
                outlined: true,
                width: width,
                height: height,
                bgColor: AppColors.transparent,
                borderColor: borderColor ?? AppColors.primary,
                borderRadius: borderRadius,
                padding: padding,
                shadowColor: shadowColor,
              ),
              child: child ??
                  AppText(
                    text ?? "",
                    textDecoration: textDecoration,
                    autoSized: true,
                    maxLines: 1,
                    fontSize: textSize ?? 16,
                    color: (textColor ?? AppColors.primary),
                    darkModeColor: textColor ?? AppColors.white,
                  ),
            ));
      case ButtonType.icon:
        return LimitedBox(
            maxWidth: Get.width,
            child: InkWell(
              onTap: onPressed,
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      borderRadius: borderRadius ?? BorderRadius.circular(10),
                      border: Border.all(
                          width: borderWidth,
                          color: borderColor ?? AppColors.transparent),
                      color: bgColor ?? AppColors.primary),
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                      minWidth: 0,
                      maxWidth: width ?? 50,
                      maxHeight: height ?? 50,
                      minHeight: 0),
                  padding: padding ?? const EdgeInsets.all(2),
                  child: child ??
                      (iconData != null
                          ? Icon(
                              iconData,
                              color: iconColor,
                              size: iconSize,
                            )
                          :( svgImageIcon != null
                          ? AppImage(
                              svgAsset: svgImageIcon,
                              color: iconColor,
                              width: iconSize,
                              fit: BoxFit.contain,
                            )
                          :(imageIcon != null
                              ? ImageIcon(
                                  AssetImage(imageIcon ?? ""),
                                  color: iconColor,
                                  size: iconSize,
                                )
                              : AppText(
                                  text ?? "",
                                  textDecoration: textDecoration,
                                  fontSize: textSize ?? 16,
                                  autoSized: true,
                                  maxLines: 1,
                                  color: (textColor ?? AppColors.white),
                                  darkModeColor: textColor ?? AppColors.white,
                                ))))),
            ));

      case ButtonType.floating:
        return LimitedBox(
            maxWidth: Get.width,
            child: FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(90),
                  side: borderWidth > 0
                      ? BorderSide(
                          color: borderColor ?? AppColors.lightColor,
                          width: borderWidth)
                      : BorderSide.none),
              child: Container(
                  width: width,
                  height: height,
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                      minWidth: 0,
                      maxWidth: width ?? 40,
                      maxHeight: height ?? 40,
                      minHeight: 0),
                  padding: padding ?? const EdgeInsets.all(2),
                  child: child ??
                      (iconData != null
                          ? Icon(
                              iconData,
                              color: iconColor,
                              size: iconSize,
                            )
                          : (imageIcon != null
                              ? ImageIcon(
                                  AssetImage(imageIcon ?? ""),
                                  color: iconColor,
                                  size: iconSize,
                                )
                              : AppText(
                                  text ?? "",
                                  textDecoration: textDecoration,
                                  fontSize: textSize ?? 16,
                                  autoSized: true,
                                  maxLines: 1,
                                  color: (textColor ?? AppColors.white),
                                  darkModeColor: textColor ?? AppColors.white,
                                )))),
            ));
      default:
        return LimitedBox(
            maxWidth: Get.width, maxHeight: 50, child: const SizedBox());
    }
  }
}
