import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/core/constants/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.action,
        foregroundColor: foregroundColor ?? AppColors.white,
        minimumSize: Size(double.infinity, height ?? 50),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.buttonWhite,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
