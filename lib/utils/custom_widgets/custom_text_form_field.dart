import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/colors.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String hintText;
  final String? prefixIconPath;
  final bool obscureText;
  final bool showSuffixIcon;
  final IconData? suffixIconData;
  final Icon? prefixIcon;
  final String? suffixImage;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onSuffixIconPressed;
  final bool readOnly;
  final double verticalPadding;
  final double horizontalPadding;
  final bool isPrefixIcon;
  final bool svgSuffixIcon;
  final bool errorBorderVisible;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextFormField({
    Key? key,
    this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.prefixIconPath,
    this.obscureText = false,
    this.showSuffixIcon = false,
    this.suffixIconData,
    this.prefixIcon,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.onSuffixIconPressed,
    this.readOnly = false,
    this.verticalPadding = 16.0,
    this.horizontalPadding = 16.0,
    this.isPrefixIcon = false,
    this.svgSuffixIcon = false,
    this.suffixImage,
    this.inputFormatters,
    this.errorBorderVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofocus: true,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 16.sp,    // Adjust font size as desired
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: AppColors.textFieldColor, // Light background color
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.darkGrey, // or a custom light grey
        ),

        // Adjust padding so text is centered and comfortable
        contentPadding: EdgeInsets.symmetric(
          vertical: 16.h,  // vertical padding
          horizontal: 20.w,
        ),

        // If you prefer to remove default spacing, you can keep these:
        // isDense: true,
        // isCollapsed: true,

        // Leading icon
        prefixIcon: isPrefixIcon
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SvgPicture.asset(
            prefixIconPath!,
            width: 18.w,
            height: 18.h,
          ),
        )
            : prefixIcon,

        // Trailing icon (suffix)
        suffixIcon: showSuffixIcon
            ? svgSuffixIcon
            ? InkWell(
          onTap: onSuffixIconPressed,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset(suffixImage!),
          ),
        )
            : IconButton(
          icon: Icon(
            suffixIconData,
            size: 18.w,
          ),
          onPressed: onSuffixIconPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        )
            : null,

        // Rounded "pill" shape with a visible blue outline
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.transparent, // Blue border color
            width: 1.5,               // Border thickness
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: AppColors.secondary, // Blue border color
            width: 3,                 // Thicker border on focus
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.red,
            width: 3,
          ),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
    );
  }
}