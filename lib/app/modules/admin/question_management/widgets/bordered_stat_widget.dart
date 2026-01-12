import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_color.dart';

class BorderedStatWidget extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final Widget? trailing;

  const BorderedStatWidget({
    super.key,
    required this.title,
    this.value,
    this.icon = Icons.access_time,
    this.color = AppColor.white,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: color, width: 3.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 35),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 12), trailing!],
              if (value != null) ...[
                const SizedBox(width: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: color, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
