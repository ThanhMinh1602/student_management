import 'dart:ui'; // Bắt buộc import để dùng ImageFilter
import 'package:blooket/app/core/components/button/custom_icon_button.dart';
import 'package:blooket/app/core/components/header/custom_page_header.dart';
import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/up_down_controls.dart';
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
            Expanded(flex: 2, child: _buildRightWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildRightWidget() {
    return Column(
      children: [
        CustomPageHeader(
          extraWidget: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: const Text(
              '15 câu hỏi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          subtitle: 'Quản lý các câu hỏi trong bộ đề',
          buttonLabel: 'Thêm câu hỏi mới',
          onButtonPressed: () {
            // Logic thêm câu hỏi mới
          },
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  // Căn giữa theo chiều dọc để nút Up/Down nằm giữa
                  spacing: 8.0,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- PHẦN SỬA LỖI Ở ĐÂY ---
                    // Bọc Column trong Expanded để nó chiếm hết chiều ngang còn lại
                    Expanded(
                      flex: 1,
                      child: Column(
                        spacing: 8,
                        // Kéo dãn các nút con cho bằng chiều ngang
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Nút Edit: Bỏ Expanded bao ngoài, để nó tự tính chiều cao
                          CustomIconButton(
                            icon: Icons.edit_outlined,
                            iconColor: Colors.white,
                            backgroundColor: AppColor.pink,
                            label: 'Edit', // Có label nên nút sẽ dài ra
                            onTap: () {
                              // Logic edit
                            },
                          ),

                          // 2. Hàng nút Delete/Copy
                          Row(
                            spacing: 8,
                            children: [
                              // Dùng Expanded để 2 nút này chia đều 50-50 chiều rộng
                              Expanded(
                                child: CustomIconButton(
                                  icon: Icons.delete_outline,
                                  iconColor: Colors.white,
                                  backgroundColor: AppColors.primary,
                                  onTap: () {
                                    // Logic xóa
                                  },
                                ),
                              ),
                              Expanded(
                                child: CustomIconButton(
                                  icon: Icons.copy_outlined,
                                  iconColor: Colors.white,
                                  backgroundColor: AppColors.primary,
                                  onTap: () {
                                    // Logic copy
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Câu hỏi số ${index + 1}"),
                          SizedBox(height: 8),
                          Text(
                            'Nội dung câu hỏi sẽ hiển thị ở đây.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    UpDownControls(onUp: () {}, onDown: () {}),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        ),
      ],
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
