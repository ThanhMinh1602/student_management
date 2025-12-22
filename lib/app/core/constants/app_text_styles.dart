import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography tokens for the app (Design System)
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headlineLarge = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 40,
  );

  static const TextStyle bannerTitle = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText = TextStyle(
    color: Colors.white70,
    fontSize: 16,
  );

  static const TextStyle dialogTitle = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle buttonWhite = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
