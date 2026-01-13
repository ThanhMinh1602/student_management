import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/service/auth_service.dart';
import 'package:blooket/app/data/service/class_service.dart';
import 'package:blooket/app/data/service/question_service.dart';
import 'package:blooket/app/data/service/set_service.dart';
import 'package:blooket/app/data/service/student_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // client
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    // services
    Get.lazyPut<ClassService>(
      () => ClassService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<StudentService>(
      () => StudentService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<QuestionService>(
      () => QuestionService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<AuthService>(
      () => AuthService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SetService>(
      () => SetService(Get.find<ApiClient>()),
      fenix: true,
    );
  }
}
