import 'package:alzheimer_smartcare/screens/care-giver/scanPatient/view.dart';
import 'package:alzheimer_smartcare/screens/doctor/profile/view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../global_models/bottom_nav_bat_item.dart';
import '../../../utils/constants/assets.dart';
import '../capture/view.dart';

class DoctorLayoutController extends GetxController {
  int index = 0;

  final List<Widget> screens = [
    DoctorScanPatientScreen(),
    DoctorProfileScreen(),
  ];


  void changeTab(int newIndex) {
    if (index != newIndex) {
      index = newIndex;
      update();
    }
  }
}