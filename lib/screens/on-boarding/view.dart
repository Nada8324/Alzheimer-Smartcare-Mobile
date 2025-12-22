import 'package:alzheimer_smartcare/global_controllers/main_app_controller.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/colors.dart';
import '../../utils/custom_widgets/custom_app_image.dart';
import '../../utils/custom_widgets/custom_button.dart';
import 'controller.dart';


class OnBoardingScreen extends StatelessWidget {
  OnboardingController controller = Get.put(OnboardingController());
  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      padding: EdgeInsets.zero,
      bgColor: AppColors.primary,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: PageView.builder(itemBuilder: (context,index) => controller.BuiltOnBoardItem(controller.BoardingList[index]),
              itemCount: controller.BoardingList.length,
              controller: controller.boardController,
              physics: BouncingScrollPhysics(),
              onPageChanged: (int index)
              {
                if(index == controller.BoardingList.length-1){
                  controller.isLast = true;
                }
                else{
                  controller.isLast = false;
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: AppImage(
              svgAsset: AssetsPaths.splashItem1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(45.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  buttonType: ButtonType.elevated,
                  fontWeight: FontWeight.bold,
                  text: "Next".tr,
                  textSize: 18,
                  onPressed: ()
                  {
                    if(controller.isLast){
                      controller.submit();
                    }
                    else{
                      controller.boardController.nextPage(
                        duration: Duration(
                          seconds: 2,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  width: 160.w,
                  height: 52.h,
                  borderRadius: BorderRadius.circular(50),
                  bgColor: AppColors.lightOrange,
                  textColor: AppColors.white,
                  shadowColor: AppColors.grey,
                ),
                SizedBox(height: 32.h,),
                SmoothPageIndicator(
                  controller: controller.boardController,
                  count: controller.BoardingList.length,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColors.lightGrey,
                    activeDotColor: AppColors.lightOrange,
                    dotHeight: 12,
                    expansionFactor: 4,
                    dotWidth: 12,
                    spacing: 5,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AppImage(
              svgAsset: AssetsPaths.splashItem2,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 70.h,horizontal: 20.w),
              child: Row(
                children: [
                  AppButton(
                    buttonType: ButtonType.elevatedWithIconRow,
                    fontWeight: FontWeight.bold,
                    text: "En-ar".tr,
                    textSize: 18,
                    onPressed: ()
                    {
                      MainAppController mainAppController = Get.find();
                      mainAppController.changeAppLang(Get.locale?.languageCode == "en" ? Lang.ar : Lang.en);
                    },
                    width: 73.w,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(50),
                    bgColor: AppColors.white,
                    textColor: AppColors.black,
                    shadowColor: AppColors.grey,
                    svgImageIcon: AssetsPaths.onboardingLanguageSVG,
                  ),
                  Spacer(),
                  AppButton(
                    buttonType: ButtonType.elevatedWithIconRow,
                    fontWeight: FontWeight.bold,
                    text: "Skip".tr,
                    textSize: 18,
                    onPressed: ()
                    {
                      controller.submit();
                    },
                    width: 69.w,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(50),
                    bgColor: AppColors.white,
                    textColor: AppColors.black,
                    shadowColor: AppColors.grey,
                    svgImageIcon: AssetsPaths.rightArrowSVG,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


