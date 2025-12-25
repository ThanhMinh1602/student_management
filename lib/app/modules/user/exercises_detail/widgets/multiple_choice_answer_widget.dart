
// --- WIDGET CHỌN ĐÁP ÁN TRẮC NGHIỆM (MULTIPLE CHOICE) ---
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class MultipleChoiceAnswerWidget extends StatelessWidget {
  const MultipleChoiceAnswerWidget({
    super.key,
    required this.answers,
  });

  final List<Map<String, dynamic>> answers;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: answers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final item = answers[index];
          return SizedBox(
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColor.secondary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                print('Selected: ${item['label']}');
              },
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Icon(
                      item['icon'],
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        item['text'],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}