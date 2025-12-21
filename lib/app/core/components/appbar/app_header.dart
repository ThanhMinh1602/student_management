import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_color.dart';
import '../../constants/strings.dart';

/// Reusable App header used across admin screens.
/// Supports either a brand header (no back button) or a normal header with back button.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // page title (optional)
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final VoidCallback? onLeadingPressed;

  // user section (right side)
  final String? userName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const AppHeader({
    super.key,
    this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.onLeadingPressed,
    this.userName,
    this.avatarUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColor.pink,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: titleColor ?? AppColor.white, size: 20),
              onPressed: onLeadingPressed ?? () => Get.back(),
            )
          : null,
      title: Row(
        children: [
          // If no back button, show brand logo on the left
          if (!showBackButton) ...[
            Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, color: AppColor.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: titleColor ?? AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ] else ...[
            // If showing back, display the page title instead
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: titleColor ?? AppColor.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ]
        ],
      ),
      centerTitle: false,
      actions: [
        if (userName != null) ...[
          Row(
            children: [
              Text(
                '${AppStrings.welcomePrefix}${userName!}',
                style: TextStyle(
                  color: titleColor ?? AppColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.secondary,
                  backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                      ? NetworkImage(avatarUrl!)
                      : null,
                  child: (avatarUrl == null || avatarUrl!.isEmpty)
                      ? Text(
                          _getFirstLetter(userName!),
                          style: const TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
            ],
          )
        ],
        if (actions != null) ...actions!,
      ],
    );
  }

  String _getFirstLetter(String name) {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
