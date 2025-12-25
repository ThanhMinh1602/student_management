import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:blooket/app/modules/user/exercises_detail/widgets/exercise_result_widget.dart';
import 'package:blooket/app/modules/user/exercises_detail/widgets/question_widget.dart';
import 'package:blooket/app/modules/user/exercises_detail/widgets/typing_answer_widget.dart';
import 'package:flutter/material.dart';
import 'package:blooket/app/core/components/appbar/custom_app_bar.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:get/get.dart';

class ExercisesDetailView extends StatelessWidget {
  const ExercisesDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<Map<String, dynamic>> answers = [
      {
        'label': 'A',
        'text': 'Câu trả lời thứ nhất',
        'icon': Icons.square,
        'color': Colors.redAccent,
      },
      {
        'label': 'B',
        'text': 'Câu trả lời thứ hai dài hơn một chút',
        'icon': Icons.circle,
        'color': Colors.blueAccent,
      },
      {
        'label': 'C',
        'text': 'Câu trả lời thứ ba',
        'icon': Icons.change_history,
        'color': Colors.amber,
      },
      {
        'label': 'D',
        'text': 'Câu trả lời thứ tư',
        'icon': Icons.star,
        'color': Colors.green,
      },
    ];

    // Biến cờ để test giao diện (Thực tế bạn sẽ lấy từ Model câu hỏi)
    bool isMultipleChoice = false;

    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: CustomAppBar(
        title: Get.parameters['id'] != null
            ? 'Bài Tập Chi Tiết ${Get.parameters['id']}'
            : 'Bài Tập Chi Tiết',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ExerciseResultWidget(),
        ),
      ),
    );
  }
}
