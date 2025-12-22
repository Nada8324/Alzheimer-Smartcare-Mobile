import 'package:alzheimer_smartcare/global_controllers/main_app_controller.dart';
import 'package:alzheimer_smartcare/screens/patient/Schedule/controller.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import '../AddReminders/addTask.dart';
import 'model.dart';

class PatientScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientScheduleController>(
      init: PatientScheduleController(),
      builder: (controller) {
        return AppScreen(
          bgColor: AppColors.lightGrey.withValues(alpha: 0.5),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 140.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(15.r),
                        bottomStart: Radius.circular(15.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 70.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextFormField(
                                  controller: controller.searchController,
                                  hintText: "search...".tr,
                                  prefixIcon: Icon(
                                    IconsaxPlusLinear.search_normal,
                                    size: 20,
                                  ),
                                  onChanged: controller.SearchChanged,
                                  onSubmitted: controller.SearchSubmitted,
                                  textInputAction: TextInputAction.search,
                                ),
                              ),
                              // Sort button
                              AppButton(
                                buttonType: ButtonType.icon,
                                iconData: IconsaxPlusLinear.sort,
                                bgColor: AppColors.transparent,
                                iconColor: AppColors.white,
                                iconSize: 20,
                                onPressed: () => controller.showSortDialog(context),
                                width: 24.w,
                                height: 24.h,
                              ),
                              SizedBox(width: 2.w),
                              // Filter button
                              AppButton(
                                buttonType: ButtonType.icon,
                                iconData: IconsaxPlusLinear.filter,
                                bgColor: AppColors.transparent,
                                iconColor: AppColors.white,
                                iconSize: 20,
                                onPressed: () => controller.showFilterDialog(context),
                                width: 24.w,
                                height: 24.h,
                              ),
                              SizedBox(width: 10.w),
                              // Clear button
                              AppButton(
                                buttonType: ButtonType.inkwell,
                                width: 65.w,
                                child: Row(
                                  children: [
                                    Icon(Icons.highlight_remove, color: AppColors.white),
                                    AppText(
                                      "Clear".tr,
                                      color: AppColors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                bgColor: AppColors.transparent,
                                onPressed: controller.Clear,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Reminders list
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: MainAppController.showLoading(),
                        );
                      }

                      if (!controller.isLoading.value) {
                        EasyLoading.dismiss();
                      }

                      List<Reminder> filteredList = controller.filteredReminders;

                      final Map<String, List<Reminder>> groupedReminders = {};
                      for (var reminder in filteredList) {
                        groupedReminders.putIfAbsent(reminder.type, () => []).add(reminder);
                      }

                      List<Widget> sections = [];
                      groupedReminders.forEach((type, reminders) {
                        sections.add(controller.buildSection(type, reminders, controller));
                      });

                      if (sections.isEmpty) {
                        return Center(
                          child: AppText(
                            controller.searchQuery.value.isEmpty
                                ? "No reminders found".tr
                                : "No results for '${controller.searchQuery.value}'".tr,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppColors.inActiveIconPatient,
                          ),
                        );
                      }

                      // Display sections
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 15.h,
                          right: 8.w,
                          left: 8.w,
                          bottom: 100.h,
                        ),
                        children: sections,
                      );
                    }),
                  ),
                ],
              ),
              // Add reminder button
              Positioned(
                bottom: 80.h,
                right: 15.w,
                child: AppButton(
                  buttonType: ButtonType.floating,
                  shadowColor: AppColors.transparent,
                  width: 60.w,
                  height: 60.h,
                  iconData: Icons.add,
                  bgColor: AppColors.white,
                  iconColor: AppColors.secondary,
                  iconSize: 30,
                  onPressed: () async {
                    final result = await Get.to(() => AddTaskPage());
                    if (result == true) await controller.fetchReminders();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}