import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String fullName;
  final String username;
  final String classId; // Để biết học viên thuộc lớp nào
  final double avgScore;
  final bool isActive;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.classId,
    required this.avgScore,
    required this.isActive,
    required this.createdAt,
  });

  factory StudentModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      username: data['username'] ?? '',
      classId: data['classId'] ?? '',
      avgScore: (data['avgScore'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
