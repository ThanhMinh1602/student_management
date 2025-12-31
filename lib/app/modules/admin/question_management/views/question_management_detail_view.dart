import 'dart:ui'; // Bắt buộc import để dùng ImageFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Các import từ project của bạn (giữ nguyên)
import 'package:blooket/app/core/components/button/custom_action_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/modules/admin/question_management/controller/question_management_detail_controller.dart';

class QuestionManagementDetailView
    extends GetView<QuestionManagementDetailController> {
  const QuestionManagementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor,
      appBar: const CustomAppBar(title: 'Chi Tiết Bộ Đề'),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trên cùng
          children: [
            // Cột bên trái: Menu điều khiển
            SizedBox(
              width: 320, // Fix chiều rộng cho cột trái để giao diện ổn định
              child: _buildLeftWidget(),
            ),

            const SizedBox(width: 20), // Khoảng cách giữa 2 cột
            // Cột bên phải: Nội dung chính (Placeholder màu hồng)
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.pink,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20),
        // Thêm bóng đổ nhẹ cho nổi khối
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ôm sát nội dung
        children: [
          // 1. Tên bộ đề
          Text(
            controller.setName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24), // Khoảng cách
          // 2. Nút Save (Nút chính)
          CustomActionButton(
            width: double.infinity, // Tự động giãn full chiều ngang
            onTap: () {},
            icon: Icons.save_outlined,
            text: 'SAVE',
          ),

          const SizedBox(height: 16), // Khoảng cách
          // 3. Hai nút phụ (Hiệu ứng kính)
          Row(
            children: [
              // Nút Edit
              Expanded(
                child: _buildGlassButton(
                  icon: Icons.edit_outlined,
                  text: 'Chỉnh sửa',
                  onTap: () async {
                    // Logic edit
                  },
                ),
              ),

              const SizedBox(width: 12), // Khoảng cách giữa 2 nút nhỏ
              // Nút Time Limit
              Expanded(
                child: _buildGlassButton(
                  icon: Icons.timer_outlined,
                  text: 'Thời gian',
                  onTap: () {
                    // Logic time limit
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget tạo nút hiệu ứng kính mờ (Frosted Glass)
  Widget _buildGlassButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    // ClipRRect để bo góc cho hiệu ứng mờ không bị tràn
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Độ nhòe kính
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                // Màu trắng mờ (độ trong suốt thấp vì đã có blur)
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                // Viền trắng mờ tạo cảm giác kính dày
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
