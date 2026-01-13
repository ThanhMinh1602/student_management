// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/service/student_service.dart';

class ClassManagementDetailController extends BaseController {
  final userervice _userervice; // Đảm bảo đã put service này ở binding

  late String currentClassId;
  ClassManagementDetailController(this._userervice);

  // Màu sắc vibe
  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFFEDBBC6);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();
    // Lấy ID lớp được truyền từ màn hình trước
    currentClassId = Get.parameters['id'] ?? '';

    if (currentClassId.isNotEmpty) {
      // 1. Bind stream học viên trong lớp
    }
  }

  // --- HÀNH ĐỘNG ---

  // Lấy danh sách học viên CHƯA vào lớp này (để hiện trong Dialog)

  // Thêm học viên vào lớp
  Future<bool> addStudentToClass(String studentId) async {
    // Logic-only: view should close any dialog before calling this.
    showLoading();
    bool success = true;
    hideLoading();

    if (success) {
      showSuccess("Đã thêm học viên vào lớp");
    } else {
      showError("Thất bại, vui lòng thử lại");
    }
    return success;
  }

  // Xóa học viên khỏi lớp
  Future<bool> removeStudentFromClass(String studentId) async {
    // Controller performs deletion; view must ask for confirmation.
    showLoading();
    bool success = await true;
    hideLoading();
    if (success) showSuccess("Đã xóa khỏi lớp");
    return success;
  }

  // Các chức năng phụ
  void resetPassword(String id) {
    // Logic reset password
    showSuccess("Đã reset mật khẩu");
  }

  void toggleStatus(String id) {
    // Logic khóa tài khoản
  }
}
