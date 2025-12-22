import 'package:blooket/app/core/components/button/primary_button.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:blooket/app/core/components/card/app_card.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/modules/auth/controller/auth_controller.dart';
import 'package:blooket/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Tách hàm xử lý login ra để dùng chung cho nút bấm và phím Enter
  void _onLoginPressed() {
    // Đóng bàn phím ảo (Mobile) hoặc bỏ focus (Web)
    FocusScope.of(context).unfocus();

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    _authController.login(username, password);
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để xử lý responsive nếu cần thiết
    // final size = MediaQuery.of(context).size;

    return GestureDetector(
      // Cho phép bấm ra ngoài để ẩn bàn phím (Mobile)
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // 1. Background Image
            Positioned.fill(
              child: Image.asset(
                Assets.images.bgr.path,
                fit: BoxFit.cover,
              ),
            ),

            // 2. Overlay màu tối
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),

            // 3. Form Đăng nhập
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  // --- QUAN TRỌNG CHO WEB ---
                  // Giới hạn chiều rộng tối đa là 450px.
                  // Trên điện thoại (nhỏ hơn 450px) nó sẽ full màn hình.
                  // Trên Web (lớn hơn 450px) nó sẽ giữ form gọn gàng ở giữa.
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: AppCard(
                    color: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    borderRadius: 24.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tiêu đề
                        Text(
                          'Đăng Nhập',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const SizedBox(height: 30),

                        // Input Username
                        CustomTextField(
                          controller: _usernameController,
                          labelText: 'Tên Đăng Nhập',
                          prefixIcon: Icons.person,
                          // Cho phép nhấn Next trên bàn phím điện thoại
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 20),

                        // Input Password
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Mật Khẩu',
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          // Cho phép nhấn Done/Enter để login luôn
                          textInputAction: TextInputAction.done,
                          // Sự kiện khi nhấn Enter (cần support trong CustomTextField của bạn)
                          onSubmitted: (_) => _onLoginPressed(),
                        ),

                        // Quên mật khẩu
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Nút Login
                        PrimaryButton(
                          label: 'Xác nhận',
                          onPressed: _onLoginPressed,
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),

                        const SizedBox(height: 20),

                        // Đăng ký ngay
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Chưa có tài khoản? ',
                              style: TextStyle(color: Colors.white70),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click, // Hiển thị tay chỉ khi hover trên Web
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Đăng ký ngay',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}