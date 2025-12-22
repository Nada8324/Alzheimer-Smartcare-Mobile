import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/assets.dart';
import '../constants/colors.dart';
import '../shimmers/custom_shimmer_builder.dart';

class AppImage extends StatelessWidget {
  final String? urlImage;
  final String? assetImage;
  final String? svgAsset;
  final File? fileImage;
  final BorderRadius? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final Color? borderColor;
  final bool isHero;
  final Widget? placeHolder;
  final bool shimmerUntil;
  final double? width, height;
  final EdgeInsets? padding;
  final Uint8List? memoryImageBytes;
  const AppImage({
    Key? key,
    this.color,
    this.svgAsset,
    this.placeHolder,
    this.shimmerUntil = false,
    this.width,
    this.borderColor,
    this.isHero = false,
    this.height,
    this.padding,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.urlImage,
    this.assetImage,
    this.fileImage,
    this.memoryImageBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: borderColor == null
              ? null
              : Border.all(color: borderColor ?? AppColors.white),
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
        child: (shimmerUntil && urlImage == null)
            ? placeHolder ??
                Center(
                    child: CustomShimmerBuilder(
                        child: Image.asset(AssetsPaths.appLogo)))
            : memoryImageBytes != null
            ? ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: isHero
              ? Hero(tag: 'memory-${memoryImageBytes.hashCode}', child: _memory())
              : _memory(),
        )
            : fileImage != null
                ? ClipRRect(
                    borderRadius: borderRadius ?? BorderRadius.zero,
                    child: isHero
                        ? Hero(tag: fileImage?.path ?? "", child: _file())
                        : _file(),
                  )
                : urlImage != null
                    ? (ClipRRect(
                        borderRadius: borderRadius ?? BorderRadius.zero,
                        child: isHero
                            ? Hero(
                                tag: urlImage?.replaceAll("http:", "https:") ??
                                    "",
                                child: _url())
                            : _url()))
                    : (svgAsset != null
                        ? (ClipRRect(
                            borderRadius: borderRadius ?? BorderRadius.zero,
                            child: isHero
                                ? Hero(tag: svgAsset ?? "", child: _svg())
                                : _svg()))
                        : placeHolder ??
                            ClipRRect(
                              borderRadius: borderRadius ?? BorderRadius.zero,
                              child: Image.asset(
                                assetImage ?? AssetsPaths.appLogo,
                                width: width,
                                color: color,
                                height: height,
                                fit: fit,
                                errorBuilder: (context, e, s) =>
                                    CustomShimmerBuilder(
                                        child: Image.asset(
                                            AssetsPaths.appLogo)),
                              ),
                            )),
      );
    } catch (e) {
      return CustomShimmerBuilder(child: Image.asset(AssetsPaths.appLogo));
    }
  }

  _file() {
    return Image.file(
      fileImage ?? File(""),
      width: width,
      color: color,
      height: height,
      fit: fit,
      errorBuilder: (context, e, s) =>
          CustomShimmerBuilder(child: Image.asset(AssetsPaths.appLogo)),
    );
  }

  _url() {
    return CachedNetworkImage(
        imageUrl: urlImage?.replaceAll("http:", "https:") ?? "",
        width: width,
        height: height,
        color: color,
        errorWidget: (context, e, s) =>
            CustomShimmerBuilder(child: Image.asset(AssetsPaths.appLogo)),
        placeholder: (context, url) {
          return ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: placeHolder ??
                CustomShimmerBuilder(
                    child: Image.asset(AssetsPaths.appLogo)),
          );
        },
        imageBuilder: (context, imageP) => SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.zero,
                child: Image(
                  image: imageP,
                  color: color,
                  fit: fit,
                  width: width,
                  height: height,
                  errorBuilder: (context, e, s) => CustomShimmerBuilder(
                      child: Image.asset(AssetsPaths.appLogo)),
                ),
              ),
            ));
  }

  _svg() {
    if (svgAsset == null) {
      return null;
    }
    return SvgPicture.asset(
      svgAsset!,
      width: width,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcATop),
      height: height,
      fit: fit ?? BoxFit.fitWidth,
    );
  }
  _memory() {
    return Image.memory(
      memoryImageBytes!,
      width: width,
      height: height,
      color: color,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => CustomShimmerBuilder(
          child: Image.asset(AssetsPaths.appLogo)),
    );
  }
}
