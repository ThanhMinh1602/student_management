import 'package:flutter/material.dart';

class AnswerUnknown extends StatefulWidget {
  const AnswerUnknown({super.key});

  @override
  State<AnswerUnknown> createState() => _AnswerUnknownState();
}

class _AnswerUnknownState extends State<AnswerUnknown> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Answer Unknown Widget'));
  }
}
