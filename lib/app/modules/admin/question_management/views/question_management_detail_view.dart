import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_management_detail_controller.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/question_dialog.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/model/question_model.dart';

class QuestionManagementDetailView extends GetView<QuestionManagementDetailController> {
  const QuestionManagementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: controller.bgColor,
      appBar: const CustomAppBar(title: 'Chi Tiết Bộ Đề'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'BỘ ĐỀ: ${controller.setName.toUpperCase()}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      shadows: [
                        const Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black12),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildAddButton(),
              ],
            ),
            const SizedBox(height: 30),

            // Danh sách câu hỏi
            Obx(() {
               if (controller.questions.isEmpty) {
                 return _buildEmptyState();
               }
               return ListView.separated(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: controller.questions.length,
                 separatorBuilder: (_, __) => const SizedBox(height: 16),
                 itemBuilder: (ctx, index) {
                   final q = controller.questions[index];
                   return _buildQuestionCard(q, index + 1);
                 },
               );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.quiz_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text("Chưa có câu hỏi nào. Hãy thêm mới!", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Get.dialog(
          QuestionDialog(
            setId: controller.setId,
            onSave: (newQuestion) async {
              Get.back();
              await Future.delayed(const Duration(milliseconds: 300));
              await controller.addQuestion(newQuestion);
            },
          ),
          barrierDismissible: false,
        );
      },
      icon: const Icon(Icons.add_circle, color: Colors.white),
      label: const Text('THÊM CÂU HỎI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel q, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4), blurRadius: 8),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STT
          Container(
            width: 40, height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: controller.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text("$index", style: TextStyle(color: controller.primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 16),
          
          // Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loại câu hỏi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(_getTypeName(q.type), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                const SizedBox(height: 8),
                
                // Content
                Text(q.content, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                
                // Đáp án
                Text("Đáp án đúng: ${q.correctAnswer}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                if (q.type == QuestionType.multipleChoice)
                   Padding(
                     padding: const EdgeInsets.only(top: 4.0),
                     child: Text("Lựa chọn: ${q.options?.join(' | ')}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                   ),
              ],
            ),
          ),

          // Hành động
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                tooltip: "Sửa",
                onPressed: () {
                  Get.dialog(
                    QuestionDialog(
                      setId: controller.setId,
                      initialData: q,
                      onSave: (updatedQuestion) async {
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 300));
                        await controller.updateQuestion(updatedQuestion);
                      },
                    ),
                    barrierDismissible: false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: "Xóa",
                onPressed: () {
                  AppDialogs.showConfirm(
                    title: "Xóa câu hỏi?",
                    titleStyle: TextStyle(color: controller.primaryColor, fontWeight: FontWeight.bold),
                    middleText: "Hành động này không thể hoàn tác.",
                    textConfirm: "Xóa",
                    textCancel: "Hủy",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.redAccent,
                    onConfirm: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      await controller.deleteQuestion(q.id);
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String _getTypeName(QuestionType type) {
    if (type == QuestionType.multipleChoice) return "TRẮC NGHIỆM";
    if (type == QuestionType.rearrange) return "SẮP XẾP CÂU";
    if (type == QuestionType.translate) return "DỊCH CÂU";
    return "";
  }
}