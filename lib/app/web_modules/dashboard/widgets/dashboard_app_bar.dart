import 'package:blooket/app/core/constants/app_color.dart';
// import 'package:blooket/gen/assets.gen.dart'; // Mở comment nếu đã có file gen assets
import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const DashboardAppBar({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.pink, // Hoặc Colors.white tuỳ thiết kế
      elevation: 0,
      automaticallyImplyLeading: false, // Tắt nút back mặc định
      
      // PHẦN BÊN TRÁI: Logo + Tên Brand
      title: Row(
        children: [
          // Logo
          // Nếu bạn dùng assets gen thì: Image.asset(Assets.images.logo.path, height: 32)
          Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: Colors.white, // Nền logo giả lập
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: AppColor.primary, size: 20),
          ),
          
          const SizedBox(width: 10),
          
          // Chữ Qiuhong laoshi
          const Text(
            'Qiuhong Laoshi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),

      // PHẦN BÊN PHẢI: Xin chào + Avatar
      actions: [
        Row(
          children: [
            // Dòng chào mừng (Ẩn trên màn hình quá bé nếu cần)
            Text(
              'Xin chào, $userName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(width: 10),

            // Avatar Logic
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColor.secondary, // Màu nền nếu không có ảnh
                // Nếu có URL -> Load ảnh mạng, Nếu không -> null
                backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                    ? NetworkImage(avatarUrl!)
                    : null,
                
                // Nếu KHÔNG có ảnh -> Hiển thị chữ cái đầu
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? Text(
                        _getFirstLetter(userName),
                        style: const TextStyle(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
            
            const SizedBox(width: 16), // Padding phải ngoài cùng
          ],
        )
      ],
    );
  }

  // Hàm lấy chữ cái đầu an toàn
  String _getFirstLetter(String name) {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}