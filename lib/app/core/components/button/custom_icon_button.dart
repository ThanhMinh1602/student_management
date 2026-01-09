import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double iconSize;
  final double borderRadius;
  final String? label;

  const CustomIconButton({
    super.key,
    this.onTap,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = 20.0,
    this.borderRadius = 8.0,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Định nghĩa Style chung để tránh viết lặp lại
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.grey[200],
      elevation: 0, // Thường nút kiểu này sẽ phẳng (flat), bỏ bóng đổ
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      // Mẹo nhỏ: Nếu chỉ có icon, ta nên fix padding để nút vuông vắn hơn
      padding: label == null ? const EdgeInsets.all(12) : null,
    );

    // 2. Màu sắc chung
    final finalIconColor = iconColor ?? Colors.black87;

    // 3. Logic hiển thị
    if (label != null && label!.isNotEmpty) {
      // TRƯỜNG HỢP CÓ LABEL -> Dùng .icon
      return ElevatedButton.icon(
        style: buttonStyle,
        onPressed: onTap,
        icon: Icon(icon, size: iconSize, color: finalIconColor),
        label: Text(
          label!,
          style: TextStyle(color: finalIconColor, fontWeight: FontWeight.w500),
        ),
      );
    } else {
      return ElevatedButton(
        style: buttonStyle,
        onPressed: onTap,
        child: Icon(icon, size: iconSize, color: finalIconColor),
      );
    }
  }
}
