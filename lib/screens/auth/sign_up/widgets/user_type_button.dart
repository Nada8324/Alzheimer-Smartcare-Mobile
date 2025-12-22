import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/custom_widgets/custom_text.dart';
import '../controller.dart';
import '../model.dart';

class UserTypeButton extends StatelessWidget {
  final RegisterController controller;

  const UserTypeButton({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UserTypeModel>(
      onSelected: (UserTypeModel selectedModel) {
        controller.changeUserType(selectedModel.name);
      },
      itemBuilder: (BuildContext context) {
        return controller.userTypes.map((type) {
          return PopupMenuItem<UserTypeModel>(
            value: type,
            child: AppText(
              type.name.tr,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              controller.selectedUserType,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_drop_down, color: AppColors.black),
          ],
        ),
      ),
    );
  }
}