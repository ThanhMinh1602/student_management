import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: titleColor ?? AppColor.white,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColor.pink,
      elevation: 0, 
      
      // Xử lý nút Leading (Nút bên trái)
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded, // Icon back đẹp hơn mặc định
                color: titleColor ?? AppColor.white,
                size: 20,
              ),
              // Nếu không truyền hàm xử lý riêng thì mặc định là Get.back()
              onPressed: onLeadingPressed ?? () => Get.back(),
            )
          : null, // Nếu showBackButton = false, để null cho Flutter tự xử lý (ví dụ nút Drawer)
          
      actions: actions,
    );
  }

  @override
  // Bắt buộc phải override getter này để Scaffold biết chiều cao của AppBar
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}