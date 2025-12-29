import 'package:flutter/material.dart';
import 'package:blooket/app/core/constants/app_color.dart'; // Import AppColor của bạn

class BorderedStatWidget extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final Color color;

  const BorderedStatWidget({
    super.key,
    required this.title,
    this.value,
    this.icon = Icons.access_time,
    this.color = AppColor.white, // Mặc định dùng AppColor.white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: color, width: 3.0),
        borderRadius: BorderRadius.circular(
          8.0,
        ), // Thêm bo góc nhẹ cho khung ngoài nếu cần
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Co lại vừa nội dung
        children: [
          // 1. Icon
          Icon(icon, color: color, size: 35),

          const SizedBox(width: 8), // Khoảng cách giữa Icon và Text
          // 2. Title (Time limit)
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.normal,
              height: 1.2, // Giãn dòng cho text nhiều dòng đẹp hơn
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: 12), // Khoảng cách giữa Text và Value
            // 3. Value Box (30s)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: color, width: 3.0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                value!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
