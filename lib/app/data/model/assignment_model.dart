import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  final String id;
  final String questionSetId;
  final String questionSetName; // Lưu tên để hiển thị cho nhanh
  final String classId;
  final String className;       // Lưu tên lớp để hiển thị
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  AssignmentModel({
    required this.id,
    required this.questionSetId,
    required this.questionSetName,
    required this.classId,
    required this.className,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  // Convert to JSON để lưu lên Firestore
  Map<String, dynamic> toJson() => {
    'questionSetId': questionSetId,
    'questionSetName': questionSetName,
    'classId': classId,
    'className': className,
    'startDate': startDate,
    'endDate': endDate,
    'createdAt': FieldValue.serverTimestamp(),
  };
}