import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String id;
  final String fullName;
  final String username;
  final String password; // Thêm field này để check login (Lưu ý: Thực tế nên hash)
  final String role;     // Thêm field này: 'admin' hoặc 'student'
  final String classId;
  final double avgScore;
  final bool isActive;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
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
      password: data['password'] ?? '', 
      role: data['role'] ?? 'student', // Mặc định là student nếu không có field này
      classId: data['classId'] ?? '',
      avgScore: (data['avgScore'] ?? 0).toDouble(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}