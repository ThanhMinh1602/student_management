import 'package:blooket/app/core/components/button/custom_button.dart';
import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/data/enum/question_type.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_multi_chose.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_rearrange.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_true_false.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_typing.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/answer_form/answer_unknown.dart';
import 'package:blooket/app/modules/admin/question_management/widgets/bordered_stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blooket/app/data/model/question_model.dart';

class QuestionDialogView extends StatefulWidget {
  final String setId;
  final QuestionModel? initialData;
  final Function(QuestionModel) onSave;

  const QuestionDialogView({
    super.key,
    required this.setId,
    required this.onSave,
    this.initialData,
  });

  @override
  State<QuestionDialogView> createState() => _QuestionDialogViewState();
}

class _QuestionDialogViewState extends State<QuestionDialogView> {
  late QuestionType selectedType;
  final contentCtrl = TextEditingController();

  @override
  void initState() {
    if (widget.initialData != null) {
      selectedType = widget.initialData!.type;
      contentCtrl.text = widget.initialData!.content;
    } else {
      selectedType = QuestionType.multipleChoice;
    }
    super.initState();
  }

  Widget _getAnswerFromType() {
    switch (selectedType) {
      case QuestionType.multipleChoice:
        return AnswerMultiChose();
      case QuestionType.rearrange:
        return AnswerRearrange();
      case QuestionType.trueFalse:
        return AnswerTrueFalse();
      case QuestionType.typing:
        return AnswerTyping();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDialogHeaderControl(),
              _buildInputQuestion(),
              _getAnswerFromType(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputQuestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 100.0),
      child: TextField(
        controller: contentCtrl,
        textAlign: TextAlign.center,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Nhập câu hỏi ở đây...",
        ),
      ),
    );
  }

  Widget _buildDialogHeaderControl() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(color: AppColor.pink),
      child: Expanded(
        child: Row(
          spacing: 12.0,
          children: [
            BorderedStatWidget(
              title: 'Time\nlimit',
              value: '30s',
              icon: Icons.access_time,
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              child: BorderedStatWidget(
                title: 'Random\nOrder',
                value: 'V',
                icon: Icons.note_alt_outlined,
              ),
            ),
            _buildQuestionTypeSelector(),
            Spacer(),
            BorderedStatWidget(title: 'Cancel', icon: Icons.note_alt_outlined),
            BorderedStatWidget(
              title: 'Save',
              icon: Icons.roller_shades_closed_sharp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTypeSelector() {
    return BorderedStatWidget(
      title: selectedType.title,
      icon: Icons.question_answer,
      onTap: () async {
        final type = await Get.dialog<QuestionType>(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),

                      child: Text(
                        "Select Question Type",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...QuestionType.values.map((qt) {
                      final isSelected = qt == selectedType;
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.back(result: qt),
                          child: Container(
                            color: isSelected
                                ? AppColor.pink
                                : Colors.transparent,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 4.0,
                              ),
                              title: Text(
                                qt.title,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColor.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),

                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColor.white,
                                      size: 20,
                                    )
                                  : null,
                              dense: true,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );

        if (type != null && type != selectedType) {
          setState(() {
            selectedType = type;
          });
        }
      },
    );
  }
}
