import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../constants/strings.dart';

/// Small helpers for common dialogs using Get.
class AppDialogs {
  /// Generic confirm dialog that forwards supported Get.defaultDialog params.
  static void showConfirm({
    String? title,
    TextStyle? titleStyle,
    String? middleText,
    Widget? content,
    EdgeInsets? contentPadding,
    double? radius,
    String? textConfirm,
    String? textCancel,
    Widget? confirm,
    Widget? cancel,
    Color? confirmTextColor,
    Color? buttonColor,
    Color? cancelTextColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.defaultDialog(
      title: title ?? AppStrings.logoutTitle,
      titleStyle: titleStyle,
  middleText: middleText ?? '',
      content: content,
      contentPadding: contentPadding,
  radius: radius ?? 0,
      textConfirm: textConfirm,
      textCancel: textCancel,
      confirm: confirm,
      cancel: cancel,
      confirmTextColor: confirmTextColor,
      buttonColor: buttonColor,
      cancelTextColor: cancelTextColor,
      onConfirm: () {
        Get.back();
        if (onConfirm != null) onConfirm();
      },
      onCancel: () {
        Get.back();
        if (onCancel != null) onCancel();
      },
    );
  }

  static void showLogoutConfirm({required VoidCallback onConfirm}) {
    showConfirm(
      title: AppStrings.logoutTitle,
      middleText: AppStrings.logoutConfirm,
      textConfirm: AppStrings.confirm,
      textCancel: AppStrings.cancel,
      onConfirm: onConfirm,
    );
  }
}
