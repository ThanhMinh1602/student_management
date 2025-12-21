import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color; // Màu định danh (Xanh, đỏ...) giữ nguyên để phân biệt

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy theme ra biến cho gọn
    final theme = Theme.of(context);

    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Lấy màu nền thẻ từ Theme
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1), // Lấy màu bóng từ Theme
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  // Dùng headlineSmall thay vì fontSize: 20
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    // Màu chữ tự động theo theme (đen/trắng)
                  ),
                ),
                Text(
                  label,
                  // Dùng bodySmall thay vì fontSize: 12
                  style: theme.textTheme.bodySmall?.copyWith(
                    // Lấy màu phụ (thường là màu xám)
                    color: theme.hintColor, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}