import 'package:alzheimer_smartcare/screens/care-giver/home/controller.dart';
import 'package:alzheimer_smartcare/screens/care-giver/scanPatient/view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../global_models/bottom_nav_bat_item.dart';
import '../../../utils/constants/assets.dart';
import '../capture/view.dart';
import '../games/view.dart';
import '../home/view.dart';
import '../profile/view.dart';


class CareGiverLayoutController extends GetxController {

  int index = 0;


  final List<Widget> screens = [
    CareGiverGameScreen(),
    CareGiverFaceRecognitionScreen(),
    CareGiverHomeScreen(),
    CareGiverScanPatientScreen(),
    CareGiverProfileScreen()
  ];


  final List<BottomNavBarItem> navItems = [
    BottomNavBarItem(
      svgAsset: AssetsPaths.mind_game,
      svgAssetActive: AssetsPaths.mind_game ,
      label: "Game ".tr,
    ),
    BottomNavBarItem(
      svgAsset: AssetsPaths.capture,
      svgAssetActive: AssetsPaths.capture ,
      label: "Capture".tr,
    ),
    BottomNavBarItem(
      svgAsset: AssetsPaths.Scan,
      svgAssetActive: AssetsPaths.Scan ,
      label: 'Location Tracking'.tr,
    ),
    BottomNavBarItem(
      svgAsset: AssetsPaths.profile,
      svgAssetActive: AssetsPaths.profile ,
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
