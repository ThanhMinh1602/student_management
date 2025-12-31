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
    // 1. Trim dữ liệu đầu vào để tránh lỗi khoảng trắng thừa
    final cleanUsername = username.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
      showWarning('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');
      return;
    }

    try {
      showLoading();

      // 2. Gọi API
      final user = await _authService.login(cleanUsername, cleanPassword);

      // Lưu ý: Không hideLoading ở đây nữa, để finally xử lý hoặc hide trước khi navigate

      if (user == null) {
        hideLoading(); // Cần hide ở đây vì return sớm
        showError('Sai tên đăng nhập hoặc mật khẩu');
        return;
      }

      if (!user.isActive) {
        hideLoading();
        showError('Tài khoản của bạn đã bị khóa');
        return;
      }

      // --- SỬA LỖI: Đưa logic lưu user ra ngoài để áp dụng cho TẤT CẢ role ---

      // 3. Cập nhật State quản lý User toàn cục
      currentUser.value = user;

      // 4. Lưu vào Local Storage (để tự động login lần sau)
      try {
        await _storage.write(_storageKey, user.toMap());
      } catch (e) {
        print('Lỗi lưu session: $e'); // Log để debug thay vì bỏ qua
      }

      showSuccess('Xin chào ${user.fullName}');

      // Tắt loading trước khi chuyển trang để tránh memory leak hoặc glitch UI
      hideLoading();

      // 5. Điều hướng dựa trên Role
      if (user.role == 'admin') {
        Get.offAllNamed(AppRoutes.QUESTION_MANAGEMENT);
      } else {
        Get.offAllNamed(AppRoutes.EXERCISES);
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
