import 'package:blooket/app/web_modules/student_management/controllers/student_management_controller.dart';
import 'package:get/get.dart';

class StudentManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentManagementController>(
      () => StudentManagementController(Get.find()),
    );
  }
}
