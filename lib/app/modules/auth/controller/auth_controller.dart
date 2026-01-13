import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/data/model/request/login_request.dart';
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
        currentUser.value = StudentModel.fromMap(
          Map<String, dynamic>.from(data),
        );
      } catch (_) {
        // ignore: avoid_print
        print('Failed to restore user session');
      }
    }
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<void> login(String username, String password) async {
    // 1. Trim dữ liệu đầu vào
    final email = username.trim();
    final cleanPassword = password.trim();

    if (email.isEmpty || cleanPassword.isEmpty) {
      showWarning('Vui lòng nhập đầy đủ email và mật khẩu');
      return;
    }

    try {
      showLoading();

      // Sử dụng LoginRequest model đã tạo
      final loginRequest = LoginRequest(email: email, password: cleanPassword);

      // 2. Gọi API thông qua AuthService
      // Chỉnh sửa: truyền loginRequest thay vì 2 biến rời rạc
      final response = await _authService.login(loginRequest);

      // Giả sử API trả về data chứa user info và token
      final userData = response.data;
      final user = StudentModel.fromMap(userData['user']);
      final token = userData['token'];

      if (!user.isActive) {
        hideLoading();
        showError('Tài khoản của bạn đã bị khóa');
        return;
      }

      // 3. Cập nhật State & Lưu Session
      currentUser.value = user;

      await Future.wait([
        _storage.write(_storageKey, user.toMap()),
        _storage.write('token', token), // Lưu token để Interceptor sử dụng
      ]);

      showSuccess('Xin chào ${user.fullName}');
      hideLoading();

      // 4. Điều hướng dựa trên Role
      if (user.role == 'admin') {
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        Get.offAllNamed(AppRoutes.EXERCISES);
      }
    } catch (e) {
      hideLoading();
      // Tận dụng xử lý lỗi từ ApiClient
      showError(e.toString());
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
