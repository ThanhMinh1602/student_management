import 'package:blooket/app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AnswerMultiChose extends StatefulWidget {
  const AnswerMultiChose({super.key});

  @override
  State<AnswerMultiChose> createState() => _AnswerMultiChoseState();
}

class _AnswerMultiChoseState extends State<AnswerMultiChose> {
  int _selectedAnswerIndex = 0;

  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final isSelected = _selectedAnswerIndex == index;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.pink : Colors.grey,
              width: isSelected ? 3.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Radio<int>(
                value: index,
                groupValue: _selectedAnswerIndex,
                activeColor: AppColors.pink,
                onChanged: (int? val) {
                  setState(() {
                    _selectedAnswerIndex = val!;
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Đáp án ${index + 1}',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
