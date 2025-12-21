import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/web_modules/auth/controller/auth_controller.dart';
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
    _authController = Get.find<AuthController>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Background Image
          // Dùng Image.asset vì đây là file trong máy (Assets.gen)
          Positioned.fill(
            child: Image.asset(Assets.images.bgr.path, fit: BoxFit.cover),
          ),

          // 2. Overlay màu tối (Lớp phủ)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                0.6,
              ), // Tăng độ tối lên 0.6 cho chữ rõ hơn
            ),
          ),

          // 3. Form Đăng nhập (Dùng Center + SingleChildScrollView)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0), // Padding cho màn hình nhỏ
              child: Container(
                // Responsive: Trên web/tablet thì max 500, trên đt thì full chiều ngang (trừ padding)
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: AppColor.secondary, // Hoặc Colors.white nếu muốn sáng
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Kéo dãn các phần tử con
                  children: [
                    // Tiêu đề
                    Text(
                      'Đăng Nhập',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 30),

                    // Input Username
                    CustomTextField(
                      controller: _usernameController,
                      labelText: 'Tên Đăng Nhập',
                      prefixIcon: Icons.person,
                    ),

                    const SizedBox(height: 20),

                    // Input Password
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Mật Khẩu',
                      prefixIcon: Icons.lock,
                      isPassword: true,
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
                 CustomButton(
                      text: 'Xác nhận',
                      onPressed: () {
                        // Đóng bàn phím ảo trước khi login cho gọn UI
                        FocusScope.of(context).unfocus(); 
                        
                        String username = _usernameController.text.trim();
                        String password = _passwordController.text.trim();
                        _authController.login(username, password);
                      },
                      backgroundColor: AppColor.primary,
                      foregroundColor: AppColor.white,
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
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
