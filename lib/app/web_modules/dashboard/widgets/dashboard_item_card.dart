import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class DashboardItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,

      shadowColor: theme.shadowColor.withOpacity(0.2), // Shadow theo theme
      color: AppColor.secondary, // Màu nền card theo theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        hoverColor: color.withOpacity(0.1),
        child: Container(
          width: 300,
          height: 180,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const Spacer(),
              Text(
                title,
                // Chuẩn: Dùng titleLarge
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                // Chuẩn: Dùng bodyMedium + hintColor (màu xám mặc định của theme)
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}