import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            color: AppColors.homeGreyText,
            fontSize: 19,
          ),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  hintText: hint,
                  readOnly: widget == null ? false : true,
                  controller: controller,
                ),
              ),
              widget == null ? Container() : Container(child: widget),
            ],
          ),
        ],
      ),
    );
  }
}
