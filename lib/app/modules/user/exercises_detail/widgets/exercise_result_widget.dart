import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseResultWidget extends StatelessWidget {
  const ExerciseResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Định nghĩa màu sắc cục bộ cho widget này (hoặc lấy từ AppColor nếu có)
    const Color labelColor = Color(0xFF808ACB); // Màu tím nhạt cho nhãn
    const Color scoreColor = Color(0xFF8CC63F); // Màu xanh lá cho điểm số to
    
    return Center( // Căn giữa màn hình
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10), // Tránh sát mép màn hình
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Quan trọng: Co lại vừa nội dung
          children: [
            // --- 1. AVATAR ---
            CircleAvatar(
              radius: 42, 
              backgroundColor: AppColor.primary, 
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: AppColor.primary,
                  size: 50,
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // --- 2. USER NAME ---
            Text(
              'Sunni',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 25),

            // --- 3. INFO ROWS ---
            _buildInfoRow(context, label: 'Điểm', value: '850'),
            const SizedBox(height: 10),
            _buildInfoRow(context, label: 'Thời gian', value: '12m 30s'),
            
            const SizedBox(height: 10),
            
            // --- 4. BIG RESULT (HERO SECTION) ---
            Text(
              'Số đáp án đúng',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '12/15',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.w900, // Rất đậm
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 35),

            // --- 5. BUTTONS ---
            // Giả sử CustomButton của bạn có tham số width hoặc bọc trong SizedBox
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'CHƠI LẠI',
                // backgroundColor: AppColor.primary, // Nếu CustomButton hỗ trợ chỉnh màu
                onPressed: () {
                  // Xử lý khi nhấn nút
                },
              ),
            ),
            
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'VỀ MENU CHÍNH',
                // backgroundColor: Colors.grey, // Nút phụ nên màu nhạt hơn nếu có thể
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để hiển thị từng dòng thông tin (Label ----- Value)
  Widget _buildInfoRow(BuildContext context, {required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF808ACB), // Màu tím nhạt
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}