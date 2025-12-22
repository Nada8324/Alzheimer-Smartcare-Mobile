import 'package:flutter/material.dart';

import 'colors.dart';

enum ThemeType { light, dark }

const String AppFontFamily = 'Kaleko';

class AppThemes {
  /*


Light Theme



*/

  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
      fontFamily: AppFontFamily,
      colorScheme: const ColorScheme(
        primary: AppColors.secondary,
        primaryContainer: AppColors.secondary,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondary,
        surface: AppColors.lightColor,
        background: AppColors.lightColor,
        error: AppColors.red,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.secondary,
        onBackground: AppColors.secondary,
        onError: AppColors.white,
        brightness: Brightness.light,
      ),
      primarySwatch: generateMaterialColor(AppColors.secondary),
      hintColor: AppColors.lightBlue,
      shadowColor: AppColors.lightBlue,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
      ),
      indicatorColor: AppColors.secondary,
      scaffoldBackgroundColor: AppColors.lightColor,
      
      
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: buttonStyle(outlined: true)),
      textButtonTheme: TextButtonThemeData(style: buttonStyle()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle()),
      inputDecorationTheme: inputDecorationTheme(),
      buttonTheme: buttonThemeData(),
      appBarTheme: appBarTheme(),
      textTheme: textTheme());

/*


Dark Theme



*/

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
      fontFamily: AppFontFamily,
      colorScheme: const ColorScheme(
        primary: AppColors.white,
        primaryContainer: AppColors.darkBlue,
        secondary: AppColors.white,
        secondaryContainer: AppColors.darkBlue,
        surface: AppColors.lightColor,
        background: AppColors.lightColor,
        error: AppColors.red,
        onPrimary: AppColors.darkBlue,
        onSecondary: AppColors.darkBlue,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
        onError: AppColors.darkBlue,
        brightness: Brightness.dark,
      ),
      primarySwatch: generateMaterialColor(AppColors.greyText),
      hintColor: AppColors.lightBlue,
      shadowColor: AppColors.lightBlue,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.greyText,
      ),
      indicatorColor: AppColors.greyText,
      scaffoldBackgroundColor: AppColors.lightColor,
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: buttonStyle(outlined: true)),
      textButtonTheme: TextButtonThemeData(style: buttonStyle()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle()),
      inputDecorationTheme: inputDecorationTheme(),
      buttonTheme: buttonThemeData(),
      appBarTheme: appBarTheme(),
      textTheme: textTheme());
}

/*


Button Style



*/

ButtonStyle buttonStyle(
    {bool outlined = false,
    BorderRadius? borderRadius,
    Color? bgColor,
    borderColor,
    shadowColor,
    double? width,
    height,
    EdgeInsets? padding,
  Color? textColor,
    bool isDark = false}) {
  return ButtonStyle(
    alignment: Alignment.center,
    textStyle: MaterialStateProperty.all(
    TextStyle(color: textColor)),
    backgroundColor: MaterialStateProperty.all(
        bgColor ?? (outlined ? Colors.transparent : AppColors.primary)),
    minimumSize:
        MaterialStateProperty.all(Size(width ?? 10000, height ?? 35)),
    padding: MaterialStateProperty.all(
        padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
    shadowColor:
        MaterialStateProperty.all(shadowColor ?? AppColors.textFieldHintText),
    side: outlined
        ? MaterialStateProperty.all(BorderSide(
            color:
                borderColor ?? (isDark ? AppColors.darkBlue : AppColors.secondary),
            width: 1.5))
        : null,
    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(5))),
  );
}

/*


Button Theme



*/

ButtonThemeData buttonThemeData() {
  return const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.secondary),
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );
}

/*


Input Decoration



*/

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
      fillColor: AppColors.lightColor,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignLabelWithHint: true,
      disabledBorder: outlineInputBorder(AppColors.secondary),
      enabledBorder: outlineInputBorder(AppColors.secondary),
      focusedBorder: outlineInputBorder(AppColors.secondary),
      errorBorder: outlineInputBorder(AppColors.red),
      focusedErrorBorder: outlineInputBorder(AppColors.red),
      suffixStyle: const TextStyle(
          color: AppColors.textFieldHintText,
          fontSize: 12,
          fontWeight: FontWeight.w600),
      errorStyle: const TextStyle(
          color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold),
      labelStyle: const TextStyle(
          color: AppColors.textFieldHintText,
          fontSize: 12,
          fontWeight: FontWeight.w600),
      hintStyle: const TextStyle(
          color: AppColors.textFieldHintText,
          fontSize: 12,
          fontWeight: FontWeight.w600));
}

/*


Outline Input Border



*/

OutlineInputBorder outlineInputBorder(Color color,
    {BorderRadius? borderRadius}) {
  return OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(5),
      borderSide: BorderSide(
        color: color,
      ));
}

/*


Text Theme



*/

TextTheme textTheme({Color color = AppColors.darkBlue}) {
  return TextTheme(
    titleMedium: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: AppFontFamily),
    bodyMedium: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: AppFontFamily), //inkwell,text
  );
}

/*


AppBar Theme



*/

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: AppColors.secondary,
    iconTheme: IconThemeData(
      color: AppColors.secondary,
      size: 20,
    ),
    centerTitle: true,
    toolbarTextStyle: TextStyle(
        fontFamily: AppFontFamily,
        color: AppColors.textFieldHintText,
        fontSize: 15,
        fontWeight: FontWeight.bold), //inkwell,text
    titleTextStyle: TextStyle(
        fontFamily: AppFontFamily,
        color: AppColors.textFieldHintText,
        fontSize: 15,
        fontWeight: FontWeight.bold), //tite
  );
}
