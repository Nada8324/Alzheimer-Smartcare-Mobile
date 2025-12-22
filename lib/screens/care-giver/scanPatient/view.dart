import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/custom_app_screen.dart';
import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import 'controller.dart';

class CareGiverScanPatientScreen extends StatelessWidget {
  const CareGiverScanPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CareGiverScanPatientController());

    return AppScreen(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top.h),
      bgColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildScanner(controller),
                _buildScanOverlay(controller),
              ],
            ),
          ),

          Expanded(
            child: _buildPatientList(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner(CareGiverScanPatientController controller) {
    return AspectRatio(
      aspectRatio: 1,
      child: MobileScanner(
        controller: controller.scannerController,
        onDetect: (capture) {
          final barcode = capture.barcodes.firstOrNull;
          if (barcode?.rawValue != null && !controller.isLoading.value) {
            controller.scannerController?.stop();
            controller.sendPairingRequest(barcode!.rawValue!);
          }
        },
      ),
    );
  }

  Widget _buildScanOverlay(CareGiverScanPatientController controller) {
    return Obx(() => Stack(
      children: [
        if (controller.isLoading.value)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        Positioned(
          bottom: 0.h,
          left: 0,
          right: 0,
          child: _buildGalleryButton(controller),
        ),
      ],
    ));
  }

  Widget _buildGalleryButton(CareGiverScanPatientController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppButton(
        buttonType: ButtonType.elevated,
        bgColor: AppColors.secondary,
        borderRadius: BorderRadius.circular(15.r),
        onPressed: controller.scanFromGallery,
        child: Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              "Select Image".tr,
              fontSize: 17.sp,
              color: AppColors.white,
            ),
            SizedBox(width: 8.w),
            const Icon(Icons.photo_library, color: Colors.white),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPatientList(CareGiverScanPatientController controller) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Your Patients'.tr,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.pairedPatients,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  MainAppController.showLoading();
                  return Center(child: CircularProgressIndicator());
                }

                EasyLoading.dismiss();

                if (snapshot.hasError) {
                  return Center(
                    child: AppText(
                      'Error: ${snapshot.error}',color: Colors.red,

                    ),
                  );
                }


                final patients = snapshot.data?.docs ?? [];

                if (patients.isEmpty) {
                  return Center(
                    child: AppText(
                      "No patients found".tr,
                      color: AppColors.grey,
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: patients.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, index) {
                    final data = patients[index].data() as Map<String, dynamic>;
                    return _buildPatientItem(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientItem(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: ListTile(
        leading: const Icon(Icons.person_outline, size: 32),
        title: AppText(
          data['patientId'] ?? 'Unknown Patient',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        subtitle: AppText(
          'Status: ${data['status']}'.tr,
          fontSize: 14.sp,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }
}