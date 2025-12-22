import 'dart:convert';

import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'controller.dart';
import 'memoriesModel.dart';

class MemoriesScreen extends StatelessWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientHomeController>(
      init: PatientHomeController(),
      builder: (controller) {
        return AppScreen(
          bgColor: AppColors.primary,
          padding: EdgeInsets.zero,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: AppImage(
                  svgAsset: AssetsPaths.splashItem1,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: AppImage(
                      assetImage: AssetsPaths.LogoPNG,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          SizedBox(width: 10.w),
                          AppText(
                            'Saved Memories'.tr,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),

                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Expanded(
                      child: controller.faces.isEmpty
                          ? Center(
                        child: AppText(
                          'No saved memories yet'.tr,

                            fontSize: 18.sp,
                            color: AppColors.white.withValues(alpha: .7),

                        ),
                      )
                          : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: controller.faces.length,
                        itemBuilder: (context, index) {
                          final face = controller.faces[index];
                          return MemoryCard(face: face);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MemoryCard extends StatelessWidget {
  final Face face;

  const MemoryCard({Key? key, required this.face}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: AppColors.white.withValues(alpha: 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Container(
                color: AppColors.white,
                child: _buildFaceImage(face.imageBase64),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: AppText(
              face.name,
              textAlign: TextAlign.center,

                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceImage(String base64Image) {
    try {
      String imageData = base64Image;
      if (imageData.contains(',')) {
        imageData = imageData.split(',').last;
      }

      return AppImage(

        memoryImageBytes: base64Decode(imageData),
        fit: BoxFit.cover,
        placeHolder:_buildPlaceholder(),
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.face,
        size: 48.w,
        color: Colors.grey,
      ),
    );
  }
}