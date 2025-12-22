import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../global_models/bottom_nav_bat_item.dart';
import '../constants/assets.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';

Widget buildBottomNavBar({
  required int currentIndex,
  required Function(int) changeTab,
  required List<BottomNavBarItem> items,
  required String FABAsset,
  required Color FABColor,
  required Color FABOutlineColor,
  required Color activeColor,
  required Color inActiveColor,
  required Color FABImageColor
}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 18.h,
          ),
          Container(
            height: 75.h,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.r),
                topRight: Radius.circular(35.r),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildNavItem(
                    item: items[0],
                    index: 0,
                    currentIndex: currentIndex,
                    changeTab: changeTab,
                      activeColor: activeColor,
                      inactiveColor:inActiveColor,
                  ),
                  BuildNavItem(
                    item: items[1],
                    index: 1,
                    currentIndex: currentIndex,
                    changeTab: changeTab,
                    activeColor: activeColor,
                    inactiveColor:inActiveColor,
                  ),
                  SizedBox(width: 70.w), // Space for the FAB
                  BuildNavItem(
                    item: items[2],
                    index: 3,
                    currentIndex: currentIndex,
                    changeTab: changeTab,
                    activeColor: activeColor,
                    inactiveColor:inActiveColor,
                  ),
                  BuildNavItem(
                    item: items[3],
                    index: 4,
                    currentIndex: currentIndex,
                    changeTab: changeTab,
                    activeColor: activeColor,
                    inactiveColor:inActiveColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Positioned(
        bottom: 7.h,
        child: buildFAB(changeTab: changeTab,
        FABOutlineColor: FABOutlineColor,
        FABColor: FABColor,
        svgAsset: FABAsset,
            FABImageColor: FABImageColor),
      ),
    ],
  );
}

Widget buildFAB(
    {required Function(int) changeTab,
    required String svgAsset,
      required Color FABOutlineColor,
    required Color FABColor,
      required Color FABImageColor}) {
  return Container(
    height: 92.h,
    width: 92.w,
    padding: EdgeInsets.all(6.r), // Adjust padding as needed
    decoration: BoxDecoration(
      color: AppColors.white,
      shape: BoxShape.circle,
    ),
    child: FloatingActionButton(
      onPressed: () => changeTab(2),
      elevation: 0,
      shape: CircleBorder(),
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: FABOutlineColor,
        ),
        padding: EdgeInsets.all(6),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: FABColor ,
          ),
          child: Center(
            child: AppImage(
              fit: BoxFit.fitHeight,
              width: 20.w,
              height: 20.h,
              svgAsset: svgAsset,
              color: FABImageColor,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget BuildNavItem({
  required BottomNavBarItem item,
  required int index,
  required int currentIndex,
  required Function(int) changeTab,
  required Color activeColor,
  required Color inactiveColor,
}) {
  bool isSelected = currentIndex == index;
  return GestureDetector(
    onTap: () => changeTab(index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppImage(
          svgAsset: isSelected ? item.svgAssetActive : item.svgAsset,
          color: isSelected ? activeColor : inactiveColor,
          height: 24.h,
          width: 24.w,
        ),
        SizedBox(height: 4.h),
        AppText(
          item.label,
          color: isSelected ? activeColor : inactiveColor,
          fontSize: 12.sp,
        ),
      ],
    ),
  );
}
