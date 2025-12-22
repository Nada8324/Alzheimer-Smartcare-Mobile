import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// Import dio with an alias to avoid naming conflicts
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../global_models/MRI_Model.dart';
import '../utils/constants/alerts.dart';
import '../utils/constants/endpoints.dart';
import '../utils/custom_helpers/dio_consumer.dart';
import 'main_app_controller.dart';

class CameraController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<File?> capturedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxString resultMessage = ''.obs;
  RxString errorMessage = ''.obs;
  DioConsumer dioConsumer = DioConsumer(dio: dio.Dio(), baseUrl: Endpoints.modelsUrl);

  // Open camera and capture image
  Future<void> captureImage() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        capturedImage.value = File(photo.path);
        update();
      }
    } catch (e) {
      errorMessage.value = 'Failed to capture image: $e';
      update();
    }
  }

  // Open gallery to select image
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        capturedImage.value = File(image.path);
        update();
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
      update();
    }
  }

  // Reset captured image
  void resetImage() {
    capturedImage.value = null;
    resultMessage.value = '';
    errorMessage.value = '';
    update();
  }

  // Send image to API for prediction - FIXED VERSION
  Future<void> predictMRI(File imageFile) async {
    try {
      isLoading.value = true;
      update();

      MainAppController.showLoading();

      // Create a FormData object with the image file - using Dio's FormData
      String fileName = path.basename(imageFile.path);
      String mimeType = 'image/jpeg';
      if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      }

      // Use Dio's FormData with the alias
      dio.FormData formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      // Use dio directly to handle the multipart request
      final response = await dioConsumer.postData(
        ApiKey.mriPredict,
        data: formData,
        onSuccess: (data) {
          if (data["predicted_class"] != null) {
            resultMessage.value = data["predicted_class"].toString();
          } else {
            resultMessage.value = "Prediction successful";
          }

          showAppSnackBar(
              alertType: AlertType.success,
              message: resultMessage.value,
              borderRadius: 30, // Make sure this is the correct type for your function
              durationSeconds: 8
          );
          update();
        },
        onError: (error) {
          // Ensure error is converted to string properly
          if (error.response != null) {
            errorMessage.value = error.response.toString();
          } else {
            errorMessage.value = "Unknown error occurred";
          }
          update();
        },
      );

      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      // Make sure we handle all possible error types
      try {
        // Safely convert any error to string
        errorMessage.value = error.toString();
      } catch (e) {
        // If even toString() fails, provide a fallback
        errorMessage.value = "An unexpected error occurred";
      }
      print("Error: $error");
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Capture and predict in one step
  Future<void> captureAndPredict() async {
    await captureImage();
    if (capturedImage.value != null) {
      await predictMRI(capturedImage.value!);
    }
  }
  void clearImage() {
    capturedImage.value = null;
    resultMessage.value = '';
    errorMessage.value = '';
  }
}