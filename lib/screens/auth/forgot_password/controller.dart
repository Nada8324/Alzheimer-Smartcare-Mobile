import 'package:alzheimer_smartcare/utils/constants/alerts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/view.dart';

class ForgotPasswordController extends GetxController {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reEnterPasswordController = TextEditingController();


  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();


  final String demoOtp = "5555";


  void sendOtp() {
    if (emailFormKey.currentState!.validate()) {
      showAppSnackBar(
          alertType: AlertType.success,
          message: "An OTP has been sent to your email".tr,
          borderRadius: 30
      );
      update();
    }
  }


  bool verifyOtp() {
    if (otpFormKey.currentState!.validate()) {
      if (otpController.text.trim() == demoOtp) {
        return true;
      } else {
        showAppSnackBar(
            alertType: AlertType.fail,
            message: "Incorrect OTP".tr,
            borderRadius: 30,
        );
        return false;
      }
    }
    return false;
  }


  void resetPassword() {
    if (resetFormKey.currentState!.validate()) {
      showAppSnackBar(
          alertType: AlertType.success,
          message: "Password reset successfully".tr,
          borderRadius: 30
      );
      Get.offAll(() => LoginScreen());
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    reEnterPasswordController.dispose();
    super.onClose();
  }
}