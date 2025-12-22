import 'package:alzheimer_smartcare/screens/patient/careGivers/controller.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/custom_widgets/customLogOutDialog.dart';
import '../../../utils/custom_widgets/custom_app_bar.dart';

class Caregiversscreen extends StatelessWidget {
  const Caregiversscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CareGiversController>(
      init: CareGiversController(),
      builder: (controller) {
        return AppScreen(
          bgColor: AppColors.white,
          appBar: customAppBar(
            context,
            backgroundColor: AppColors.white,
          ),
          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(

                    child: StreamBuilder<QuerySnapshot>(
                      stream: controller.pendingRequests,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          MainAppController.showLoading();
                          return Center(child: CircularProgressIndicator());
                        }

                        EasyLoading.dismiss();

                        if (snapshot.hasError) {
                          return Center(
                            child: AppText(
                              'Error: ${snapshot.error}',color: Colors.red,

                            ),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];
                        if (docs.isEmpty) {
                          return Center(child: AppText('No pending requests'.tr,fontSize: 18,fontWeight: FontWeight.w500,));
                        }

                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final req = docs[index];
                            return Container(
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  AppText(
                                    req['caregiverEmail'],
                                    fontSize: 20.sp,
                                    color: AppColors.homeGreyText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  Spacer(),
                                  AppButton(
                                    bgColor: AppColors.white,
                                    buttonType: ButtonType.icon,
                                    iconData: Icons.check,
                                    onPressed: () => controller
                                        .respondToRequest(req.id, 'approved'),
                                  ),
                                  AppButton(
                                    bgColor: AppColors.white,
                                    buttonType: ButtonType.icon,
                                    iconData: Icons.close,
                                    onPressed: () => controller
                                        .respondToRequest(req.id, 'rejected'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Your Care Givers".tr,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        SizedBox(height: 10.h),
                        Expanded(
                          child: StreamBuilder<List<String>>(
                            stream: controller.caregiversList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                MainAppController.showLoading();
                                return Center(child: CircularProgressIndicator());
                              }

                              EasyLoading.dismiss();

                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }

                              final caregivers = snapshot.data ?? [];

                              if (caregivers.isEmpty) {
                                return Center(
                                  child: AppText('No caregivers added yet'.tr),
                                );
                              }

                              return ListView.separated(
                                itemCount: caregivers.length,
                                separatorBuilder: (context, index) => Divider(height: 1.h),
                                itemBuilder: (context, index) {
                                  final email = caregivers[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                                    title: AppText(email,fontSize: 20.sp,fontWeight: FontWeight.w400,),
                                    trailing: AppButton(
                                      bgColor: AppColors.white,
                                      buttonType: ButtonType.icon,
                                      iconData: Icons.remove_circle, iconColor: Colors.red,
                                      onPressed: () {
                                        showConfirmationDialog(
                                          isPatient: false,
                                          title: "Remove Caregiver".tr,
                                          description: "Are you sure you want to remove $email from your caregivers?".tr,
                                          confirmButtonText: "Remove",
                                          confirmColor: Colors.red,
                                          onConfirm: () {
                                            Get.back();
                                            controller.removeCaregiver(email);
                                          }
                                        );
                                      }
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}

