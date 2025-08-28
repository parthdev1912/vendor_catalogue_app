import 'package:flutter/material.dart';
import 'package:vendor_catalogue_app/config/assets/fonts.gen.dart';
import 'package:vendor_catalogue_app/constants/color_constant.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: AppFonts.worksans,
    scaffoldBackgroundColor: ColorConstant.white,
    primaryColor: ColorConstant.primary,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorConstant.primary,
      selectionHandleColor: ColorConstant.primary,
    ),
    //!appbar
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: ColorConstant.primary),
      color: ColorConstant.white,
      titleTextStyle: TextStyle(color: ColorConstant.primary, fontSize: 20),
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(ColorConstant.primary),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(ColorConstant.primary),
    ),
  );

}
