import 'package:alzheimer_smartcare/screens/auth/login/view.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'model.dart';

class OnboardingController extends GetxController {

  var boardController = PageController();
  bool isLast = false;

  List<BoardingModel> BoardingList = [
    BoardingModel(image:AssetsPaths.onboardingIllustration1SVG,primaryText: "Patient".tr,secondaryText: "Medicine_Reminder".tr),
    BoardingModel(image:AssetsPaths.onboardingIllustration2SVG,primaryText: "Caregiver".tr,secondaryText: "Location_Tracking".tr),
    BoardingModel(image:AssetsPaths.onboardingIllustration3SVG,primaryText: "Doctor".tr,secondaryText: "MRI_Classification".tr),
  ];


  Function()? submit(){
    /*CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value!){}
    });*/
    Get.offAll(LoginScreen());
    return null;
  }


  Widget BuiltOnBoardItem(BoardingModel model) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 150,horizontal: 10),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage(svgAsset: model.image,height: 400,width: 400,),
          SizedBox(
            height: 120,
          ),
          AppText(
            model.primaryText,
            textAlign: TextAlign.center,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          SizedBox(
            height: 5,
          ),
          AppText(
            model.secondaryText,
            textAlign: TextAlign.center,
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ],
      ),
    ),
  );




}