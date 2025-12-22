import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_controllers/main_app_controller.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import '../translation/translation.dart';
import 'custom_app_image.dart';
import 'custom_button.dart';
import 'custom_text.dart';

class WhenChangeLangDialog extends StatelessWidget {
  const WhenChangeLangDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainAppController>(
        init: MainAppController(),
        builder: (controller) {
          return Column(
            children: [
              AppButton(
                onPressed: () async {
                  await controller.changeAppLang(Lang.ar);
                  await controller.initApp();
                },
                buttonType: ButtonType.inkwell,
                child: Row(
                  children: [

                    const Expanded(child: AppText("العربية")),
                    Icon(
                      Get.locale?.languageCode == "ar"
                          ? Icons.radio_button_checked_outlined
                          : Icons.radio_button_off,
                      color: Get.locale?.languageCode == "ar"
                          ? AppColors.secondary
                          : AppColors.lightColor,
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Divider(
                  thickness: 2,
                ),
              ),
              AppButton(
                onPressed: () async {
                  await controller.changeAppLang(Lang.en);
                  await controller.initApp();
                },
                buttonType: ButtonType.inkwell,
                child: Row(
                  children: [

                    const Expanded(child: AppText("English")),
                    Icon(
                      Get.locale?.languageCode == "en"
                          ? Icons.radio_button_checked_outlined
                          : Icons.radio_button_off,
                      color: Get.locale?.languageCode == "en"
                          ? AppColors.secondary
                          : AppColors.lightColor,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
