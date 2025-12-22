import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Shimmer(
          gradient: AppColors.primaryGradient,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 100,
            height: 70,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15)),
          ),
        ),
        SizedBox(
            width: 80,
            height: 50,
            child: Shimmer(
                gradient: LinearGradient(colors: [
                  AppColors.lightBlue.withOpacity(.2),
                  AppColors.white,
                  AppColors.white
                ]),
                direction: ShimmerDirection.rtl,
                child: Lottie.asset(AssetsPaths.loadingJSON)))
      ],
    );
  }
}
