import 'package:blooket/app/core/components/button/custom_icon_button.dart';
import 'package:flutter/material.dart';

class UpDownControls extends StatelessWidget {
  // Các hàm callback để xử lý logic khi bấm nút
  final VoidCallback? onUp;
  final VoidCallback? onDown;

  // Tùy chỉnh màu sắc hoặc kích thước nếu cần
  final Color iconColor;
  final double iconSize;

  const UpDownControls({
    super.key,
    required this.onUp,
    required this.onDown,
    this.iconColor = Colors.black,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // Lưu ý: Thuộc tính 'spacing' yêu cầu Flutter phiên bản mới (3.27+).
      // Nếu lỗi, hãy dùng SizedBox(height: 8) giữa các children.
      spacing: 8,
      mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian vừa đủ
      children: [
        CustomIconButton(onTap: onUp, icon: Icons.arrow_drop_up_outlined),
        CustomIconButton(onTap: onDown, icon: Icons.arrow_drop_down_outlined),
      ],
    );
  }
}
