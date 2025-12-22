import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/dio_consumer.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/alerts.dart';
import '../../../utils/constants/endpoints.dart';
import '../../../utils/custom_helpers/cache_helper.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import '../../auth/login/view.dart';

class DoctorProfileController extends GetxController {
  late String Name;
  late String Email;
  late String Password;

  late TextEditingController Name_controller;
  late TextEditingController Email_controller;
  late TextEditingController Password_controller;

  var isEditingPassword = false;

  DioConsumer dioConsumer = DioConsumer(dio: Dio());

  @override
  void onInit() {
    super.onInit();

    var loginModel = CacheHelper().getUserInfo();
      Name = loginModel?.fullName??"";
      Email = loginModel?.email??"";
      Password = loginModel?.password??"";

    Name_controller = TextEditingController(text: Name);
    Email_controller = TextEditingController(text: Email);
    Password_controller = TextEditingController(text: Password);
    print(Name);
  }

  @override
  void onClose() {
    Name_controller.dispose();
    Email_controller.dispose();
    Password_controller.dispose();
    super.onClose();
  }

  void toggleEditPassword() {
    isEditingPassword = !isEditingPassword;
    if (!isEditingPassword) {
      Password_controller.text = Password;
    } else {
      Password_controller.clear();
    }
    update();
  }

  void savePassword() async {
    final String newPassword = Password_controller.text.trim();
    String? token =CacheHelper().getDataString(key: ApiKey.token);
    if (newPassword.isEmpty) {
      showAppSnackBar(
        alertType: AlertType.fail,
        message: "Please enter a new password.",
        borderRadius: 30.r,
      );
      return;
    }

    try {
      MainAppController.showLoading();

      await dioConsumer.postData(
        Endpoints.ChangePassword,
        data: {
          "token":token,
          "newPassword": newPassword,
        },
        onSuccess: (data) {
          showAppSnackBar(
            alertType: AlertType.success,
            message: data["message"],
            borderRadius: 30.r,
          );
        },
        onError: (error) {
          showAppSnackBar(
            alertType: AlertType.fail,
            message: error.response.toString(),
            borderRadius: 30.r,
          );
          update();
        },
      );
    } catch (error) {
      print("Error updating password: $error");
    } finally {
      EasyLoading.dismiss();
      toggleEditPassword();
    }
  }
}
