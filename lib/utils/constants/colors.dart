import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {

  //Colors
  static const Color primary = Color(0xff006AAA);
  static const Color secondary = Color(0xff00AAD0);
  static const Color darkBlue = Color(0xff0B0051);
  static const Color lightBlue = Color(0xff7EDBEB);
  static const Color lightColor = Color(0xffC0EDF6);
  static const Color white = Color(0xffFFFFFF);
  static const Color red = Color(0xffFF375E);
  static const Color redBlack = Color(0xffE7212D);
  static const Color dangerRed = Color(0xffFF2633);
  static const Color warning = Color(0xffFFB93C);
  static const Color warningWithOpacity = Color(0xffFFF6E5);
  static const Color greyText = Color(0xffB6C9D9);
  static const Color textFieldHintText = Color(0xff5D719C);
  static const Color textFieldColor = Color(0xffF1F4FF);
  static const Color lightGrey =Color(0xffEEEEEE);
  static const Color DoctorButtons =Color(0xffD3DEFF);
  static const Color lightPurple=Color(0xffA9C0FF);
  static const Color FAB=Color(0xff613EEA);
  static const Color inActiveIcon=Color(0xff7890B0);
  static const Color activeIcon=Color(0xff386BF6);
  static const Color black=Color(0xff000000);
  static const Color cancelButton=Color(0xffE6E6E9);
  static const Color logoutButton=Color(0xffFF4217);
  static const Color settingIcon=Color(0xff2969FE);
  static const Color bgImageColor=Color(0xffD9D9D9);
  static const Color lightBink=Color(0xffFFDEDE);
  static const Color grey=Color(0xffABABAB);
  static const Color darkGrey=Color(0xff73737C);
  static const Color darkGrey2=Color(0xff626262);
  static const Color textFieldSelectedColor=Color(0xff1F41BB);
  static const Color lightOffWhite=Color(0xffF4F7FF);
  static const Color lightOrange=Color(0xffF88160);
  static const Color inActiveIconPatient=Color(0xff555555);
  static const Color shadowColor=Color(0x42000000);
  static const Color yellow=Color(0xffFAB81E);
  static const Color homeGreyText= Color(0xff393E46);
  static const Color photoShadow= Color(0xff6C6C6C);
  static const Color deleteIcon=Color(0xffFF0000);
  static const Color transparent = Colors.transparent;




  //Gradient
  static const Gradient primaryGradient = LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        primary,
        secondary,
        darkBlue,
      ]);
}




MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
