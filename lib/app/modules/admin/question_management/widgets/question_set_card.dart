import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần import để format ngày

class QuestionSetCard extends StatelessWidget {
  final String name;
  final int questionCount;
  final DateTime createdAt;
  final VoidCallback onAssign; // Hành động Giao bài
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onDetail;

  const QuestionSetCard({
    super.key,
    required this.name,
    required this.questionCount,
    required this.createdAt,
    required this.onAssign,
    required this.onDelete,
    required this.onEdit,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    // Format ngày: 12/05/2024
    final dateStr = DateFormat('dd/MM/yyyy').format(createdAt);

    return GestureDetector(
      onTap: onDetail,
      child: Container(
        width: 280, // Tăng chiều rộng để thoải mái hiển thị
        height: 220, // Tăng chiều cao để chứa nút Giao bài
        decoration: BoxDecoration(
          color: const Color(0xFF909CC2), // Màu nền xanh tím cũ
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
            // 1. Header: Tên + Edit/Delete nhỏ
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  // Menu nhỏ góc phải
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                        onPressed: onEdit,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white70, size: 20),
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  )
                ],
              ),
            ),
      
            const Spacer(),
      
            // 2. Body: Thông tin số câu & ngày tạo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoRow(Icons.quiz, '$questionCount câu hỏi'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.calendar_month, 'Tạo ngày: $dateStr'),
                ],
              ),
            ),
      
            const Spacer(),
      
            // 3. Footer: Nút GIAO BÀI (Quan trọng)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: onAssign,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEDBBC6), // Màu hồng nổi bật
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'GIAO BÀI',
                      style: TextStyle(
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}