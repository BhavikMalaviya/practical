import 'package:flutter/material.dart';
import 'package:practical/utils/app_colors.dart';

abstract class AppTheme {
  static ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
  );
}
