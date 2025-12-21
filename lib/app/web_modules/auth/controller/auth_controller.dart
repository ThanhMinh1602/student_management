// Import BaseController
import 'package:blooket/app/base/base_controller.dart';
import 'package:blooket/app/routes/app_routes.dart';
import 'package:get/get.dart';

// Thay đổi: extends BaseController
class AuthController extends BaseController {
  Future<void> login(String username, String password) async {
    // 1. Validate
    // if (username.isEmpty || password.isEmpty) {
    //   // Dùng hàm có sẵn của BaseController
    //   showWarning('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');
    //   return;
    // }

    try {
      // 2. Show Loading
      showLoading();

      // Giả lập call API
      await Future.delayed(const Duration(seconds: 2));

      // 3. Logic Login
      if (username == '' && password == '') {
        hideLoading(); // Ẩn loading
        showSuccess('Đăng nhập thành công!'); // Thông báo xanh lá
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        hideLoading();
        showError('Sai tên đăng nhập hoặc mật khẩu'); // Thông báo đỏ
      }
    } catch (e) {
      hideLoading();
      showError('Đã có lỗi xảy ra: $e');
    }
  }
}
