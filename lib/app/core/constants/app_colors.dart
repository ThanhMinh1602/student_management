import 'package:flutter/material.dart';

/// Centralized color tokens for the app (Design System)
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFDCD6F7);
  static const Color primary = Color(0xFF909CC2);
  // Backwards-compatible aliases (some files still use AppColor.* names)
  static const Color secondary = Color(0xFFd6d2f2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color pink = Color(0xFFE8BDDC);
  static const Color action = Color(0xFF88D8B0);
  static const Color danger = Colors.redAccent;
  static const Color muted = Colors.grey;
}
