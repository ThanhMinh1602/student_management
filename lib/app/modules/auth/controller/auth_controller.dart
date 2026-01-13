import 'dart:async';
import 'package:blooket/app/core/base/base_controller.dart';
import 'package:blooket/app/core/utils/logger.dart';
import 'package:blooket/app/data/model/request/login_request.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/response/auth_response_model.dart';
import 'package:blooket/app/data/model/user_model.dart';
import 'package:blooket/app/data/service/auth_service.dart';
import 'package:blooket/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends BaseController {
  final AuthService _authService;
  final GetStorage _storage = GetStorage();

  // Observable quản lý trạng thái User hiện tại
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // Khóa lưu trữ cục bộ
  static const String _userKey = 'currentUser';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  AuthController(this._authService);

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  // Khôi phục phiên làm việc khi mở App
  void _restoreSession() {
    final data = _storage.read(_userKey);
    if (data != null) {
      try {
        currentUser.value = UserModel.fromJson(Map<String, dynamic>.from(data));
        logger.i("Khôi phục phiên làm việc: ${currentUser.value?.name}");
      } catch (e) {
        logger.e("Lỗi khôi phục session: $e");
      }
    }
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<void> login(String username, String password) async {
    final cleanUsername = username.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
      showWarning('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');
      return;
    }

    try {
      showLoading();

      final loginRequest = LoginRequest(
        username: cleanUsername,
        password: cleanPassword,
      );

      // Gọi API trả về ApiResponse bọc AuthResponseModel
      final ApiResponse<AuthResponseModel> response = await _authService.login(
        loginRequest,
      );

      if (response.success && response.data != null) {
        final authData = response.data!;
        final user = authData.user;

        // 1. Kiểm tra trạng thái tài khoản
        if (user?.isActive == false) {
          hideLoading();
          showError('Tài khoản của bạn đã bị khóa');
          return;
        }

        // 2. Cập nhật State
        currentUser.value = user;

        // 3. Lưu Session & Tokens vào Storage
        await Future.wait([
          _storage.write(_userKey, user?.toJson()),
          _storage.write(_accessTokenKey, authData.accessToken),
          _storage.write(_refreshTokenKey, authData.refreshToken),
        ]);

        hideLoading();
        showSuccess('Xin chào ${user?.name ?? 'Bạn'}');

        // 4. Điều hướng dựa trên Role
        _navigateByRole(user?.role);
      } else {
        hideLoading();
        // Hiển thị mã lỗi từ Backend (MessageCodes)
        showError(response.message);
      }
    } catch (e) {
      hideLoading();
      logger.e("Login Controller Error: $e");
      showError('Đã xảy ra lỗi hệ thống');
    }
  }

  void _navigateByRole(String? role) {
    if (role == 'admin') {
      Get.offAllNamed(AppRoutes.DASHBOARD);
    } else if (role == 'teacher') {
      Get.offAllNamed(AppRoutes.DASHBOARD); // Hoặc route riêng cho giáo viên
    } else {
      Get.offAllNamed(AppRoutes.EXERCISES);
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    try {
      // Xóa toàn bộ thông tin bảo mật
      await Future.wait([
        _storage.remove(_userKey),
        _storage.remove(_accessTokenKey),
        _storage.remove(_refreshTokenKey),
      ]);
    } catch (e) {
      logger.e("Logout Error: $e");
    }

    showInfo('Đã đăng xuất');
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
