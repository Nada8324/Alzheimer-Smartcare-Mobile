import 'dart:ui';
import 'package:alzheimer_smartcare/screens/care-giver/layout/controller.dart';
import 'package:alzheimer_smartcare/screens/care-giver/layout/view.dart';
import 'package:alzheimer_smartcare/screens/patient/careGivers/controller.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:alzheimer_smartcare/screens/patient/home/controller.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/bottom_sheet.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/endpoints.dart';
import '../../../utils/custom_helpers/cache_helper.dart';
import '../../../utils/custom_widgets/customLogOutDialog.dart';
import '../../auth/login/view.dart';
import '../../patient/AddReminders/controller.dart';
import '../../patient/layout/controller.dart';
import '../PatientCare/view.dart';
import '../scanPatient/controller.dart';
import 'controller.dart';

class CareGiverHomeScreen extends StatelessWidget {
  const CareGiverHomeScreen({super.key});
  String getFormattedDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, d MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TaskController());
    return GetBuilder<CareGiverHomeController>(
      init: CareGiverHomeController(),
      builder: (controller) {
        return AppScreen(
          padding: EdgeInsets.zero,
          bgColor: AppColors.white,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r)),
                  color: AppColors.secondary,
                ),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top.h),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "${"Hello ".tr}${controller.user.value?.fullName}",
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ),
                            SizedBox(height: 5.h),
                            AppText(
                              getFormattedDate(),
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                            ),
                            SizedBox(height: 19.h),
                          ],
                        ),
                        Spacer(),
                        AppButton(
                          buttonType: ButtonType.inkwell,
                          child: Container(
                            height: 42.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightBink,
                            ),
                            alignment: Alignment.center,
                            child: AppImage(
                              svgAsset: AssetsPaths.logout,
                              height: 24.h,
                              width: 24.h,
                            ),
                          ),
                          onPressed: () {
                            showConfirmationDialog(
                              isPatient: false,
                              title: "are you sure you want to log out?".tr,
                              confirmButtonText: "logout",
                              onConfirm: () {
                                Get.offAll(() => LoginScreen());
                                CacheHelper().removeData(key: ApiKey.email);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 75.h),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25.h),
                        AppText(
                          "Game".tr,
                          height: 29.05 / 24.sp,
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: AppColors.homeGreyText,
                        ),
                        SizedBox(height: 10.h),
                        AppButton(
                          buttonType: ButtonType.inkwell,
                          onPressed: () {
                            Get.find<CareGiverLayoutController>().changeTab(0);
                          },
                          child: Container(
                            height: 147.h,
                            width: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: ImageFiltered(
                                    imageFilter:
                                    ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                    child: AppImage(
                                      assetImage: AssetsPaths.gamesPNG,
                                      height: 147.h,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 147.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.photoShadow
                                          .withValues(alpha: 0.36),
                                      borderRadius: BorderRadius.circular(10.r)),
                                ),
                                AppText(
                                  "${"High score".tr} : ${controller.patientGameController.highScore == 99999 ? "0" : "${controller.patientGameController.highScore}"}",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp,
                                  color: AppColors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        AppButton(
                          buttonType: ButtonType.inkwell,
                          child: AppText(
                            "Location Tracking".tr,
                            height: 29.05 / 24.sp,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            color: AppColors.homeGreyText,
                          ),
                          onPressed: () {
                            Get.to(() => PatientLocationTrackingScreen());
                          },
                        ),
                        SizedBox(height: 10.h),
                        AppButton(
                          buttonType: ButtonType.inkwell,
                          onPressed: () {
                            Get.to(() => PatientLocationTrackingScreen());
                          },
                          child: Container(
                            height: 171.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _MapPreview(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class _MapPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CareGiverScanPatientController());

    return StreamBuilder<QuerySnapshot>(
      stream: controller.pairedPatients,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) {
          return Center(
            child: AppText(
              'Error: ${snap.error}',
              color: Colors.red,
            ),
          );
        }

        final patientIds = snap.data?.docs
            .map((d) => d['patientId'] as String)
            .toList() ?? [];

        if (patientIds.isEmpty) {
          return Center(
            child: AppText(
              'No patients paired'.tr,
              color: Colors.grey,
            ),
          );
        }

        print('Patient IDs: $patientIds');

        return StreamBuilder<QuerySnapshot>(
          stream: controller.firestore
              .collection('patients')
              .where(FieldPath.documentId, whereIn: patientIds)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              MainAppController.showLoading();
              return Center(child: CircularProgressIndicator());
            }

            EasyLoading.dismiss();

            if (snapshot.hasError) {
              return Center(
                child: AppText(
                  'Error: ${snapshot.error}',
                  color: Colors.red,
                ),
              );
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(
                child: AppText(
                  'No patient data'.tr,
                  color: Colors.grey,
                ),
              );
            }

            // Get first patient's location
            final firstPatient = snapshot.data!.docs.first;
            final location = firstPatient['location'] as GeoPoint?;
            final latLng = location != null
                ? latlong.LatLng(location.latitude, location.longitude)
                : const latlong.LatLng(30.136537, 31.333302); // Default location

            return IgnorePointer(
              child: FlutterMap(
                options: MapOptions(
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                  initialCenter: latLng,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.alzheimersmartcare',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: latLng,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

