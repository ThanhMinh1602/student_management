// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blooket/app/data/service/student_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/class_model.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/routes/app_routes.dart';

class ClassManagementController extends BaseController {
  // Dependency Injection thông qua constructor hoặc Get.find() đều được
  // Ở đây mình khởi tạo trực tiếp cho đơn giản, hoặc bạn có thể inject qua Binding
  final ClassService _classService;
  final StudentService _studentService;
  ClassManagementController(this._classService, this._studentService);

  final classList = <ClassModel>[].obs;
  
  

  @override
  void onInit() {
    super.onInit();
    // Tự động lắng nghe dữ liệu
    classList.bindStream(_classService.getClassesStream());
  }

  // --- NAVIGATION ---
  void enterClass(String id) {
    Get.toNamed(
      '${Get.currentRoute}/$id'
    );
  }

  // --- MỞ DIALOG ---
  void createClass() => _showFormDialog();

  void editClass(String id) {
    final existingClass = classList.firstWhere((element) => element.id == id);
    _showFormDialog(classModel: existingClass);
  }
Stream<int> getClassStudentCount(String classId) {
    return _studentService.getStudentCountByClassStream(classId);
  }
  // --- XÓA LỚP ---
  void deleteClass(String id) {
    Get.defaultDialog(
      title: "Xác nhận xóa",
      titleStyle: const TextStyle(
        color: Color(0xFF909CC2),
        fontWeight: FontWeight.bold,
      ),
      middleText:
          "Bạn có chắc muốn xóa lớp học này không?\nDữ liệu không thể khôi phục.",
      textConfirm: "Xóa ngay",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.grey,
      onConfirm: () async {
        Get.back(); // 1. Đóng Dialog trước

        // 🔥 FIX: Đợi 300ms để Dialog đóng hẳn rồi mới hiện loading
        await Future.delayed(const Duration(milliseconds: 300));

        showLoading(); // 2. Hiện loading
        bool success = await _classService.deleteClass(id);
        hideLoading(); // 3. Tắt loading

        if (success) {
          showSuccess("Đã xóa lớp học thành công");
        } else {
          showError("Không thể xóa lớp học, vui lòng thử lại");
        }
      },
    );
  }

  // --- FORM NHẬP LIỆU ---
  void _showFormDialog({ClassModel? classModel}) {
    final bool isEditing = classModel != null;
    final nameCtrl = TextEditingController(
      text: isEditing ? classModel.className : '',
    );
    final subjectCtrl = TextEditingController(
      text: isEditing ? classModel.subject : '',
    );
    final scheduleCtrl = TextEditingController(
      text: isEditing ? classModel.schedule : '',
    );

    Get.defaultDialog(
      title: isEditing ? "CHỈNH SỬA LỚP" : "THÊM LỚP MỚI",
      titleStyle: const TextStyle(
        color: Color(0xFF909CC2),
        fontWeight: FontWeight.w900,
      ),
      contentPadding: const EdgeInsets.all(20),
      radius: 20,
      content: Column(
        children: [
          _buildTextField(
            nameCtrl,
            'Tên lớp (VD: Tiếng Trung K15)',
            Icons.class_,
          ),
          const SizedBox(height: 16),
          _buildTextField(subjectCtrl, 'Môn học (VD: HSK 3)', Icons.book),
          const SizedBox(height: 16),
          _buildTextField(
            scheduleCtrl,
            'Lịch học (VD: 2-4-6 19:30)',
            Icons.access_time,
          ),
        ],
      ),
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF88D8B0), // Màu xanh Mint
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            if (nameCtrl.text.isEmpty) {
              showWarning("Vui lòng nhập tên lớp học");
              return;
            }

            Get.back(); // 1. Đóng Dialog Form

            // 🔥 FIX: Đợi 300ms
            await Future.delayed(const Duration(milliseconds: 300));

            showLoading(); // 2. Hiện loading

            bool success = false;
            if (isEditing) {
              success = await _classService.updateClass(
                id: classModel.id,
                className: nameCtrl.text,
                subject: subjectCtrl.text,
                schedule: scheduleCtrl.text,
              );
            } else {
              success = await _classService.addClass(
                className: nameCtrl.text,
                subject: subjectCtrl.text,
                schedule: scheduleCtrl.text,
              );
            }

            hideLoading(); // 3. Tắt loading

            if (success) {
              showSuccess(
                isEditing ? "Cập nhật thành công" : "Tạo lớp thành công",
              );
            } else {
              showError("Có lỗi xảy ra, vui lòng kiểm tra kết nối");
            }
          },
          child: Text(
            isEditing ? 'LƯU THAY ĐỔI' : 'TẠO LỚP',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
      ),
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF909CC2), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
