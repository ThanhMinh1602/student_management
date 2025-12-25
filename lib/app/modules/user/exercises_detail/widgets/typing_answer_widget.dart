
// --- WIDGET NHẬP CÂU TRẢ LỜI (TYPING) ---
import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class TypingAnswerWidget extends StatelessWidget {
  const TypingAnswerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ĐIỀN ĐÁP ÁN:\n(Lưu ý: dấu câu)', 
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
          ), 
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const CustomTextField(
          labelText: 'Nhập câu trả lời',
        ),
        const SizedBox(height: 20),
        CustomButton(text: 'Nộp', onPressed: (){}),
       ],
    );
  }
}
