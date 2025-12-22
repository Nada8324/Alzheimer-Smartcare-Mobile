import 'package:alzheimer_smartcare/screens/auth/login/view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/alerts.dart';
import '../../../utils/constants/endpoints.dart';
import '../../../utils/custom_helpers/dio_consumer.dart';
import 'model.dart';

class RegisterController extends GetxController  {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var reEnterPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  final phoneController = TextEditingController();
  var loginFormkey  = GlobalKey<FormState>();
  DioConsumer dioConsumer = DioConsumer(dio: Dio(),baseUrl: Endpoints.baseUrl);
  RegisterModel? registerModel;
  String ? errorMessage ;
  String selectedCountryCode = '+20';
  String selectedUserType = 'user type'.tr;


  final List<UserTypeModel> userTypes = [
    UserTypeModel('doctor'.tr),
    UserTypeModel('Patient'.tr),
    UserTypeModel('Caregiver'.tr),
  ];


  void changeUserType(String newType)
  {
    selectedUserType = newType;
    update();
  }

  void changeCountryCode(String code)
  {
    debugPrint(code);
    selectedCountryCode = code;
    update();
  }


  register() async {
    try {
      MainAppController.showLoading();
      final response = await dioConsumer.postData(
        Endpoints.Register,
        data: {
          "fullname": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "phoneNumber": "${selectedCountryCode}${phoneController.text}",
          "userType": selectedUserType,
        },
        onSuccess: (data) {
          if(data["success"] != false)
          {
            showAppSnackBar(
                alertType: AlertType.success,
                message: "User Registered Successfully".tr,
                borderRadius: 30.r
            );
            Get.offAll(LoginScreen());
          }
          else
          {
            showAppSnackBar(
                alertType: AlertType.fail,
                message: data["message"],
                borderRadius: 30.r
            );
          }
          //print(data);
        },
        onError: (error) {
          errorMessage = error.response!.data["message"];
          showAppSnackBar(
              alertType: AlertType.fail,
              message: errorMessage,
              borderRadius: 30.r
          );
          update();
        },
      );
      EasyLoading.dismiss();
      registerModel = RegisterModel.fromJson(response as Map<String, dynamic>);
    } catch (error) {
      EasyLoading.dismiss();
      print("Error: $error");
    }
  }
  
}
