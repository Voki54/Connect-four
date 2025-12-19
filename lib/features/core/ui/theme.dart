import 'package:flutter/material.dart';
import 'colors.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  dividerColor: AppColors.lightSurface,
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(AppColors.lightSurface),
    ),
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  fontFamily: "UbuntuSansMono",
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: AppColors.lightTextPrimary,
      fontSize: 26,
      letterSpacing: 0.25,
    ),
    // bodyText1: TextStyle(color: AppColors.lightTextPrimary),
  ),
);
