import 'package:blooket/app/data/enum/question_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String id;
  final String setId;
  final QuestionType type;
  final String content;

  // Cấu hình hiển thị
  final int timeLimit; // Thời gian (giây)
  final bool isRandom; // Có xáo trộn đáp án không? (Cho MC/Rearrange)

  // Dữ liệu đáp án
  final List<String>? options; // Danh sách lựa chọn (Cho Multiple Choice)

  // QUAN TRỌNG: Đổi String thành List để hỗ trợ Typing (nhiều đáp án đúng)
  // - Multiple Choice / TrueFalse: List chứa 1 phần tử đúng.
  // - Typing: List chứa nhiều biến thể chấp nhận được.
  // - Rearrange: Có thể dùng cái này hoặc dùng correctOrder riêng.
  final List<String> answers;

  final DateTime? createdAt;

  QuestionModel({
    required this.id,
    required this.setId,
    required this.type,
    required this.content,
    required this.timeLimit, // Bắt buộc
    this.isRandom = false, // Mặc định false
    this.options,
    required this.answers, // Bắt buộc
    this.createdAt,
  });

  // --- 1. FROM SNAPSHOT (Firebase -> App) ---
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

      // Xử lý TimeLimit & Random
      timeLimit: data['timeLimit'] ?? 30, // Mặc định 30s nếu null
      isRandom: data['isRandom'] ?? false,

      // Xử lý List an toàn (tránh lỗi cast)
      options: data['options'] != null
          ? List<String>.from(data['options'])
          : null,

      // Hỗ trợ backward compatibility (nếu data cũ lưu String, data mới lưu List)
      answers: data['answers'] != null
          ? List<String>.from(data['answers'])
          : (data['correctAnswer'] != null
                ? [data['correctAnswer']]
                : []), // Fallback cho data cũ

      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // --- 2. TO JSON (App -> Firebase) ---
  Map<String, dynamic> toJson() {
    return {
      'setId': setId,
      'type': type.name,
      'content': content,
      'timeLimit': timeLimit,
      'isRandom': isRandom,
      if (options != null) 'options': options,
      'answers': answers, // Luôn lưu dưới dạng List
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // --- 3. COPY WITH (Cho Edit State) ---
  QuestionModel copyWith({
    String? id,
    String? setId,
    QuestionType? type,
    String? content,
    int? timeLimit,
    bool? isRandom,
    List<String>? options,
    List<String>? answers,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      type: type ?? this.type,
      content: content ?? this.content,
      timeLimit: timeLimit ?? this.timeLimit,
      isRandom: isRandom ?? this.isRandom,
      options: options ?? this.options,
      answers: answers ?? this.answers,
      createdAt: createdAt,
    );
  }
}
