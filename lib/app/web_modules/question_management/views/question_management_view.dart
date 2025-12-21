import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/web_modules/question_management/controller/question_management_controller.dart';
import 'package:blooket/app/web_modules/question_management/widgets/question_set_card.dart'; // Nhớ import file widget mới
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionManagementView extends GetView<QuestionManagementController> {
  const QuestionManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD6F7), // Màu nền tím nhạt
      appBar: const CustomAppBar(title: 'Quản Lý Câu Hỏi'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            // 1. Tiêu đề lớn
            Text(
              'TÀI LIỆU CỦA TÔI',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 40,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 2. Nút Tạo Mới (Create)
            _buildCreateButton(),

            const SizedBox(height: 40),

            // 3. Grid Danh sách bộ đề
            Obx(
              () => Wrap(
                spacing: 30, // Khoảng cách ngang
                runSpacing: 30, // Khoảng cách dọc
                alignment: WrapAlignment.center, // Căn giữa
                children: controller.questionSets.map((item) {
                  return QuestionSetCard(
                    name: item.name,
                    questionCount: item.questionCount,
                    createdAt: item.createdAt,
                    onAssign: () => controller.assignTask(item.id),
                    onEdit: () => controller.editSet(item.id),
                    onDelete: () => controller.deleteSet(item.id),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tách nút Create ra widget riêng cho code gọn
  Widget _buildCreateButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.createSet,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 200, // To hơn một chút
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFEDBBC6),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'TẠO MỚI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}