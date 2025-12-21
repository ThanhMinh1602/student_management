import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionSetModel {
  final String id;
  final String name;
  final int questionCount;
  final DateTime createdAt;

  QuestionSetModel({
    required this.id,
    required this.name,
    required this.questionCount,
    required this.createdAt,
  });

  factory QuestionSetModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionSetModel(
      id: doc.id,
      name: data['name'] ?? '',
      questionCount: data['questionCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'questionCount': questionCount,
    'createdAt': FieldValue.serverTimestamp(),
  };

  // Provide map serialization for local use
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'questionCount': questionCount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory QuestionSetModel.fromMap(Map<String, dynamic> map) {
    return QuestionSetModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      questionCount: (map['questionCount'] ?? 0) is int
          ? map['questionCount']
          : (map['questionCount'] ?? 0).toInt(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}