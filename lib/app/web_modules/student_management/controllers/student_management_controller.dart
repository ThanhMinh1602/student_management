// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/student_model.dart';
import 'package:blooket/app/data/service/student_service.dart';

class StudentManagementController extends BaseController {
  final StudentService _studentService;
  StudentManagementController(this._studentService);
  final studentList = <StudentModel>[].obs;
  String selectedRole = 'student';

  @override
  void onInit() {
    super.onInit();
    // Load toàn bộ danh sách ngay khi vào màn hình
    studentList.bindStream(_studentService.getAllStudentsStream());
  }

  // --- ACTIONS ---

  void showAddStudentDialog() {
    final nameCtrl = TextEditingController();
    final userCtrl = TextEditingController();
    
    // Reset role về mặc định mỗi khi mở dialog
    selectedRole = 'student'; 

    Get.defaultDialog(
      title: "CẤP TÀI KHOẢN MỚI",
      titleStyle: const TextStyle(
        color: Color(0xFF909CC2),
        fontWeight: FontWeight.w900,
      ),
      radius: 20,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          _buildTextField(nameCtrl, "Họ và tên", Icons.person),
          const SizedBox(height: 16),
          _buildTextField(userCtrl, "Username", Icons.alternate_email),
          const SizedBox(height: 16),
          
          // 🔥 THÊM DROPDOWN CHỌN QUYỀN (ROLE)
          DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: InputDecoration(
              labelText: "Vai trò",
              prefixIcon: const Icon(Icons.security, color: Color(0xFF909CC2)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: const [
              DropdownMenuItem(value: 'student', child: Text("Học viên")),
              DropdownMenuItem(value: 'admin', child: Text("Quản trị viên")),
            ],
            onChanged: (val) {
              if (val != null) selectedRole = val;
            },
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Mật khẩu mặc định: 123456",
                    style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF88D8B0),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            if (nameCtrl.text.isEmpty || userCtrl.text.isEmpty) {
              showWarning("Vui lòng nhập đầy đủ thông tin");
              return;
            }

            Get.back();
            await Future.delayed(const Duration(milliseconds: 300));

            showLoading();

            bool success = await _studentService.addStudent(
              fullName: nameCtrl.text,
              username: userCtrl.text,
              role: selectedRole, // 🔥 Truyền Role đã chọn
              password: '123456', // 🔥 Truyền Password mặc định
            );

            hideLoading();

            if (success) {
              showSuccess("Đã cấp tài khoản thành công");
            } else {
              showError("Thất bại. Username đã tồn tại.");
            }
          },
          child: const Text("TẠO TÀI KHOẢN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  void toggleStatus(StudentModel student) async {
    showLoading();
    bool success = await _studentService.toggleStatus(
      student.id,
      student.isActive,
    );
    hideLoading();

    if (success) {
      showSuccess(
        student.isActive ? "Đã khóa tài khoản" : "Đã mở khóa tài khoản",
      );
    }
  }

  void resetPassword(String id) {
    Get.defaultDialog(
      title: "Reset Mật khẩu?",
      middleText: "Mật khẩu sẽ quay về: 123456",
      textConfirm: "Đồng ý",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.orange,
      onConfirm: () async {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 300));

        showLoading();
        bool success = await _studentService.resetPassword(id);
        hideLoading();

        if (success) showSuccess("Đã reset mật khẩu thành công");
      },
    );
  }

  void deleteStudent(String id) {
    Get.defaultDialog(
      title: "Xóa tài khoản?",
      middleText: "Hành động này không thể hoàn tác.",
      textConfirm: "Xóa vĩnh viễn",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 300));

        showLoading();
        bool success = await _studentService.deleteStudent(id);
        hideLoading();

        if (success) showSuccess("Đã xóa tài khoản");
      },
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF909CC2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
