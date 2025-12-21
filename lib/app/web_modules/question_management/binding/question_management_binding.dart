import 'package:blooket/app/web_modules/question_management/controller/question_management_controller.dart';
import 'package:get/get.dart';

class QuestionManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionManagementController>(
      () => QuestionManagementController(),
    );
  }
}