import 'package:get/get.dart';
import 'auth_controller.dart';
import 'main_app_controller.dart';

class MyBindings implements Bindings {
  @override
  void dependencies() {
    // Get.put<CustomHttpClient>(CustomHttpClient(), permanent: true);
    Get.put<MainAppController>(MainAppController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
