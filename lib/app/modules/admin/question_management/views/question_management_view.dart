import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_management_controller.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/core/utils/ui_dialogs.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_set_card.dart'; // Nhớ import file widget mới
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
                      if (controller.classList.isEmpty) {
                        controller.showWarning("Bạn cần tạo Lớp học trước khi giao bài!");
                        return;
                      }
                      final r = await UiDialogs.showAssignDialog(
                        classes: controller.classList,
                        actionColor: controller.actionColor,
                        title: 'GIAO BÀI TẬP',
                        questionSetName: item.name,
                      );
                      if (r != null) {
                        final cls = r['class'];
                        final start = r['start'] as DateTime;
                        final end = r['end'] as DateTime;
                        final assignment = AssignmentModel(
                          id: '',
                          questionSetId: item.id,
                          questionSetName: item.name,
                          classId: cls.id,
                          className: cls.className,
                          startDate: start,
                          endDate: end,
                          createdAt: DateTime.now(),
                        );
                        await controller.createAssignment(assignment);
                      }
                    },
                    onEdit: () async {
                      final name = await UiDialogs.showQuestionSetName(title: 'ĐỔI TÊN BỘ ĐỀ', initial: item.name);
                      if (name != null) {
                        await Future.delayed(const Duration(milliseconds: 300));
                        await controller.updateQuestionSet(item.id, name);
                      }
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
        onTap: () async {
          final name = await UiDialogs.showQuestionSetName(title: 'TẠO BỘ ĐỀ MỚI');
          if (name != null) {
            await Future.delayed(const Duration(milliseconds: 300));
            await controller.createQuestionSet(name);
          }
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
