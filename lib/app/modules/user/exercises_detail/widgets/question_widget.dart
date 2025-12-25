
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/modules/user/exercises_detail/widgets/typing_answer_widget.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // --- PHẦN CÂU HỎI VÀ TIMER ---
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              constraints: const BoxConstraints(minHeight: 200),
              child: Center(
                child: Text(
                  'Nội dung câu hỏi sẽ hiển thị ở đây...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColor.pink,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.secondary, width: 6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '30',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    
        const SizedBox(height: 40),
    
        Text(
          'Question 1/15',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
    
        const SizedBox(height: 10),
    
        // --- HIỂN THỊ WIDGET TRẢ LỜI TÙY THEO LOẠI CÂU HỎI ---
        // Bạn có thể đổi widget ở đây dựa trên loại câu hỏi
        const TypingAnswerWidget(),
      ],
    );
  }
}
