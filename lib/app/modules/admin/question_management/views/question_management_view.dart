import 'package:blooket/app/core/components/appbar/app_header.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/components/button/custom_action_button.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/components/sidebar/side_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_management_controller.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/core/utils/ui_dialogs.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_set_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionManagementView extends GetView<QuestionManagementController> {
  const QuestionManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD6F7),
      appBar: AppHeader(),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SideBarWidget(currentItem: SideBarItem.question),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomPageHeader(
                    title: 'Tài liệu của tôi',
                    subtitle: 'Danh sách bộ đề câu hỏi hiện có',
                    buttonLabel: 'Tạo bộ đề mới',
                    onButtonPressed: () async {
                      final name = await UiDialogs.showQuestionSetName(
                        title: 'TẠO BỘ ĐỀ MỚI',
                      );
                      if (name != null) {
                        await Future.delayed(const Duration(milliseconds: 300));
                        await controller.createQuestionSet(name);
                      }
                    },
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: Obx(() {
                      if (controller.questionSets.isEmpty) {
                        return const Center(child: Text("Chưa có bộ đề nào"));
                      }

                      return GridView.builder(
                        itemCount: controller.questionSets.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 350,
                              childAspectRatio: 3 / 2.2,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                        itemBuilder: (context, index) {
                          final item = controller.questionSets[index];
                          return QuestionSetCard(
                            name: item.name,
                            questionCount: item.questionCount,
                            createdAt: item.createdAt,

                            onAssign: () async {
                              if (controller.classList.isEmpty) {
                                controller.showWarning(
                                  "Bạn cần tạo Lớp học trước khi giao bài!",
                                );
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
                              controller.openDetail(item.id, item.name);
                            },
                            onDelete: () {
                              AppDialogs.showConfirm(
                                title: "Xóa bộ đề?",
                                titleStyle: TextStyle(
                                  color: controller.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                middleText:
                                    "Hành động này sẽ xóa vĩnh viễn bộ câu hỏi này.",
                                textConfirm: "Xóa ngay",
                                textCancel: "Hủy",
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.redAccent,
                                cancelTextColor: Colors.grey,
                                onConfirm: () async {
                                  await Future.delayed(
                                    const Duration(milliseconds: 300),
                                  );
                                  await controller.deleteSet(item.id);
                                },
                              );
                            },
                            onDetail: () =>
                                controller.openDetail(item.id, item.name),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
