import 'dart:math';
import 'package:alzheimer_smartcare/utils/constants/styles_and_themes.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../global_controllers/main_app_controller.dart';
import '../custom_widgets/custom_text.dart';
import 'assets.dart';
import 'colors.dart';

enum AlertType { success, fail, warning, delete }

showAppSnackBar(
    {@required AlertType? alertType,
    String? message,
    Widget? child,
    bool withoutIcon = false,
    EdgeInsets? margin,
    double? borderRadius,
    int? durationSeconds}) async {
  Get.closeCurrentSnackbar();
  Get.closeAllSnackbars();
  Get.showSnackbar(GetSnackBar(
    isDismissible: true,
    borderRadius: borderRadius ?? 0,
    animationDuration: const Duration(milliseconds: 500),
    margin: margin ?? EdgeInsets.zero,
    icon: withoutIcon
        ? null
        : Icon(
            alertType == AlertType.success
                ? Icons.check
                : (alertType == AlertType.fail
                    ? Icons.close
                    : Icons.warning_rounded),
            color: AppColors.white,
          ),
    duration: Duration(seconds: durationSeconds ?? 2),
    messageText: child,
    message: message?.substring(0, min(message.length, 200)) ?? "",
    backgroundColor: alertType == AlertType.success
        ? AppColors.primary.withOpacity(.9)
        : (alertType == AlertType.fail
            ? AppColors.redBlack.withOpacity(.9)
            : AppColors.warning.withOpacity(.9)),
  ));
}

showAppAlertDialog(
    {@required AlertType? alertType,
    @required String? message,
    String? underMessage,
    String? acceptText,
    String? cancelText,
    String? underMessageTitle,
    String? underMessageBody,
    Function()? onAccept,
    Function()? onCancel,
    TextAlign? underMessageTextAlign,
    int? durationSeconds}) async {
  if (durationSeconds != null) {
    Future.delayed(Duration(seconds: durationSeconds), () {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    });
  }
  DeviceScreenType deviceType =
      await MainAppController.getDeviceTypeAndOrientation();
  await Get.defaultDialog(
      title: "",
      onWillPop: () {
        if (onCancel == null && onAccept != null) {
          onAccept.call();
        } else {
          onCancel?.call();
        }
        Get.back();
        return Future.value(false);
      },
      titleStyle: const TextStyle(fontSize: 0),
      content: SizedBox(
        width: deviceType != DeviceScreenType.mobile ? Get.width / 3 : null,
        child: Center(
          child: _alertBody(
              alertType,
              message,
              underMessage,
              onAccept,
              acceptText,
              onCancel,
              cancelText,
              underMessageTitle,
              underMessageBody,
              underMessageTextAlign
              ),
        ),
      ));
}

Column _alertBody(
    AlertType? alertType,
    String? message,
    String? underMessage,
    Function()? onAccept,
    String? acceptText,
    Function()? onCancel,
    String? cancelText,
    String? underMessageTitle,
    String? underMessageBody,
    TextAlign? underMessageTextAlign) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: Get.width / 4,
        height: Get.width / 4,
        child: AppImage(
          assetImage: alertType == AlertType.success
              ? AssetsPaths.doneGIF
              : (alertType == AlertType.fail
                  ? AssetsPaths.wrongFeedbackGIF
                  : (alertType == AlertType.warning
                      ? AssetsPaths.alertAnimationGIF
                      : AssetsPaths.trashGIF)),
        ),
      ),
      AppText(
        message ?? "",
        textAlign: TextAlign.center,
        padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: underMessage == null ? 20 : 10),
      ),
      underMessage == null
          ? const SizedBox()
          : AppText(
              underMessage,
              textAlign: underMessageTextAlign ?? TextAlign.center,
              color: AppColors.darkBlue,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            ),
      Offstage(
        offstage: underMessageTitle == null,
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.greyText.withOpacity(.2),
          ),
          child: Column(
            children: [
              AppText(
                underMessageTitle ?? "",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                    border: Border.all(color: AppColors.greyText)),
                child: InkWell(
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: underMessageBody ?? ""));
                    showAppSnackBar(
                        alertType: AlertType.success, message: "copied".tr);
                  },
                  child: AppText(
                    underMessageBody ?? "",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Row(
        children: [
          onAccept == null
              ? const SizedBox()
              : Expanded(
                  child: TextButton(
                    style: buttonStyle(
                      bgColor: alertType == AlertType.success
                          ? AppColors.primary
                          : (alertType == AlertType.fail ||
                                  alertType == AlertType.delete
                              ? AppColors.redBlack
                              : AppColors.warning),
                    ),
                    onPressed: () async {
                      Get.back();
                      await onAccept.call();
                    },
                    child: AppText(
                      acceptText ?? "accept_cancel_permission".tr,
                      fontSize: acceptText != null ? 11 : 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
          SizedBox(
            width: onCancel == null ? 0 : 10,
          ),
          onCancel == null
              ? const SizedBox()
              : Expanded(
                  child: TextButton(
                    style:
                        buttonStyle(bgColor: AppColors.greyText),
                    onPressed: () {
                      Get.back();
                      onCancel.call();
                    },
                    child: AppText(
                      cancelText ?? "no".tr,
                      fontSize: acceptText != null ? 11 : 14,
                    ),
                  ),
                ),
        ],
      )
    ],
  );
}
