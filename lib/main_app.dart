import 'package:alzheimer_smartcare/screens/splash/view.dart';
import 'package:alzheimer_smartcare/utils/constants/localizations.dart';
import 'package:alzheimer_smartcare/utils/constants/styles_and_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'global_controllers/my_bindings.dart';
import 'utils/translation/translation.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            home: const Splash(),
            initialBinding: MyBindings(),
            defaultTransition: Transition.rightToLeft,
            title: "app_name".tr,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.lightTheme,
            builder: EasyLoading.init(),
            locale: const Locale("en", "US"),
            translations: AppTranslation(),
            debugShowCheckedModeBanner: false,
            supportedLocales: supportedLocales,
            localizationsDelegates: localizationsDelegate,
            localeResolutionCallback: localeResolutionCallback,
          );
        });
  }
}
