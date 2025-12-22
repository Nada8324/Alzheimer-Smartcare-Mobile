import 'package:get/get.dart';

class MriPredictionStatus{

  static const  String NonDemented = '0';
  static const  String MildDementia = '1';
  static const  String ModerateDementia = '2';
  static const  String VeryMildDementia = '3';



  static String getPredictionName({required String ? status}) {
    if (status == NonDemented) {
      return "non_demented".tr;
    }
    if (status == MildDementia) {
      return "mild_demented".tr;
    }
    if (status == ModerateDementia) {
      return "moderate_demented".tr;
    }
    if (status == VeryMildDementia) {
      return "very_mild_demented".tr;
    }
    return "cannot_determine".tr;
  }



}