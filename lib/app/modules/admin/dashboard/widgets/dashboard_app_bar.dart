import 'package:flutter/material.dart';
import 'package:blooket/app/core/components/appbar/app_header.dart';
// shared header used; no extra imports required

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const DashboardAppBar({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      // Brand header (no back button) is controlled by AppHeader
      userName: userName,
      avatarUrl: avatarUrl,
      onAvatarTap: onAvatarTap,
      backgroundColor: null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}