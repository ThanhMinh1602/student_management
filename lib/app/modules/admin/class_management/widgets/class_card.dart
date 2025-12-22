import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final String subject;
  final String schedule;
  final int studentCount;
  final VoidCallback onEnterClass; // Hành động nút to (Vào lớp)
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ClassCard({
    super.key,
    required this.className,
    required this.subject,
    required this.schedule,
    required this.studentCount,
    required this.onEnterClass,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF909CC2), // ĐỔI: Màu xanh tím giống QuestionSetCard
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
          // 1. Header: Tên Lớp + Sửa/Xóa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        className,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        subject,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu thao tác nhỏ (Đổi sang IconButton thường cho giống mẫu)
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 12), // Tăng khoảng cách vì không còn khung tròn
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

          // 2. Body: Thông tin (Lịch học, Số học viên)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildInfoRow(Icons.access_time_filled, schedule),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.groups, '$studentCount học viên'),
              ],
            ),
          ),

          const Spacer(),

          // 3. Footer: Nút VÀO LỚP
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: onEnterClass,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDBBC6), // ĐỔI: Màu hồng giống QuestionSetCard
                foregroundColor: Colors.white, // ĐỔI: Chữ trắng
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'XEM LỚP',
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18), // ĐỔI: Màu icon nhạt hơn (white70)
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}