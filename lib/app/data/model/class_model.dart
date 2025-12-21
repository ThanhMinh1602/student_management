import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String id;
  final String className;
  final String subject;
  final String schedule;
  final int studentCount;

  ClassModel({
    required this.id,
    required this.className,
    required this.subject,
    required this.schedule,
    required this.studentCount,
  });

  // 1. Convert từ Firestore Document sang Model
  factory ClassModel.fromSnapshot(DocumentSnapshot doc) {
    // Lấy data bên trong document
    final data = doc.data() as Map<String, dynamic>;
    
    return ClassModel(
      id: doc.id, // ID lấy từ document ID của Firestore
      className: data['className'] ?? '',
      subject: data['subject'] ?? '',
      schedule: data['schedule'] ?? '',
      studentCount: data['studentCount'] ?? 0,
    );
  }

  // 2. Convert từ Model sang JSON để đẩy lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'className': className,
      'subject': subject,
      'schedule': schedule,
      'studentCount': studentCount,
      // Không cần gửi ID vì Firestore tự tạo hoặc ID nằm ở path
    };
  }

  // For consistency: provide map serialization/deserialization for local storage or other uses
  Map<String, dynamic> toMap() => {
        'id': id,
        'className': className,
        'subject': subject,
        'schedule': schedule,
        'studentCount': studentCount,
      };

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      className: map['className'] ?? '',
      subject: map['subject'] ?? '',
      schedule: map['schedule'] ?? '',
      studentCount: (map['studentCount'] ?? 0) is int
          ? map['studentCount']
          : (map['studentCount'] ?? 0).toInt(),
    );
  }

  // Hàm copyWith (Giữ nguyên để dùng cho State Management nếu cần)
  ClassModel copyWith({
    String? id,
    String? className,
    String? subject,
    String? schedule,
    int? studentCount,
  }) {
    return ClassModel(
      id: id ?? this.id,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      schedule: schedule ?? this.schedule,
      studentCount: studentCount ?? this.studentCount,
    );
  }
}