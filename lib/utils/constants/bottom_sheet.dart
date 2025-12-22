import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'colors.dart';

showAppBottomSheet(
    {required Widget child,
    Widget? iconWidget,
    IconData? iconData,
    Color? bgColor,
    double? maxHeight,
    bool hideClose = false,
    bool hideTopLine = false,
    bool dismissable = false,
    EdgeInsets? padding,
    Function()? onTapIcon}) async {
 return await Get.bottomSheet(
      WillPopScope(
        onWillPop: () {
          if (dismissable) {
            Get.back();
          }
          return Future.value(false);
        },
        child: Container(
          // height: Get.height / 2,
          padding: const EdgeInsets.only(top: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                  child: Container(
                      constraints: BoxConstraints(
                          maxHeight: maxHeight ?? Get.height / 2, minHeight: 0),
                      padding: padding,
                      decoration:
                          BoxDecoration(color: bgColor ?? AppColors.white),
                      child: SingleChildScrollView(
                        child: child))),
              hideClose
                  ? const SizedBox()
                  : Positioned(
                      top: -20,
                      left: 50,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(90),
                        onTap: onTapIcon ??
                            () {
                              Get.back();
                            },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.secondary,
                          child: iconWidget ??
                              Icon(
                                iconData ?? Icons.close,
                                color: AppColors.white,
                              ),
                        ),
                      )),
              Offstage(
                offstage: hideTopLine,
                child: ResponsiveBuilder(builder: (context, info) {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: []);
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: Get.width / (!info.isMobile ? 6 : 3),
                    height: 7,
                    decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(45)),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      useRootNavigator: dismissable,
      isScrollControlled: true,
      enableDrag: dismissable);
}
