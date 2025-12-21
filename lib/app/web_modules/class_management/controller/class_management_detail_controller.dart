// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart'; // Kế thừa BaseController để có loading/snackbar xịn
import 'package:blooket/app/core/utils/dialogs.dart';
import 'package:blooket/app/data/model/student_model.dart';
import 'package:blooket/app/data/service/student_service.dart';

class ClassManagementDetailController extends BaseController {
  final StudentService _studentService; // Đảm bảo đã put service này ở binding

  // Danh sách học viên TRONG LỚP (Hiển thị ra bảng)
  final studentsInClass = <StudentModel>[].obs;

  // Danh sách TẤT CẢ học viên (Dùng để lọc khi bấm nút thêm)
  final allStudents = <StudentModel>[].obs;

  late String currentClassId;
  ClassManagementDetailController(this._studentService);

  // Màu sắc vibe
  final primaryColor = const Color(0xFF909CC2);
  final accentColor = const Color(0xFFEDBBC6);
  final bgColor = const Color(0xFFDCD6F7);

  @override
  void onInit() {
    super.onInit();
    // Lấy ID lớp được truyền từ màn hình trước
    currentClassId = Get.parameters['id']??'';

    if (currentClassId.isNotEmpty) {
      // 1. Bind stream học viên trong lớp
      studentsInClass.bindStream(
        _studentService.getStudentsByClassStream(currentClassId),
      );

      // 2. Bind stream tất cả học viên (để dành cho dialog chọn)
      allStudents.bindStream(_studentService.getAllStudentsStream());
    }
  }

  // --- HÀNH ĐỘNG ---

  // Lấy danh sách học viên CHƯA vào lớp này (để hiện trong Dialog)
  List<StudentModel> getAvailableStudents() {
    return allStudents.where((s) => s.classId != currentClassId).toList();
  }

  // Thêm học viên vào lớp
  void addStudentToClass(String studentId) async {
    Get.back(); // Đóng dialog chọn
    showLoading();
    bool success = await _studentService.assignStudentToClass(
      studentId,
      currentClassId,
    );
    hideLoading();

    if (success) {
      showSuccess("Đã thêm học viên vào lớp");
    } else {
      showError("Thất bại, vui lòng thử lại");
    }
  }

  // Xóa học viên khỏi lớp
  void removeStudentFromClass(String studentId) async {
    AppDialogs.showConfirm(
      title: "Xóa khỏi lớp?",
      middleText:
          "Học viên sẽ bị xóa khỏi danh sách lớp này (Tài khoản vẫn tồn tại).",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        showLoading();
        bool success = await _studentService.removeStudentFromClass(studentId);
        hideLoading();
        if (success) showSuccess("Đã xóa khỏi lớp");
      },
    );
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
