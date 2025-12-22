import 'package:alzheimer_smartcare/global_controllers/main_app_controller.dart';
import 'package:alzheimer_smartcare/screens/patient/layout/view.dart';
import 'package:alzheimer_smartcare/utils/constants/alerts.dart';
import 'package:alzheimer_smartcare/utils/constants/endpoints.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../global_models/login_model.dart';
import '../screens/care-giver/layout/view.dart';
import '../screens/doctor/layout/view.dart';
import '../screens/patient/AddReminders/controller.dart';
import '../utils/constants/secrets.dart';
import '../utils/custom_helpers/cache_helper.dart';
import '../utils/custom_helpers/dio_consumer.dart';

class AuthController extends GetxController {
  static AuthController instance() {
    AuthController authController;
    try {
      authController = Get.find();
    } catch (_) {
      authController = Get.put(AuthController());
    }
    return authController;
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  DioConsumer dioConsumer = DioConsumer(dio: Dio(), baseUrl: Endpoints.baseUrl);
  String ? errorMessage;

  LogInModel? loginModel;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }


  login() async {
    try {
      MainAppController.showLoading();

      final response = await dioConsumer.postData(
        Endpoints.Login,
        data: {
          "email": emailController.text,
          "password": passwordController.text,
        },
        onSuccess: (data) async {
          if (data["success"] != false) {
            if (data["userType"] == "Doctor") {
              Get.offAll(() => DoctorLayoutScreen());
            }
            else if (data["userType"] == "Patient") {
              try {
                await createPatientProfile(data["email"],data['fullname']);
                print("Successfully handled patient profile");
                Get.delete<TaskController>(force: true);
                Get.put(TaskController());
                Get.offAll(() => PatientLayoutScreen());
              } catch (e) {
                showAppSnackBar(
                    alertType: AlertType.fail,
                    message: "Failed to initialize patient profile: ${e.toString()}",
                    borderRadius: 30.r
                );
                return;
              }
            }
            else {
              Get.offAll(() => CareGiverLayoutScreen());
            }
          } else {
            showAppSnackBar(
                alertType: AlertType.fail,
                message: data["message"],
                borderRadius: 30.r
            );
          }

          // Debug: Print token details
          loginModel = LogInModel.fromJson(data);
          print(data);
          print("🟢 Token received from API: ${loginModel!
              .token}"); // From API response

          CacheHelper().saveData(key: ApiKey.token, value: loginModel!.token);
          CacheHelper().saveData(key: ApiKey.email, value: loginModel!.email);
          CacheHelper().saveUserInfo(loginModel);

          // Verify saved token
          String? savedToken = CacheHelper().getDataString(key: ApiKey.token);
          print(
              "🟢 Token saved in CacheHelper: $savedToken"); // From local storage
        },
        onError: (error) {
          errorMessage = error.response.toString();
          update();
        },
      );

      EasyLoading.dismiss();
      print("======================");
      CacheHelper().saveData(key: ApiKey.token, value: loginModel!.token);
      CacheHelper().saveData(key: ApiKey.email, value: loginModel!.email);
      print("======================");
      CacheHelper().saveUserInfo(loginModel);
      print("======================");
      print(loginModel!.userType);
      print("=======================");
    } catch (error) {
      EasyLoading.dismiss();
      print("Error: $error");
    }
  }

  Future<void> createPatientProfile(String email,String name) async {
    try {
      final patientRef = FirebaseFirestore.instance.collection('patients').doc(email);
      final doc = await patientRef.get();

      if (!doc.exists) {
        await patientRef.set({
          'apiToken': AppSecrets.firestoreToken,
          'caregivers': [],
          'lastUpdated': FieldValue.serverTimestamp(),
          'location': GeoPoint(0, 0),
          'name':name
        });

      }
    } catch (e) {
      print("❌ Error in createPatientProfile: $e");
      throw e;
    }
  }
}