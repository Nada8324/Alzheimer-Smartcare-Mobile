import 'dart:async';
import 'dart:io';

import 'package:alzheimer_smartcare/utils/constants/alerts.dart';
import 'package:alzheimer_smartcare/utils/constants/endpoints.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../global_models/bottom_nav_bat_item.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import '../Schedule/view.dart';
import '../capture/view.dart';
import '../games/view.dart';
import '../home/view.dart';
import '../profile/view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
class PatientLayoutController extends GetxController {
  int index = 0;

  final String? patientEmail = CacheHelper().getDataString(key: ApiKey.email);
  final List<Widget> screens = [
    PatientGameScreen(),
    PatientFaceRecognitionScreen(),
    PatientHomeScreen(),
    PatientScheduleScreen(),
    PatientProfileScreen(),
  ];
  StreamSubscription<Position>? _positionStream;
  bool _backgroundServiceRunning = false;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void onInit() {
    super.onInit();
    _initLocationSharing();
  }

  Future<void> _initLocationSharing() async {
    // 1. Request basic location permission
    if (!await _requestBasicLocationPermission()) {
      showAppSnackBar(
          alertType: AlertType.fail,
          message: 'Location permission denied'.tr
      );
      return;
    }

    // 2. Request background location permission
    if (Platform.isAndroid) {
      if (!await _requestBackgroundLocationPermission()) {
        showAppSnackBar(
            alertType: AlertType.fail,
            message: 'Background location permission denied'.tr
        );
        return;
      }
    }

    // 3. Start the service
    _startBackgroundLocationService();
  }

  Future<bool> _requestBasicLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      showPermissionGuide();
      return false;
    }

    return status.isGranted;
  }

  Future<bool> _requestBackgroundLocationPermission() async {
    // For Android 10+ (API 29+), request background location
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    final sdkVersion = androidInfo.version.sdkInt ?? 0;

    if (sdkVersion >= 29) {
      PermissionStatus status = await Permission.locationAlways.status;

      if (status.isDenied) {
        status = await Permission.locationAlways.request();
      }

      if (status.isPermanentlyDenied) {
        showPermissionGuide();
        return false;
      }

      return status.isGranted;
    }
    return true;
  }

  Future<void> _startBackgroundLocationService() async {
    if (_backgroundServiceRunning) return;
    _backgroundServiceRunning = true;

    LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: "Location Sharing",
          notificationText: "Active in background",
          notificationIcon: AndroidResource(
            name: 'ic_stat_location_on',
            defType: 'drawable',
          ),
          setOngoing: true, // Keep notification active

          enableWakeLock: true, // Keep CPU awake
        ),
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      );
    }

    // Start background location service
    try {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) async {
        await _updateLocationInBackground(position);
      }, onError: (e) {
        _restartLocationService();
      });

    } catch (e) {
      _restartLocationService();
    }
  }

  Future<void> _restartLocationService() async {
    _positionStream?.cancel();
    _backgroundServiceRunning = false;
    await Future.delayed(Duration(seconds: 5));
    _startBackgroundLocationService();
  }

  Future<void> _updateLocationInBackground(Position position) async {
    try {
      if (patientEmail != null && patientEmail!.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(patientEmail)
            .update({
          'location': GeoPoint(position.latitude, position.longitude),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('Location updated: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      print('Location update error: $e');
    }
  }

  void showPermissionGuide() {
    Get.dialog(
      AlertDialog(
        title: AppText('Permission Required'.tr),
        content: Text(
          'For location tracking in background, please grant:\n\n'
              '1. Location Permission (Always)\n'
              '2. Foreground Service Permission\n\n'
              'Open settings to enable these permissions.'.tr,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Open Settings'.tr),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _backgroundServiceRunning = false;
    print('Background location service stopped');
    super.onClose();
  }
  final List<BottomNavBarItem> navItems = [
    BottomNavBarItem(
      svgAsset: AssetsPaths.mind_game,
      svgAssetActive: AssetsPaths.mind_game,
      label: "Game ".tr,
    ),
    BottomNavBarItem(
      svgAsset: AssetsPaths.capture,
      svgAssetActive: AssetsPaths.capture,
      label: "Capture".tr,
    ),
    BottomNavBarItem(
      svgAsset: AssetsPaths.scheduleSVG,
      svgAssetActive: AssetsPaths.scheduleSVG,
      label: 'Schedule'.tr,
    ),
    BottomNavBarItem(
      svgAsset: AssetsPaths.profile,
      svgAssetActive: AssetsPaths.profile,
      label: "Profile".tr,
    ),
  ];

  void changeTab(int newIndex) {
    if (index != newIndex) {
      index = newIndex;
      update();
    }
  }
}
