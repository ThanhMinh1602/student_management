import 'package:blooket/app/modules/admin/question_management/widgets/answer_form_widget.dart';
import 'package:flutter/material.dart';

class AnswerRearrange extends StatefulWidget {
  const AnswerRearrange({super.key});

  @override
  State<AnswerRearrange> createState() => _AnswerRearrangeState();
}

class _AnswerRearrangeState extends State<AnswerRearrange> {
  @override
  Widget build(BuildContext context) {
    return AnswerFormWidget(
      child: Center(child: Text('Answer Rearrange Widget')),
    );
  }
}
