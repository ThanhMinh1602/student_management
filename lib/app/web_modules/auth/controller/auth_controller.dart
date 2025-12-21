import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/student_model.dart';
import 'package:blooket/app/data/service/auth_service.dart';
import 'package:blooket/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends BaseController {
  final AuthService _authService;

  // Lưu user hiện tại (null nếu chưa đăng nhập)
  final Rxn<StudentModel> currentUser = Rxn<StudentModel>();

  AuthController(this._authService); // Khởi tạo Service

  final GetStorage _storage = GetStorage();

  static const String _storageKey = 'currentUser';

  @override
  void onInit() {
    super.onInit();
    // Restore session if any
    final data = _storage.read(_storageKey);
    if (data != null && data is Map<String, dynamic>) {
      try {
        currentUser.value = StudentModel.fromMap(Map<String, dynamic>.from(data));
      } catch (_) {
        // ignore: avoid_print
        print('Failed to restore user session');
      }
    }
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<void> login(String username, String password) async {
    // 1. Validate đầu vào
    if (username.isEmpty || password.isEmpty) {
      showWarning('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');
      return;
    }

    try {
      // 2. Show Loading
      showLoading();

      // 3. Gọi Service để lấy thông tin User
      final user = await _authService.login(username, password);

      // 4. Ẩn Loading ngay sau khi có kết quả
      hideLoading();

      if (user == null) {
        showError('Sai tên đăng nhập hoặc mật khẩu');
        return;
      }

      // 5. Kiểm tra trạng thái tài khoản
      if (!user.isActive) {
        showError('Tài khoản của bạn đã bị khóa');
        return;
      }

      // 6. CHECK ROLE (Quan trọng)
      if (user.role == 'admin') {
        // Lưu user hiện tại để dùng ở các màn hình khác
        currentUser.value = user;
        // Persist to storage
        try {
          _storage.write(_storageKey, user.toMap());
        } catch (_) {}
        showSuccess('Xin chào Admin ${user.fullName}');
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        // Nếu là student hoặc role khác
        showWarning('Bạn không có quyền truy cập vào trang quản trị (Admin Only)');
      }

    } catch (e) {
      hideLoading();
      showError('Đã có lỗi xảy ra: $e');
    }
  }

  // Hàm đăng xuất: xóa user và quay về màn hình login
  Future<void> logout() async {
    currentUser.value = null;
    // Remove persisted session
    try {
      _storage.remove(_storageKey);
    } catch (_) {}
    showInfo('Đã đăng xuất');
    // Quay về login và xóa lịch sử route
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}