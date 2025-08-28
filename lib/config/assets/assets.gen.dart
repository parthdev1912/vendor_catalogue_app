// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsAppLogoGen {
  const $AssetsAppLogoGen();

  /// File path: assets/app_logo/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/app_logo/app_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [appLogo];
}

class $AssetsFontGen {
  const $AssetsFontGen();

  /// File path: assets/font/WorkSans-Black.ttf
  String get workSansBlack => 'assets/font/WorkSans-Black.ttf';

  /// File path: assets/font/WorkSans-Bold.ttf
  String get workSansBold => 'assets/font/WorkSans-Bold.ttf';

  /// File path: assets/font/WorkSans-ExtraBold.ttf
  String get workSansExtraBold => 'assets/font/WorkSans-ExtraBold.ttf';

  /// File path: assets/font/WorkSans-ExtraLight.ttf
  String get workSansExtraLight => 'assets/font/WorkSans-ExtraLight.ttf';

  /// File path: assets/font/WorkSans-Light.ttf
  String get workSansLight => 'assets/font/WorkSans-Light.ttf';

  /// File path: assets/font/WorkSans-Medium.ttf
  String get workSansMedium => 'assets/font/WorkSans-Medium.ttf';

  /// File path: assets/font/WorkSans-Regular.ttf
  String get workSansRegular => 'assets/font/WorkSans-Regular.ttf';

  /// File path: assets/font/WorkSans-SemiBold.ttf
  String get workSansSemiBold => 'assets/font/WorkSans-SemiBold.ttf';

  /// List of all assets
  List<String> get values => [
    workSansBlack,
    workSansBold,
    workSansExtraBold,
    workSansExtraLight,
    workSansLight,
    workSansMedium,
    workSansRegular,
    workSansSemiBold,
  ];
}

class AppAssets {
  const AppAssets._();

  static const $AssetsAppLogoGen appLogo = $AssetsAppLogoGen();
  static const $AssetsFontGen font = $AssetsFontGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
