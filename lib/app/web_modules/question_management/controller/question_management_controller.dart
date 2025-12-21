// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blooket/app/data/service/class_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  void createSet() {
    _showFormDialog(); // Gọi dialog không tham số -> Tạo mới
  }

  void editSet(String id) {
    final existingSet = questionSets.firstWhere((e) => e.id == id);
    _showFormDialog(model: existingSet); // Gọi dialog có tham số -> Chỉnh sửa
  }

  void deleteSet(String id) {
    Get.defaultDialog(
      title: "Xóa bộ đề?",
      titleStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
      middleText: "Hành động này sẽ xóa vĩnh viễn bộ câu hỏi này.",
      textConfirm: "Xóa ngay",
      textCancel: "Hủy",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.grey,
      onConfirm: () async {
        Get.back(); // Đóng dialog confirm
        await Future.delayed(const Duration(milliseconds: 300)); // Fix loading

        showLoading();
        bool success = await _questionService.deleteQuestionSet(id);
        hideLoading();

        if (success)
          showSuccess("Đã xóa bộ đề");
        else
          showError("Lỗi khi xóa bộ đề");
      },
    );
  }

  // Hàm Assign (đã làm ở bước trước, giữ nguyên)
  void assignTask(QuestionSetModel questionSet) {
    // Nếu chưa có lớp nào thì báo lỗi
    if (classList.isEmpty) {
      showWarning("Bạn cần tạo Lớp học trước khi giao bài!");
      return;
    }

    // Biến lưu trữ tạm thời cho Dialog
    ClassModel? selectedClass;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(
      const Duration(days: 7),
    ); // Mặc định 1 tuần

    // Controller để hiển thị text ngày tháng
    final dateTextCtrl = TextEditingController(
      text:
          "${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}",
    );

    Get.defaultDialog(
      title: "GIAO BÀI TẬP",
      titleStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w900),
      radius: 20,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị tên bộ đề đang chọn
          Text(
            "Bộ đề: ${questionSet.name}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 1. Dropdown chọn Lớp
          DropdownButtonFormField<ClassModel>(
            decoration: InputDecoration(
              labelText: "Chọn lớp áp dụng",
              prefixIcon: Icon(Icons.class_, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items: classList.map((cls) {
              return DropdownMenuItem(
                value: cls,
                child: Text(cls.className, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) => selectedClass = val,
          ),

          const SizedBox(height: 16),

          // 2. Chọn Thời gian (Date Range Picker)
          TextField(
            controller: dateTextCtrl,
            readOnly: true, // Không cho nhập tay, chỉ bấm để chọn
            decoration: InputDecoration(
              labelText: "Thời gian làm bài",
              prefixIcon: Icon(Icons.date_range, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onTap: () async {
              // Mở lịch chọn ngày
              final picked = await showDateRangePicker(
                context: Get.context!,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                initialDateRange: DateTimeRange(start: startDate, end: endDate),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: actionColor, // Màu hồng cho lịch
                      colorScheme: ColorScheme.light(primary: actionColor),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                startDate = picked.start;
                endDate = picked.end;
                // Cập nhật lại text hiển thị
                dateTextCtrl.text =
                    "${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}";
              }
            },
          ),
        ],
      ),
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor, // Màu hồng
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            if (selectedClass == null) {
              showWarning("Vui lòng chọn lớp học");
              return;
            }

            Get.back(); // Đóng dialog
            await Future.delayed(const Duration(milliseconds: 300));

            showLoading();

            // Tạo model Assignment
            final assignment = AssignmentModel(
              id: '', // Firestore tự sinh
              questionSetId: questionSet.id,
              questionSetName: questionSet.name,
              classId: selectedClass!.id,
              className: selectedClass!.className,
              startDate: startDate,
              endDate: endDate,
              createdAt: DateTime.now(),
            );

            // Gọi Service lưu
            bool success = await _questionService.createAssignment(assignment);

            hideLoading();

            if (success) {
              showSuccess(
                "Đã giao bài thành công cho lớp ${selectedClass!.className}",
              );
            } else {
              showError("Lỗi hệ thống, vui lòng thử lại");
            }
          },
          child: const Text(
            "XÁC NHẬN GIAO",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  // --- PRIVATE: FORM DIALOG ---
  void _showFormDialog({QuestionSetModel? model}) {
    final isEditing = model != null;
    final nameCtrl = TextEditingController(text: isEditing ? model.name : '');

    Get.defaultDialog(
      title: isEditing ? "ĐỔI TÊN BỘ ĐỀ" : "TẠO BỘ ĐỀ MỚI",
      titleStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w900),
      radius: 20,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        children: [
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
              labelText: "Tên bộ đề (VD: HSK 1 - Bài 5)",
              prefixIcon: Icon(Icons.quiz, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ],
      ),
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor, // Màu hồng
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            if (nameCtrl.text.trim().isEmpty) {
              showWarning("Vui lòng nhập tên bộ đề");
              return;
            }

            Get.back(); // Đóng dialog
            await Future.delayed(const Duration(milliseconds: 300));

            showLoading();
            bool success = false;

            if (isEditing) {
              success = await _questionService.updateQuestionSet(
                model.id,
                nameCtrl.text.trim(),
              );
            } else {
              success = await _questionService.createQuestionSet(
                nameCtrl.text.trim(),
              );
            }

            hideLoading();

            if (success) {
              showSuccess(
                isEditing ? "Đã cập nhật tên bộ đề" : "Đã tạo bộ đề mới",
              );
            } else {
              showError("Có lỗi xảy ra, vui lòng thử lại");
            }
          },
          child: Text(
            isEditing ? "LƯU THAY ĐỔI" : "TẠO MỚI",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
