
import 'package:alzheimer_smartcare/global_models/login_model.dart';
import 'package:alzheimer_smartcare/screens/patient/games/controller.dart';

import 'package:get/get.dart';

import '../../../utils/custom_helpers/cache_helper.dart';

class CareGiverHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  var user = Rxn<LogInModel>();
  late RxString timeLeft;
  final PatientGameController patientGameController =Get.put(PatientGameController());
  void loadUserData() {
    var userData = CacheHelper().getUserInfo();
    if (userData != null) {
      user.value = userData;
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    loadUserData();
    super.onInit();
  }

}
