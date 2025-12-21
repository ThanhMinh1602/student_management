import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/web_modules/question_management/controller/question_management_controller.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreateButton(),

            const SizedBox(height: 40),

            Obx(
              () => Wrap(
                spacing: 30, // Khoảng cách ngang
                runSpacing: 30, // Khoảng cách dọc
                alignment: WrapAlignment.start, // Căn giữa
                children: controller.questionSets.map((item) {
                    return QuestionSetCard(
                    name: item.name,
                    questionCount: item.questionCount,
                    createdAt: item.createdAt,
                    // Các hành động
                    onAssign: () async {
                      // Show Assign dialog here in the view and call controller.createAssignment
                      if (controller.classList.isEmpty) {
                        controller.showWarning("Bạn cần tạo Lớp học trước khi giao bài!");
                        return;
                      }

                      ClassModel? selectedClass;
                      DateTime startDate = DateTime.now();
                      DateTime endDate = DateTime.now().add(const Duration(days: 7));
                      final dateTextCtrl = TextEditingController(
                        text: "${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}",
                      );

                      Get.defaultDialog(
                        title: "GIAO BÀI TẬP",
                        titleStyle: TextStyle(color: controller.primaryColor, fontWeight: FontWeight.w900),
                        radius: 20,
                        contentPadding: const EdgeInsets.all(20),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bộ đề: ${item.name}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<ClassModel>(
                              decoration: InputDecoration(
                                labelText: "Chọn lớp áp dụng",
                                prefixIcon: Icon(Icons.class_, color: controller.primaryColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              items: controller.classList.map((cls) {
                                return DropdownMenuItem(value: cls, child: Text(cls.className, overflow: TextOverflow.ellipsis));
                              }).toList(),
                              onChanged: (val) => selectedClass = val,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: dateTextCtrl,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Thời gian làm bài",
                                prefixIcon: Icon(Icons.date_range, color: controller.primaryColor),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              onTap: () async {
                                final picked = await showDateRangePicker(
                                  context: Get.context!,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                  initialDateRange: DateTimeRange(start: startDate, end: endDate),
                                  builder: (context, child) {
                                    return Theme(data: ThemeData.light().copyWith(primaryColor: controller.actionColor, colorScheme: ColorScheme.light(primary: controller.actionColor)), child: child!);
                                  },
                                );
                                if (picked != null) {
                                  startDate = picked.start;
                                  endDate = picked.end;
                                  dateTextCtrl.text = "${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}";
                                }
                              },
                            ),
                          ],
                        ),
                        confirm: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: controller.actionColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            onPressed: () async {
                              if (selectedClass == null) {
                                controller.showWarning("Vui lòng chọn lớp học");
                                return;
                              }
                              Get.back();
                              await Future.delayed(const Duration(milliseconds: 300));
                              final assignment = AssignmentModel(
                                id: '',
                                questionSetId: item.id,
                                questionSetName: item.name,
                                classId: selectedClass!.id,
                                className: selectedClass!.className,
                                startDate: startDate,
                                endDate: endDate,
                                createdAt: DateTime.now(),
                              );
                              await controller.createAssignment(assignment);
                            },
                            child: const Text("XÁC NHẬN GIAO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        cancel: TextButton(onPressed: () => Get.back(), child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
                      );
                    },
                    onEdit: () async {
                      // Show edit dialog for question set name
                      final nameCtrl = TextEditingController(text: item.name);
                      Get.defaultDialog(
                        title: "ĐỔI TÊN BỘ ĐỀ",
                        titleStyle: TextStyle(color: controller.primaryColor, fontWeight: FontWeight.w900),
                        radius: 20,
                        contentPadding: const EdgeInsets.all(20),
                        content: Column(children: [
                          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Tên bộ đề", prefixIcon: Icon(Icons.quiz, color: controller.primaryColor), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
                        ]),
                        confirm: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: controller.actionColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
                          if (nameCtrl.text.trim().isEmpty) { controller.showWarning("Vui lòng nhập tên bộ đề"); return; }
                          Get.back();
                          await Future.delayed(const Duration(milliseconds: 300));
                          await controller.updateQuestionSet(item.id, nameCtrl.text.trim());
                        }, child: const Text("LƯU THAY ĐỔI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                      );
                    },
                    onDelete: () {
                      AppDialogs.showConfirm(
                        title: "Xóa bộ đề?",
                        titleStyle: TextStyle(color: controller.primaryColor, fontWeight: FontWeight.bold),
                        middleText: "Hành động này sẽ xóa vĩnh viễn bộ câu hỏi này.",
                        textConfirm: "Xóa ngay",
                        textCancel: "Hủy",
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.redAccent,
                        cancelTextColor: Colors.grey,
                        onConfirm: () async {
                          await Future.delayed(const Duration(milliseconds: 300));
                          await controller.deleteSet(item.id);
                        },
                      );
                    },
                    onDetail: () => controller.openDetail(item.id, item.name),
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
        onTap: () {
          // Show create dialog and call controller.createQuestionSet
          final nameCtrl = TextEditingController();
          Get.defaultDialog(
            title: "TẠO BỘ ĐỀ MỚI",
            titleStyle: TextStyle(color: controller.primaryColor, fontWeight: FontWeight.w900),
            radius: 20,
            contentPadding: const EdgeInsets.all(20),
            content: Column(children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Tên bộ đề (VD: HSK 1 - Bài 5)", prefixIcon: Icon(Icons.quiz, color: controller.primaryColor), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey.shade50)),
            ]),
            confirm: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: controller.actionColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) { controller.showWarning("Vui lòng nhập tên bộ đề"); return; }
              Get.back();
              await Future.delayed(const Duration(milliseconds: 300));
              await controller.createQuestionSet(nameCtrl.text.trim());
            }, child: const Text("TẠO MỚI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            cancel: TextButton(onPressed: () => Get.back(), child: const Text("Hủy", style: TextStyle(color: Colors.grey))),
          );
        },
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
