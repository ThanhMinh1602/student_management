import 'package:flutter/material.dart';
import 'package:blooket/app/core/components/appbar/app_header.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final VoidCallback? onLeadingPressed;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true, // Mặc định là hiện nút Back
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.onLeadingPressed,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    // Delegate to shared AppHeader to keep header logic in one place.
    return AppHeader(
      title: title,
      showBackButton: showBackButton,
      actions: actions,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      onLeadingPressed: onLeadingPressed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}