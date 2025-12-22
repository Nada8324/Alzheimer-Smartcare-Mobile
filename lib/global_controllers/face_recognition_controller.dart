import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../utils/constants/alerts.dart';
import '../utils/constants/endpoints.dart';
import '../utils/custom_helpers/cache_helper.dart';
import '../utils/custom_helpers/dio_consumer.dart';
import 'main_app_controller.dart';

class FaceRecognitionController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<File?> capturedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxString resultMessage = ''.obs;
  RxString recognizedName = ''.obs;
  RxString errorMessage = ''.obs;
  late String Email;
  late String token;
  DioConsumer dioConsumer = DioConsumer(dio: dio.Dio(), baseUrl: Endpoints.modelsUrl);
  DioConsumer saveFaceDioConsumer = DioConsumer(dio: dio.Dio());

@override
  void onInit() {
  // User email - could be set from login state
  var loginModel = CacheHelper().getUserInfo();
  Email = loginModel?.email??"";
  token = loginModel?.token??"";
    super.onInit();
  }
  // Controller for name input when registering a new face
  final TextEditingController nameController = TextEditingController();
  void _resetResults() {
    resultMessage.value = '';
    recognizedName.value = '';
    errorMessage.value = '';
  }

  // Open camera and capture image
  Future<void> captureImage() async {
    _resetResults();
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
    _resetResults();
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

  // Reset captured image and results
  void resetImage() {
    capturedImage.value = null;
    _resetResults();
  }

  // Register a new face
  Future<void> registerFace(File imageFile, String personName) async {
    try {
      isLoading.value = true;
      update();
      MainAppController.showLoading();

      String fileName = path.basename(imageFile.path);
      String mimeType = 'image/jpeg';
      if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      }

      // Create form data for face registration
      dio.FormData formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
        "name": personName,
        "account_id": Email,
      });

      // Send to registration endpoint
      await dioConsumer.postData(
        ApiKey.faceRegister,
        data: formData,
        onSuccess: (data) {
          if (data["success"] != false) {
            // Moved saveFace inside success block
            saveFace(imageFile, personName);

            resultMessage.value = "Face successfully registered for $personName";
            showAppSnackBar(
                alertType: AlertType.success,
                message: resultMessage.value,
                borderRadius: 30,
                durationSeconds: 5
            );
          } else {
            errorMessage.value = data["message"] ?? "Registration failed";
            showAppSnackBar(
                alertType: AlertType.fail,
                message: errorMessage.value,
                borderRadius: 30,
                durationSeconds: 5
            );
          }
          update();
        },
        onError: (error) {
          errorMessage.value = error.response?.toString() ?? "Unknown error during registration";
          update();
        },
      );
    } catch (error) {
      EasyLoading.dismiss();
      errorMessage.value = error.toString();
      print("Error in face registration: $error");
      update();
    } finally {
      isLoading.value = false;
      update();
      EasyLoading.dismiss();
    }
  }


  Future<void> saveFace(File imageFile, String personName) async {
    try {
      isLoading.value = true;
      update();

      MainAppController.showLoading();

      String fileName = path.basename(imageFile.path);
      String mimeType = 'image/jpeg';
      if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      }

      // Create form data for face registration
      dio.FormData formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
        "name": personName,
        "userEmail": Email,
      });

      // Send to registration endpoint
      final response = await saveFaceDioConsumer.postData(
        Endpoints.SaveFace, // You'll need to define this in your ApiKey class
        data: formData,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        onSuccess: (data) {
          if (data["success"] != false) {
            resultMessage.value = "Face successfully Saved for $personName";
            showAppSnackBar(
                alertType: AlertType.success,
                message: resultMessage.value,
                borderRadius: 30,
                durationSeconds: 5
            );
          } else {
            errorMessage.value = data["message"] ?? "Registration failed";
            showAppSnackBar(
                alertType: AlertType.fail,
                message: errorMessage.value,
                borderRadius: 30,
                durationSeconds: 5
            );
          }
          update();
        },
        onError: (error) {
          errorMessage.value = error.response?.toString() ?? "Unknown error during registration";
          update();
        },
      );

      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      errorMessage.value = error.toString();
      print("Error in face registration: $error");
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

// Recognize a face
  Future<void> recognizeFace(File imageFile) async {
    try {
      isLoading.value = true;
      update();

      MainAppController.showLoading();

      String fileName = path.basename(imageFile.path);
      String mimeType = 'image/jpeg';
      if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      }

      // Create form data for face recognition
      dio.FormData formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
        "account_id": Email,
      });

      // Send to recognition endpoint
      final response = await dioConsumer.postData(
        ApiKey.faceRecognize,
        data: formData,
        onSuccess: (data) {
          // Modified to handle the actual response structure
          if (data["success"] != null && data["success"] is List && data["success"].isNotEmpty) {
            // Extract the name from the success array
            recognizedName.value = data["success"][0];
            resultMessage.value = "Recognized: ${recognizedName.value}";
            showAppSnackBar(
                alertType: AlertType.success,
                message: resultMessage.value,
                borderRadius: 30,
                durationSeconds: 5
            );
          } else {
            errorMessage.value = "Recognition failed or person not found";
            showAppSnackBar(
                alertType: AlertType.fail,
                message: errorMessage.value,
                borderRadius: 30,
                durationSeconds: 5
            );
          }
          update();
        },
        onError: (error) {
          errorMessage.value = error.response?.toString() ?? "Unknown error during recognition";
          update();
        },
      );

      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      errorMessage.value = error.toString();
      print("Error in face recognition: $error");
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Convenience methods to capture and perform actions
  Future<void> registerCurrentFace(String personName) async {
    if (capturedImage.value != null) {
      await registerFace(capturedImage.value!, personName);
    } else {
      errorMessage.value = "No image to register";
      update();
    }
  }

  Future<void> recognizeCurrentFace() async {
    if (capturedImage.value != null) {
      await recognizeFace(capturedImage.value!);
    } else {
      errorMessage.value = "No image to recognize";
      update();
    }
  }
  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}