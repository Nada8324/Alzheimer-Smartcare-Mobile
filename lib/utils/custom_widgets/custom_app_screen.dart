import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class AppScreen extends StatelessWidget {
  final Function()? onWillPop;
  final Function()? onTapScreen;
  final EdgeInsets? padding;
  final Alignment stackAlignment;
  final List<Widget> behindBody;
  final List<Widget> aboveBody;
  final Color bgColor;
  final Widget? body;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? bottomNavigationBar;
  final Clip clip;
  final bool extendBody;
  const AppScreen(
      {Key? key,
      this.clip = Clip.none,
      this.bottomNavigationBar,
      this.stackAlignment = Alignment.center,
      this.bgColor = AppColors.lightColor,
      this.aboveBody = const [],
      this.floatingActionButtonLocation,
      this.behindBody = const [],
      this.floatingActionButton,
      this.scaffoldKey,
      this.body,
      this.appBar,
      this.padding,
      this.onTapScreen,
      this.extendBody = false,
      this.onWillPop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          EasyLoading.dismiss();
          if (onWillPop == null) {
            Get.back();
          } else {
            onWillPop?.call();
          }

          return Future.value(false);
        },
        child: GestureDetector(
            onTap: () {
              if (onTapScreen != null) {
                onTapScreen?.call();
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            child: Stack(
              children: [
                Scaffold(
                  extendBody: extendBody,
                  key: scaffoldKey,
                  bottomNavigationBar: bottomNavigationBar,
                  backgroundColor: bgColor,
                  //لعدم ارتفاع الصور مع فتح الكيبورد
                  resizeToAvoidBottomInset: true,
                  appBar: appBar,
                  floatingActionButton: floatingActionButton,
                  floatingActionButtonLocation: floatingActionButtonLocation,
                  body: Stack(
                    clipBehavior: Clip.none,
                    alignment: stackAlignment,
                    children: [
                      ...behindBody,
                      Container(
                        width: Get.width,
                        height: Get.height,
                        padding: padding ??
                            const EdgeInsets.symmetric(horizontal: 0),
                        child: body ?? Container(),
                      ),
                      ...aboveBody,
                    ],
                  ),
                ),
              ],
            )));
  }
}
