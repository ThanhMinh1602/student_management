import 'package:blooket/app/web_modules/class_management/controller/class_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/class_card.dart'; // Import thẻ lớp mới
import 'package:blooket/app/core/utils/dialogs.dart';
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
                alignment: WrapAlignment.start,
                children: controller.classList.map((item) {
                 return StreamBuilder<int>(
                    stream: controller.getClassStudentCount(item.id), // Gọi hàm đếm
                    initialData: 0, // Giá trị mặc định khi đang tải
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return ClassCard(
                        className: item.className,
                        subject: item.subject,
                        schedule: item.schedule,
                        studentCount: count, 
                        onEnterClass: () => controller.enterClass(item.id),
                        onEdit: () {
                          // Show edit dialog and call controller.updateClass
                          final nameCtrl = TextEditingController(text: item.className);
                          final subjectCtrl = TextEditingController(text: item.subject);
                          final scheduleCtrl = TextEditingController(text: item.schedule);

                          Get.defaultDialog(
                            title: "CHỈNH SỬA LỚP",
                            titleStyle: const TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900),
                            contentPadding: const EdgeInsets.all(20),
                            radius: 20,
                            content: Column(children: [
                              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Tên lớp (VD: Tiếng Trung K15)', prefixIcon: const Icon(Icons.class_, color: Color(0xFF909CC2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
                              const SizedBox(height: 16),
                              TextField(controller: subjectCtrl, decoration: InputDecoration(labelText: 'Môn học (VD: HSK 3)', prefixIcon: const Icon(Icons.book, color: Color(0xFF909CC2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
                              const SizedBox(height: 16),
                              TextField(controller: scheduleCtrl, decoration: InputDecoration(labelText: 'Lịch học (VD: 2-4-6 19:30)', prefixIcon: const Icon(Icons.access_time, color: Color(0xFF909CC2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
                            ]),
                            confirm: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF88D8B0), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
                              if (nameCtrl.text.isEmpty) { controller.showWarning("Vui lòng nhập tên lớp học"); return; }
                              Get.back();
                              await Future.delayed(const Duration(milliseconds: 300));
                              await controller.updateClass(id: item.id, className: nameCtrl.text.trim(), subject: subjectCtrl.text.trim(), schedule: scheduleCtrl.text.trim());
                            }, child: const Text('LƯU THAY ĐỔI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                            cancel: TextButton(onPressed: () => Get.back(), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
                          );
                        },
                        onDelete: () {
                          AppDialogs.showConfirm(
                            title: "Xác nhận xóa",
                            titleStyle: const TextStyle(
                              color: Color(0xFF909CC2),
                              fontWeight: FontWeight.bold,
                            ),
                            middleText: "Bạn có chắc muốn xóa lớp học này không?\nDữ liệu không thể khôi phục.",
                            textConfirm: "Xóa ngay",
                            textCancel: "Hủy",
                            confirmTextColor: Colors.white,
                            buttonColor: Colors.redAccent,
                            cancelTextColor: Colors.grey,
                            onConfirm: () async {
                              // Wait a bit to ensure dialog has closed before showing loading
                              await Future.delayed(const Duration(milliseconds: 300));
                              await controller.deleteClass(item.id);
                            },
                          );
                        },
                      );
                    },
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
        onTap: () {
          final nameCtrl = TextEditingController();
          final subjectCtrl = TextEditingController();
          final scheduleCtrl = TextEditingController();

          Get.defaultDialog(
            title: "THÊM LỚP MỚI",
            titleStyle: const TextStyle(color: Color(0xFF909CC2), fontWeight: FontWeight.w900),
            contentPadding: const EdgeInsets.all(20),
            radius: 20,
            content: Column(children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Tên lớp (VD: Tiếng Trung K15)', prefixIcon: const Icon(Icons.class_, color: Color(0xFF909CC2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
              const SizedBox(height: 16),
              TextField(controller: subjectCtrl, decoration: InputDecoration(labelText: 'Môn học (VD: HSK 3)', prefixIcon: const Icon(Icons.book, color: Color(0xFF909CC2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
              const SizedBox(height: 16),
              TextField(controller: scheduleCtrl, decoration: InputDecoration(labelText: 'Lịch học (VD: 2-4-6 19:30)', prefixIcon: const Icon(Icons.access_time, color: Color(0xFF909CC2)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
            ]),
            confirm: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF88D8B0), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
              if (nameCtrl.text.isEmpty) { controller.showWarning("Vui lòng nhập tên lớp học"); return; }
              Get.back();
              await Future.delayed(const Duration(milliseconds: 300));
              await controller.createClass(className: nameCtrl.text.trim(), subject: subjectCtrl.text.trim(), schedule: scheduleCtrl.text.trim());
            }, child: const Text('TẠO LỚP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            cancel: TextButton(onPressed: () => Get.back(), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          );
        },
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
