import 'package:blooket/app/routes/app_routes.dart';
import 'package:blooket/app/web_modules/class_management/binding/class_management_binding.dart';
import 'package:blooket/app/web_modules/class_management/binding/class_management_detail_binding.dart';
import 'package:blooket/app/web_modules/class_management/views/class_management_view.dart';
import 'package:blooket/app/web_modules/class_management/views/class_management_detail_view.dart';
import 'package:blooket/app/web_modules/dashboard/binding/dashboard_binding.dart';
import 'package:blooket/app/web_modules/dashboard/view/dashboard_view.dart';
import 'package:blooket/app/web_modules/question_management/binding/question_management_binding.dart';
import 'package:blooket/app/web_modules/question_management/views/question_management_view.dart';
import 'package:blooket/app/web_modules/student_management/binding/student_management_binding.dart';
import 'package:blooket/app/web_modules/student_management/views/student_management_view.dart';
import 'package:get/get.dart';

import '../web_modules/auth/binding/auth_binding.dart';
import '../web_modules/auth/view/login_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.LOGIN;

  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      children: [
        GetPage(
          name: AppRoutes.STUDENT_MANAGEMENT,
          page: () => const StudentManagementView(),
          binding: StudentManagementBinding(),
        ),
        GetPage(
          name: AppRoutes.CLASS_MANAGEMENT,
          page: () => const ClassManagementView(),
          binding: ClassManagementBinding(),
          children: [
            GetPage(
              name: AppRoutes.CLASS_MANAGEMENT_DETAIL,
              page: () => const ClassManagementDetailView(),
              binding: ClassManagementDetailBinding(),
            ),
          ],
        ),
        GetPage(
          name: AppRoutes.QUESTION_MANAGEMENT,
          page: () => const QuestionManagementView(),
          binding: QuestionManagementBinding(),
        ),
      ],
    ),
  ];
}
