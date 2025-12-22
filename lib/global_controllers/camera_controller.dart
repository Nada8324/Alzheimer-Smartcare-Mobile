import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// Enhanced controller for camera/gallery image capture with cropping functionality
class EnhancedCameraController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<File?> capturedImage = Rx<File?>(null);
  Rx<File?> croppedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxString resultMessage = ''.obs;
  RxString errorMessage = ''.obs;

  // Optional parameters for cropping
  final RxBool cropEnabled = true.obs;
  final RxDouble aspectRatioX = 1.0.obs; // Square by default
  final RxDouble aspectRatioY = 1.0.obs;

  /// Open camera and capture image, then crop if enabled
  Future<File?> captureImage({bool withCropping = true}) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        capturedImage.value = File(photo.path);
        update();

        // Crop the image if enabled
        if (withCropping && cropEnabled.value) {
          await cropImage();
          return croppedImage.value;
        }
        return capturedImage.value;
      }
      return null;
    } catch (e) {
      errorMessage.value = 'Failed to capture image: $e';
      update();
      return null;
    }
  }

  /// Open gallery to select image, then crop if enabled
  Future<File?> pickImageFromGallery({bool withCropping = true}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        capturedImage.value = File(image.path);
        update();

        // Crop the image if enabled
        if (withCropping && cropEnabled.value) {
          await cropImage();
          return croppedImage.value;
        }
        return capturedImage.value;
      }
      return null;
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
      update();
      return null;
    }
  }

  /// Crop the currently captured image
  Future<File?> cropImage() async {
    if (capturedImage.value == null) {
      errorMessage.value = 'No image available to crop';
      update();
      return null;
    }

    try {
      EasyLoading.show(status: 'Processing...');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: capturedImage.value!.path,
        aspectRatio: CropAspectRatio(
          ratioX: aspectRatioX.value,
          ratioY: aspectRatioY.value,
        ),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      if (croppedFile != null) {
        croppedImage.value = File(croppedFile.path);
        update();
        EasyLoading.dismiss();
        return croppedImage.value;
      }

      EasyLoading.dismiss();
      return null;
    } catch (e) {
      EasyLoading.dismiss();
      errorMessage.value = 'Failed to crop image: $e';
      update();
      return null;
    }
  }

  /// Reset all images and messages
  void resetImages() {
    capturedImage.value = null;
    croppedImage.value = null;
    resultMessage.value = '';
    errorMessage.value = '';
    update();
  }

  /// Set aspect ratio for cropping
  void setAspectRatio(double x, double y) {
    aspectRatioX.value = x;
    aspectRatioY.value = y;
    update();
  }

  /// Check if we have a valid image to use (cropped has priority)
  File? getProcessableImage() {
    return croppedImage.value ?? capturedImage.value;
  }

  /// Capture, crop, and process in one step
  Future<File?> captureProcessImage() async {
    await captureImage(withCropping: true);
    return getProcessableImage();
  }
}