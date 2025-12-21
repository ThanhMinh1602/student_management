import 'package:blooket/app/data/model/question_set_model.dart';
import 'package:get/get.dart';

class QuestionManagementController extends GetxController {
  final questionSets = <QuestionSetModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // Dữ liệu giả lập cập nhật theo Model mới
    questionSets.assignAll([
      QuestionSetModel(id: '1', name: 'Sơ cấp 1 - Bài 1', questionCount: 15, createdAt: DateTime.now()),
      QuestionSetModel(id: '2', name: 'Sơ cấp 1 - Bài 2', questionCount: 20, createdAt: DateTime.now().subtract(const Duration(days: 2))),
      QuestionSetModel(id: '3', name: 'HSK 3 - Tổng hợp', questionCount: 45, createdAt: DateTime.now().subtract(const Duration(days: 5))),
      QuestionSetModel(id: '4', name: 'Từ vựng HSK 4', questionCount: 100, createdAt: DateTime.now().subtract(const Duration(days: 10))),
      QuestionSetModel(id: '5', name: 'Ngữ pháp cơ bản', questionCount: 12, createdAt: DateTime.now().subtract(const Duration(days: 1))),
    ]);
  }

  // --- HÀNH ĐỘNG MỚI: GIAO BÀI ---
  void assignTask(String id) {
    // Logic: Mở popup chọn lớp hoặc chuyển màn hình
    Get.snackbar(
      'Giao bài', 
      'Đang mở giao diện giao bài cho bộ đề ID: $id',
      backgroundColor: Get.theme.primaryColor.withOpacity(0.2),
    );
  }

  void deleteSet(String id) {
    Get.defaultDialog(
      title: "Xác nhận",
      middleText: "Bạn muốn xóa bộ câu hỏi này?",
      textConfirm: "Xóa",
      textCancel: "Hủy",
      onConfirm: () {
        questionSets.removeWhere((item) => item.id == id);
        Get.back();
      },
    );
  }

  void editSet(String id) {
    print("Edit ID: $id");
  }

  void createSet() {
    print("Create new set");
  }
}