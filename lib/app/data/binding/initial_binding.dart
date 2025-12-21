import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/data/service/student_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassService>(() => ClassService());
    Get.lazyPut<StudentService>(() => StudentService());
  }
}
