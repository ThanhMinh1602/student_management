// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
// UI/dialogs are shown by Views; controller exposes logic-only actions.
import 'package:blooket/app/data/model/old_model/student_model.dart';
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

  // Views handle the dialog UI; controller provides addStudent logic-only method.
  Future<bool> addStudent({
    required String fullName,
    required String username,
    required String role,
    String password = '123456',
  }) async {
    showLoading();
    bool success = await _studentService.addStudent(
      fullName: fullName,
      username: username,
      role: role,
      password: password,
    );
    hideLoading();
    if (success) {
      showSuccess("Đã cấp tài khoản thành công");
    } else {
      showError("Thất bại. Username đã tồn tại.");
    }
    return success;
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

  Future<bool> resetPassword(String id) async {
    // View should confirm action before calling this.
    await Future.delayed(const Duration(milliseconds: 300));
    showLoading();
    bool success = await _studentService.resetPassword(id);
    hideLoading();
    if (success) showSuccess("Đã reset mật khẩu thành công");
    return success;
  }

  Future<bool> deleteStudent(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    showLoading();
    bool success = await _studentService.deleteStudent(id);
    hideLoading();
    if (success) showSuccess("Đã xóa tài khoản");
    return success;
  }

  // UI helper removed from controller; views should provide input widgets.
}
