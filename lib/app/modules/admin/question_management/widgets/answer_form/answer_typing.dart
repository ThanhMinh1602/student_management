import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/components/text_field/custom_text_field.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class AnswerTyping extends StatefulWidget {
  const AnswerTyping({super.key});

  @override
  State<AnswerTyping> createState() => _AnswerTypingState();
}

class _AnswerTypingState extends State<AnswerTyping> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnswer() {
    if (_controllers.isNotEmpty && _controllers.last.text.trim().isEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Lỗi',
          message: 'Vui lòng nhập câu trả lời trước khi thêm đáp án mới.',
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.TOP,
        ),
      );
      return;
    }

    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeAnswer(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnswerFormWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nhập câu trả lời', style: TextStyle(fontSize: 18.0)),
          const SizedBox(height: 10.0),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _controllers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10.0),
            itemBuilder: (context, index) {
              return _buildAnswerInput(index);
            },
          ),

          const SizedBox(height: 20.0),

          CustomButton(text: 'Thêm đáp án đúng', onPressed: _addAnswer),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(int index) {
    bool isFirstItem = index == 0;

    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: _controllers[index],
            labelText: 'Câu trả lời đúng ${index + 1}',
          ),
        ),

        const SizedBox(width: 10.0),

        isFirstItem
            ? const SizedBox(width: 48.0)
            : IconButton(
                onPressed: () => _removeAnswer(index),
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                tooltip: 'Xóa đáp án này',
              ),
      ],
    );
  }
}
