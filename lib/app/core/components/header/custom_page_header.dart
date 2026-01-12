import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class CustomPageHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final IconData buttonIcon;
  final Color? buttonColor;
  final Color textColor;
  final Widget? extraWidget;

  const CustomPageHeader({
    super.key,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
    this.buttonIcon = Icons.add, // Icon mặc định
    this.buttonColor = AppColor.green, // Màu mặc định theo mẫu cũ
    this.textColor = Colors.white,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Phần Tiêu đề & Mô tả
        if (extraWidget != null)
          extraWidget!
        else
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title?.toUpperCase() ?? '',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    shadows: [
                      const Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),

        // Phần Nút bấm (chỉ hiện khi có hàm callback và label)
        if (onButtonPressed != null && buttonLabel != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: _buildActionButton(),
          ),
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton.icon(
      onPressed: onButtonPressed,
      icon: Icon(buttonIcon, color: Colors.white),
      label: Text(
        buttonLabel!.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }
}
