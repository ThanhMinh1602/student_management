import 'package:blooket/app/web_modules/class_management/controller/class_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/class_card.dart'; // Import thẻ lớp mới
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';

class ClassManagementView extends GetView<ClassManagementController> {
  const ClassManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFDCD6F7,
      ), // Giữ nguyên màu nền tím nhạt để đồng bộ
      appBar: const CustomAppBar(title: 'Quản Lý Lớp Học'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            // 1. Tiêu đề lớn
            Text(
              'DANH SÁCH LỚP HỌC',
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

            // 2. Nút Tạo Lớp Mới (Style giống nút tạo bộ đề)
            _buildCreateButton(),

            const SizedBox(height: 40),

            // 3. Grid Danh sách lớp
            Obx(
              () => Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: controller.classList.map((item) {
                  return ClassCard(
                    className: item.className,
                    subject: item.subject,
                    schedule: item.schedule,
                    studentCount: item.studentCount,
                    onEnterClass: () => controller.enterClass(item.id),
                    onEdit: () => controller.editClass(item.id),
                    onDelete: () => controller.deleteClass(item.id),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: controller.createClass,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 220, // To hơn xíu để chứa chữ dài hơn
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF88D8B0), // Màu xanh Mint đồng bộ với thẻ
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
              Icon(Icons.add_home_work_rounded, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'THÊM LỚP MỚI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
