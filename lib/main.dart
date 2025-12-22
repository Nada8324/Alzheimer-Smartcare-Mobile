import 'package:alzheimer_smartcare/utils/custom_helpers/cache_helper.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/db_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'global_controllers/notifications_controller.dart';
import 'main_app.dart';

List<CameraDescription> cameras = [];

main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  await CacheHelper.init();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationServices().initializeNotification();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

  runApp( const MainApp());
}