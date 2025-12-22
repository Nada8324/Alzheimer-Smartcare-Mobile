import 'dart:async';
import 'dart:io';
import 'package:alzheimer_smartcare/global_controllers/secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../global_enums/cached_keys.dart';
import '../utils/constants/styles_and_themes.dart';
import '../utils/custom_helpers/cache_helper.dart';
import '../utils/custom_widgets/loading_indicator.dart';
import '../utils/translation/translation.dart';
import 'auth_controller.dart';

class MainAppController extends GetxController {

  static showLoading() {
    EasyLoading easyLoading = EasyLoading.instance;
    easyLoading.maskColor = Colors.transparent;
    easyLoading.backgroundColor = Colors.red;
    easyLoading.radius = 15;
    easyLoading.contentPadding = EdgeInsets.zero;
    easyLoading.indicatorWidget = const AppLoadingIndicator();
    EasyLoading.show(
      indicator: easyLoading.indicatorWidget,
      maskType: EasyLoadingMaskType.custom,
    );
  }

  String? deviceToken;
  Map<String, dynamic>? deviceInfo;
  final String deviceType = Platform.operatingSystem;
  Lang lang = Lang.ar;
  ThemeType? theme = ThemeType.light;
  bool firstOpen = true;
  String? deviceId;
  static String getLangString() {
    MainAppController mainAppController;
    try {
      mainAppController = Get.find();
    } catch (e) {
      mainAppController = Get.put(MainAppController());
    }
    return mainAppController.lang == Lang.en ? "en" : "ar";
  }

  @override
  onInit() {
    initApp();
    super.onInit();
  }
  DeviceScreenType? deviceScreenType;
  initApp() async {
    await GetStorage.init();
    await getDeviceInfo();
    await checkAndUpdateAppLang();
    await checkAndUpdateAppTheme();
    MainAppController.getDeviceTypeAndOrientation();
    AuthController authCTL = Get.find();
  }

  static Future<DeviceScreenType> getDeviceTypeAndOrientation() async {
    try {
      await Future.delayed(const Duration(milliseconds: 10));
      var deviceType = getDeviceType(Get.context!.size!,
          const ScreenBreakpoints(desktop: 800, tablet: 450, watch: 200));
      if (deviceType == DeviceScreenType.mobile) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      }
      MainAppController mainAppController = Get.find();
      mainAppController.deviceScreenType = deviceType;
      mainAppController.update();
      return deviceType;
    } catch (e) {
      EasyLoading.showToast(e.toString());
      MainAppController mainAppController = Get.find();
      mainAppController.deviceScreenType = DeviceScreenType.mobile;
      mainAppController.update();
      return DeviceScreenType.mobile;
    }
  }

  checkAndUpdateAppLang() async {
    try {
      String? l = await SecureStorage.read(CachedKeys.lang);
      if (l != null) {
        await (l == "en" ? changeAppLang(Lang.en) : changeAppLang(Lang.ar));
      } else {
        changeAppLang(Lang.ar);
      }
    } catch (_) {}
  }



  changeAppLang(Lang l) async {
    lang = l;
    await GetStorage().write("lang", l == Lang.ar ? "ar" : "en");
    Get.updateLocale(
        l == Lang.ar ? const Locale("ar", "SA") : const Locale("en", "US"));
    update();
  }

  checkAndUpdateAppTheme() async {
    String? t = GetStorage().read("theme");
    if (t != null) {
      theme = await (t == "dark"
          ? changeAppTheme(ThemeType.dark)
          : changeAppTheme(ThemeType.light));
    }
  }

  changeAppTheme(ThemeType? t) async {
    theme = t;
    await GetStorage().write("theme", t == ThemeType.light ? "light" : "dark");
    Get.changeTheme(
        t == ThemeType.light ? ThemeData.light() : ThemeData.dark());
    update();
  }

  getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo? androidInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo = {
        "deviceID": deviceId,
        "deviceName": androidInfo.device,
        "brand": androidInfo.brand,
        "modelName": androidInfo.model,
        "osName": Platform.operatingSystem,
        "osVersion": Platform.operatingSystemVersion,
        "osBuildId": androidInfo.version.release,
        "uniqueDeviceIdentifier": androidInfo.fingerprint,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo? iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo = {
        "deviceID": deviceId,
        "deviceName": iosDeviceInfo.name,
        "brand": iosDeviceInfo.utsname.nodename,
        "modelName": iosDeviceInfo.utsname.version,
        "osName": Platform.operatingSystem,
        "osVersion": Platform.operatingSystemVersion,
        "osBuildId": iosDeviceInfo.utsname.release,
        "uniqueDeviceIdentifier": "${iosDeviceInfo.identifierForVendor}"
      };
      update();
    }
  }

}
