// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AnswerFormWidget extends StatelessWidget {
  const AnswerFormWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
