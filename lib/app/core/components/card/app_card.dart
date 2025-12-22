import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4), blurRadius: 10)],
      ),
      child: child,
    );
  }
}
