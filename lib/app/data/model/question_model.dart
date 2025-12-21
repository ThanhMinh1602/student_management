import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionType {
  multipleChoice, // Trắc nghiệm
  rearrange,      // Sắp xếp câu
  translate,      // Dịch câu
}

class QuestionModel {
  final String id;
  final String setId;
  final QuestionType type;
  final String content; 
  
  final List<String>? options; // Null nếu không phải trắc nghiệm
  final String correctAnswer;  // Đáp án text
  final List<String>? correctOrder; // Đáp án list (cho sắp xếp)
  
  final DateTime? createdAt; 

  QuestionModel({
    required this.id,
    required this.setId,
    required this.type,
    required this.content,
    this.options,
    required this.correctAnswer,
    this.correctOrder,
    this.createdAt,
  });

  // Convert từ Firebase về Model
  factory QuestionModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return QuestionModel(
      id: doc.id,
      setId: data['setId'] ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.name == (data['type'] ?? 'multipleChoice'),
        orElse: () => QuestionType.multipleChoice,
      ),
      content: data['content'] ?? '',
      options: data['options'] != null ? List<String>.from(data['options']) : null,
      correctAnswer: data['correctAnswer'] ?? '',
      correctOrder: data['correctOrder'] != null ? List<String>.from(data['correctOrder']) : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert từ Model lên Firebase
  Map<String, dynamic> toJson() {
    return {
      'setId': setId,
      'type': type.name,
      'content': content,
      if (options != null) 'options': options,
      'correctAnswer': correctAnswer,
      if (correctOrder != null) 'correctOrder': correctOrder,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // CopyWith để dùng cho chức năng Sửa
  QuestionModel copyWith({
    String? id,
    String? setId,
    QuestionType? type,
    String? content,
    List<String>? options,
    String? correctAnswer,
    List<String>? correctOrder,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      type: type ?? this.type,
      content: content ?? this.content,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      correctOrder: correctOrder ?? this.correctOrder,
      createdAt: this.createdAt,
    );
  }
}