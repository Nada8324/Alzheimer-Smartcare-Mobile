import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppText extends StatelessWidget {
  final String text;
  final String? subText;
  final double subTextSize;
  final Color? subTextColor;
  final EdgeInsets? padding;
  final Function()? onTap;
  final double fontSize;
  final TextAlign textAlign;
  final Color? color;
  final TextDirection? textDirection;
  final int? maxLines;
  final double? maxWidth;
  final FontWeight fontWeight;
  final double height;
  final bool autoSized;
  final Color? darkModeColor;
  final TextDecoration textDecoration;
  final String fontFamily;
  const AppText(this.text,
      {Key? key,
      this.subText,
      this.subTextSize = 14,
      this.subTextColor,
      this.textDecoration = TextDecoration.none,
      this.darkModeColor,
      this.autoSized = false,
      this.onTap,
      this.textAlign = TextAlign.start,
      this.maxWidth,
      this.height = 1.5,
      this.textDirection,
      this.fontWeight = FontWeight.normal,
      this.padding,
      this.color,
      this.fontSize = 14,
      this.fontFamily="Montserrat-Arabic",
      this.maxLines})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: maxWidth ?? Get.width, minWidth: 0),
        child: !autoSized
            ? (subText != null
                ? RichText(
                    text: TextSpan(
                        text: text,
                        style: TextStyle(
                            color: Get.isDarkMode
                                ? darkModeColor ?? Colors.white
                                : (color ?? Colors.black),
                            height: height,
                            fontFamily: "Montserrat-Arabic",
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            decoration: textDecoration),
                        children: [
                        TextSpan(
                          text: subText,
                          style: TextStyle(
                              color: Get.isDarkMode
                                  ? darkModeColor ?? Colors.white
                                  : (subTextColor ?? Colors.black),
                              height: height,
                              fontFamily: "Montserrat-Arabic",
                              fontSize: subTextSize,
                              fontWeight: fontWeight,
                              decoration: textDecoration),
                        )
                      ]))
                : Text(
                    text,
                    maxLines: maxLines??1000000000,
                    textScaler:const TextScaler.linear(1),
                    textAlign: textAlign,
                    overflow: TextOverflow.ellipsis,
                    textDirection: textDirection ??
                        (Get.locale == const Locale("en", "US")
                            ? TextDirection.ltr
                            : TextDirection.rtl),
                    style: TextStyle(
                        color: Get.isDarkMode
                            ? darkModeColor ?? Colors.white
                            : (color ?? Colors.black),
                        height: height,
                        fontFamily: "Montserrat-Arabic",
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        decoration: textDecoration),
                  ))
            : AutoSizeText(
                text,
                textScaleFactor: 1,
                maxFontSize: fontSize,
                minFontSize: 1,
                textDirection: textDirection ??
                    (Get.locale == const Locale("en", "US")
                        ? TextDirection.ltr
                        : TextDirection.rtl),
                textAlign: textAlign,
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines,
                style: TextStyle(
                    color:
                        Get.isDarkMode ? darkModeColor ?? Colors.white : color,
                    height: height,
                    fontFamily: "Montserrat-Arabic",
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    decoration: textDecoration),
              ),
      ),
    );
  }
}
