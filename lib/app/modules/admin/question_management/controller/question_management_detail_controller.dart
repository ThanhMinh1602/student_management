import 'package:blooket/app/core/base/base_controller.dart';
// Dialogs and QuestionDialog widget belong in Views; controller only exposes logic.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/data/model/question_model.dart'; // Chứa Enum QuestionType
import 'package:blooket/app/data/service/question_service.dart';

class QuestionManagementDetailController extends BaseController {
  final QuestionService _service = Get.find();

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
      // questions.bindStream(_service.getQuestionsStream(setId));
    }
  }

  // --- CRUD ACTION ---
  // --- DELETE QUESTION ---
  Future<bool> deleteQuestion(String questionId) async {
    showLoading();
    bool success = true;
    hideLoading();
    if (success) showSuccess("Đã xóa câu hỏi");
    return success;
  }

  // --- OPEN ADD DIALOG ---
  // Views should open QuestionDialog and call these logic methods.
  Future<bool> addQuestion(QuestionModel newQuestion) async {
    showLoading();
    bool success = true;
    hideLoading();
    if (success) showSuccess("Thêm câu hỏi thành công");
    return success;
  }

  Future<bool> updateQuestion(QuestionModel updatedQuestion) async {
    showLoading();
    bool success = true;
    hideLoading();
    if (success) showSuccess("Cập nhật câu hỏi thành công");
    return success;
  }
}
