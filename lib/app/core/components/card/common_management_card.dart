import 'package:flutter/material.dart';

class CommonManagementCard extends StatelessWidget {
  // 1. Cấu hình màu sắc & Giao diện
  final Color cardColor; // Màu nền thẻ (Tím hoặc Xanh Mint)
  final Color buttonColor; // Màu nút bấm (Hồng hoặc Trắng)
  final Color buttonTextColor; // Màu chữ trong nút

  // 2. Nội dung
  final Widget titleWidget; // Widget tiêu đề (Text hoặc Column)
  final List<Widget> bodyRows; // Danh sách các dòng thông tin (Icon + Text)

  // 3. Nút hành động chính (Footer)
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPrimaryAction;

  // 4. Các nút thao tác nhỏ (Edit/Delete)
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CommonManagementCard({
    super.key,
    required this.cardColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.titleWidget,
    required this.bodyRows,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPrimaryAction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 230, // Chiều cao cố định chuẩn
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- HEADER: Tiêu đề + Edit/Delete ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: titleWidget), // Tiêu đề linh hoạt
                Column(
                  children: [
                    _buildSmallIconButton(Icons.edit, onEdit),
                    const SizedBox(height: 8),
                    _buildSmallIconButton(Icons.delete, onDelete),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // --- BODY: Các dòng thông tin ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: bodyRows
                  .map(
                    (row) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: row,
                    ),
                  )
                  .toList(),
            ),
          ),

          const Spacer(),

          // --- FOOTER: Nút hành động chính ---
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: onPrimaryAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(buttonIcon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget con: Nút nhỏ (Edit/Delete)
  Widget _buildSmallIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  // Static Helper: Giúp tạo dòng thông tin (Icon + Text) nhanh chóng từ bên ngoài
  static Widget buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
