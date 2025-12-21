import 'package:blooket/app/data/model/student_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// --- CONTROLLER ---
class ClassManagementDetailController extends GetxController {
  // Dữ liệu Observable
  var students = <StudentModel>[].obs;

  // Màu sắc theo vibe của bạn (để dùng chung)
  final primaryColor = const Color(0xFF909CC2); // Xanh tím
  final accentColor = const Color(0xFFEDBBC6); // Hồng
  final bgColor = const Color(0xFFDCD6F7); // Nền tím nhạt

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  void loadStudents() {}

  // Chức năng: Thêm học viên
  void addStudent(String name, String username) {}

  // Chức năng: Reset Password
  void resetPassword(String id) {
    Get.snackbar(
      'Reset Password',
      'Đã đặt lại mật khẩu về 123456',
      backgroundColor: Colors.white,
      colorText: Colors.orange,
    );
  }

  // Chức năng: Khóa/Mở khóa
  void toggleStatus(String id) {
    var index = students.indexWhere((s) => s.id == id);
    if (index != -1) {
      var student = students[index];
      // student.isActive = !student.isActive;
      students[index] = student; // Trigger update UI

      Get.snackbar(
        'Cập nhật',
        student.isActive ? 'Đã mở khóa tài khoản' : 'Đã khóa tài khoản',
        backgroundColor: Colors.white,
        colorText: student.isActive ? Colors.green : Colors.red,
      );
    }
  }
}
