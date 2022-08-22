import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:akhiri_merokok/app/data/providers/my_shared_pref.dart';

import 'languages/localization_service.dart';

class MyFonts
{
  // return the right font depending on app language
  static TextStyle get getAppFontType => LocalizationService.supportedLanguagesFontsFamilies[MySharedPref.getCurrentLocal().languageCode]!;

  // headlines text font
  static TextStyle get headlineTextStyle => getAppFontType;

  // body text font
  static TextStyle get bodyTextStyle => getAppFontType;

  // body text font
  static TextStyle get hintTextStyle => getAppFontType;

  // button text font
  static TextStyle get buttonTextStyle => getAppFontType;

  // app bar text font
  static TextStyle get appBarTextStyle  => getAppFontType;

  // chips text font
  static TextStyle get chipTextStyle  => getAppFontType;

  // appbar font size
  static double get appBarTittleSize => 18.sp;

  // body font size
  static double get body1TextSize => 13.sp;
  static double get body2TextSize => 13.sp;

  // headlines font size
  static double get headline1TextSize => 26.sp;
  static double get headline2TextSize => 16.sp;
  static double get headline3TextSize => 12.sp;
  static double get headline4TextSize => 12.sp;
  static double get headline5TextSize => 12.sp;
  static double get headline6TextSize => 17.sp;

  // hint font size
  static double get hintTextSize => 12.sp;

  //button font size
  static double get buttonTextSize => 16.sp;

  //caption font size
  static double get captionTextSize => 13.sp;

  //chip font size
  static double get chipTextSize => 10.sp;
}