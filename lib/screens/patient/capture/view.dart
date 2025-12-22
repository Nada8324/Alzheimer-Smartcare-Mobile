import 'package:alzheimer_smartcare/utils/custom_helpers/iconic_extentions.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_controllers/face_recognition_controller.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/custom_app_screen.dart';
import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text.dart';

class PatientFaceRecognitionScreen extends StatelessWidget {
  final FaceRecognitionController controller = Get.put(FaceRecognitionController());

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      bgColor: AppColors.white,
      body: Obx(() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      buttonType: ButtonType.text,
                      onPressed: () => _showRegisterDialog(context),
                      child: AppText('Register Face'.tr, color: AppColors.white, fontWeight: FontWeight.w700),
                      bgColor: AppColors.primary,
                    ),
                  ),
                  10.sbW,
                  Expanded(
                    child: AppButton(
                      buttonType: ButtonType.text,
                      onPressed: () => controller.recognizeCurrentFace(),
                      child: AppText('Recognize Face'.tr, color: AppColors.white, fontWeight: FontWeight.w700),
                      bgColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
          
              20.sbH,

              if (controller.capturedImage.value != null)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      controller.capturedImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: AppText('No image capture yet'.tr),
                  ),
                ),
          
              20.sbH,
          
              // Camera and gallery buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    buttonType: ButtonType.icon,
                    svgImageIcon: AssetsPaths.capture,
                    onPressed: controller.captureImage,
                    bgColor: AppColors.secondary,
                  ),
                  20.sbW,
                  AppButton(
                    buttonType: ButtonType.icon,
                    iconData: Icons.photo,
                    iconColor: AppColors.white,
                    onPressed: controller.pickImageFromGallery,
                    bgColor: AppColors.secondary,
                  ),
                ],
              ),
          
              20.sbH,
          
              // Results section
              if (controller.recognizedName.value.isNotEmpty)
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
                        'Recognition Result:'.tr,
                        fontWeight: FontWeight.bold,
                      ),
                      8.sbH,
                      AppText(
                        '${"Recognized as:".tr} ${controller.recognizedName.value}',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
          
              if (controller.resultMessage.value.isNotEmpty && controller.recognizedName.value.isEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(controller.resultMessage.value),
                ),
          
              // Error message
              if (controller.errorMessage.value.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    controller.errorMessage.value,
                    color: AppColors.red,
                  ),
                ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.resetImage(),
        child: Icon(Icons.refresh),
        tooltip: 'Reset'.tr,
      ),
    );
  }

  // Dialog to enter person name for registration
  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText('Register New Face'.tr,fontWeight: FontWeight.w500,fontSize: 16,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFormField(
              controller: controller.nameController,
              hintText: 'Enter person name'.tr,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText('cancel'.tr,color: AppColors.white,fontWeight: FontWeight.w500,fontSize: 16),

          ),
          TextButton(
            onPressed: () {
              if (controller.nameController.text.isNotEmpty) {
                Navigator.pop(context);
                controller.registerCurrentFace(controller.nameController.text);
              }
            },
            child: AppText('Register'.tr,color: AppColors.white,fontWeight: FontWeight.w500,fontSize: 16),
          ),
        ],
      ),
    );
  }
}