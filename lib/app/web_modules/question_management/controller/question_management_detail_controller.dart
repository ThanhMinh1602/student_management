import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/web_modules/question_management/widgets/question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/data/model/question_model.dart'; // Chứa Enum QuestionType
import 'package:blooket/app/data/service/question_service.dart';

class QuestionManagementDetailController extends BaseController {
  final QuestionService _service = QuestionService(); // Hoặc Get.find()
  
  final questions = <QuestionModel>[].obs;
  
  // ID và Tên bộ đề (lấy từ tham số truyền vào)
  late String setId;
  late String setName;

  // Màu sắc
  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFF88D8B0); // Xanh Mint
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();
    // Lấy tham số từ URL hoặc Arguments
    // Ví dụ URL: /question-detail/:id?name=BoDe1
    setId = Get.parameters['id'] ?? '';
    setName = Get.parameters['name'] ?? 'Chi tiết bộ đề'; 

    if (setId.isNotEmpty) {
      questions.bindStream(_service.getQuestionsStream(setId));
    }
  }

  // --- CRUD ACTION ---
// --- DELETE QUESTION ---
  void deleteQuestion(String questionId) {
    AppDialogs.showConfirm(
      title: "Xóa câu hỏi?",
      titleStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      middleText: "Hành động này không thể hoàn tác.",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        showLoading();
        bool success = await _service.deleteQuestion(questionId, setId);
        hideLoading();
        if (success) showSuccess("Đã xóa câu hỏi");
      },
    );
  }

  // --- OPEN ADD DIALOG ---
  void openAddQuestionDialog() {
    Get.dialog(
      QuestionDialog(
        setId: setId,
        onSave: (newQuestion) async {
          Get.back();
          showLoading();
          bool success = await _service.addQuestion(newQuestion);
          hideLoading();
          if (success) showSuccess("Thêm câu hỏi thành công");
        },
      ),
      barrierDismissible: false,
    );
  }

  // --- OPEN EDIT DIALOG ---
  void openEditQuestionDialog(QuestionModel existingQuestion) {
    Get.dialog(
      QuestionDialog(
        setId: setId,
        initialData: existingQuestion, // Truyền dữ liệu cũ vào để sửa
        onSave: (updatedQuestion) async {
          Get.back();
          showLoading();
          bool success = await _service.updateQuestion(updatedQuestion);
          hideLoading();
          if (success) showSuccess("Cập nhật câu hỏi thành công");
        },
      ),
      barrierDismissible: false,
    );
  }
}