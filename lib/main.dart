import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/binding/initial_binding.dart';
import 'package:blooket/app/routes/app_pages.dart';
import 'package:blooket/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // 1. Import gói này
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Init GetStorage for session persistence
  await GetStorage.init();
  configLoading();

  runApp(const MyApp());
}

// Hàm cấu hình style cho EasyLoading (Màu sắc, animation...)
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColor.primary
    ..backgroundColor = AppColor.secondary
    ..indicatorColor = AppColor.primary
    ..textColor = AppColor.primary
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      defaultTransition: Transition.noTransition,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.paytoneOneTextTheme()),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),

      // 3. QUAN TRỌNG NHẤT: Khởi tạo EasyLoading tại đây
      builder: EasyLoading.init(),
    );
  }
}
