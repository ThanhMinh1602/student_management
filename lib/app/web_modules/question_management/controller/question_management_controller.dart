// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blooket/app/data/service/class_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/model/question_set_model.dart';
import 'package:blooket/app/data/service/question_service.dart';

class QuestionManagementController extends BaseController {
  final QuestionService _questionService; // Hoặc Get.find() nếu đã binding
  final ClassService _classService;
  QuestionManagementController(this._questionService, this._classService);
  final questionSets = <QuestionSetModel>[].obs;
  final classList = <ClassModel>[].obs;

  // Màu sắc chủ đạo của Module này
  final primaryColor = const Color(0xFF909CC2);
  final actionColor = const Color(0xFFEDBBC6); // Màu hồng

  @override
  void onInit() {
    super.onInit();
    questionSets.bindStream(_questionService.getQuestionSetsStream());
    classList.bindStream(_classService.getClassesStream());
  }

  // --- CÁC HÀM GỌI TỪ VIEW ---

  // Views handle UI interactions; controller exposes logic APIs below.
  Future<bool> deleteSet(String id) async {
    showLoading();
    bool success = await _questionService.deleteQuestionSet(id);
    hideLoading();

    if (success) {
      showSuccess("Đã xóa bộ đề");
    } else {
      showError("Lỗi khi xóa bộ đề");
    }
    return success;
  }
  void openDetail(String id, String name) {
    Get.toNamed(
      '${Get.currentRoute}/$id?name=$name',
    );
  }
  // UI moved to View; logic methods (createQuestionSet, updateQuestionSet, deleteSet,
  // createAssignment) are used by views when user confirms an action.

  // --- Logic-only helpers (called by Views) ---
  Future<bool> createQuestionSet(String name) async {
    showLoading();
    bool success = await _questionService.createQuestionSet(name.trim());
    hideLoading();
    if (success) {
      showSuccess("Đã tạo bộ đề mới");
    } else {
      showError("Có lỗi xảy ra, vui lòng thử lại");
    }
    return success;
  }

  Future<bool> updateQuestionSet(String id, String name) async {
    showLoading();
    bool success = await _questionService.updateQuestionSet(id, name.trim());
    hideLoading();
    if (success) {
      showSuccess("Đã cập nhật tên bộ đề");
    } else {
      showError("Có lỗi xảy ra, vui lòng thử lại");
    }
    return success;
  }

  Future<bool> createAssignment(AssignmentModel assignment) async {
    showLoading();
    bool success = await _questionService.createAssignment(assignment);
    hideLoading();
    if (success) {
      showSuccess("Đã giao bài thành công cho lớp ${assignment.className}");
    } else {
      showError("Lỗi hệ thống, vui lòng thử lại");
    }
    return success;
  }
}
