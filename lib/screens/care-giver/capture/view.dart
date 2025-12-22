import 'package:alzheimer_smartcare/utils/custom_helpers/iconic_extentions.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global_controllers/face_recognition_controller.dart';
import '../../../global_controllers/mri_controller.dart';
import '../../../global_enums/mri_enums.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/custom_app_screen.dart';
import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text.dart';

class CareGiverFaceRecognitionScreen extends StatelessWidget {
  final CameraController cameraController = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      bgColor: AppColors.white,
      body: Obx(() => Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: MediaQuery.of(context).padding.top.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Added instructional text section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'MRI Scan Classification'.tr,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      15.sbH,
                      AppText(
                        'Upload or capture an MRI scan to classify it for Alzheimer\'s disease detection:'
                            .tr,
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                      10.sbH,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AppText(
                          '• Use camera to capture MRI scan images\n'
                                  '• Or select from gallery\n'
                                  '• System will classify Mild, Moderate or Severe Dementia'
                              .tr,
                          fontSize: 12.sp,
                          color: AppColors.black,
                        ),
                      ),
                      20.sbH,
                    ],
                  ),

                  // Display the captured image if available
                  if (cameraController.capturedImage.value != null)
                    Stack(
                      children: [
                        Container(
                          height: 250.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              cameraController.capturedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: cameraController.clearImage,
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: AppColors.white,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 250.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services,
                              size: 50.r, color: AppColors.grey),
                          10.sbH,
                          AppText(
                            'MRI scan will appear here'.tr,
                            fontSize: 14.sp,
                            color: AppColors.darkGrey,
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 20),

                  // Camera and gallery buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButton(
                        buttonType: ButtonType.icon,
                        svgImageIcon: AssetsPaths.capture,
                        onPressed: cameraController.captureImage,
                        bgColor: AppColors.secondary,
                      ),
                      AppButton(
                        buttonType: ButtonType.icon,
                        iconData: Icons.photo,
                        iconColor: AppColors.white,
                        onPressed: cameraController.pickImageFromGallery,
                        bgColor: AppColors.secondary,
                      )
                    ],
                  ),

                  SizedBox(height: 20),

                  // Predict button
                  if (cameraController.capturedImage.value != null)
                    AppButton(
                      buttonType: ButtonType.text,
                      onPressed: cameraController.isLoading.value
                          ? null
                          : () => cameraController.predictMRI(
                              cameraController.capturedImage.value!),
                      child: cameraController.isLoading.value
                          ? CircularProgressIndicator()
                          : AppText(
                              'Predict MRI'.tr,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                    ),

                  SizedBox(height: 20),

                  // Results section
                  if (cameraController.resultMessage.value.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Prediction Result:'.tr,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8),
                          AppText(MriPredictionStatus.getPredictionName(
                              status: cameraController.resultMessage.value)),
                          5.sbH,
                          AppText(cameraController.resultMessage.value),
                          // Add more details from the MRI model if needed
                        ],
                      ),
                    ),

                  // Error message
                  if (cameraController.errorMessage.value.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppText(
                        cameraController.errorMessage.value,
                        color: AppColors.red,
                      ),
                    ),
                ],
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: cameraController.captureAndPredict,
        child: Icon(Icons.camera),
        tooltip: 'Capture and predict'.tr,
      ),
    );
  }
}
