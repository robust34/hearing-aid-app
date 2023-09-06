import 'package:doceo_new/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle fontStyle({
  double scaleFactor = 1.0,
  double fontSize = 16,
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
  String fontFamily = 'M_PLUS',
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    color: color,
    fontSize: fontSize * scaleFactor,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}

class AppStyles {
  static List fontSizeLevel = [0.85, 1.0, 1.15, 1.3];
  static int _selectedIndex = 2;

  static Future<void> loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedIndex = prefs.getInt('font_size_selectedIndex') ?? 2;
  }

  static double get scaleFactor => fontSizeLevel[_selectedIndex];

  static TextStyle get title => fontStyle(
      scaleFactor: scaleFactor,
      fontSize: 15,
      color: AppColors.mainText,
      fontWeight: FontWeight.bold);

  static TextStyle get content => fontStyle(
      scaleFactor: scaleFactor,
      fontSize: 15,
      color: AppColors.mainText2,
      fontWeight: FontWeight.normal);

  static TextStyle get date => fontStyle(
      scaleFactor: scaleFactor,
      fontSize: 12,
      color: AppColors.subText,
      fontWeight: FontWeight.normal);

  static TextStyle get replyMessage => fontStyle(
      scaleFactor: scaleFactor,
      fontSize: 15,
      color: AppColors.mainText,
      fontWeight: FontWeight.normal);

  static TextStyle get messageAction => fontStyle(
      scaleFactor: scaleFactor,
      fontSize: 15,
      color: AppColors.mainText,
      fontWeight: FontWeight.normal);
}
