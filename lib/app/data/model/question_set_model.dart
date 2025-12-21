class QuestionSetModel {
  final String id;
  final String name;        // Tên bộ đề
  final int questionCount;  // Số câu hỏi
  final DateTime createdAt; // Ngày tạo

  QuestionSetModel({
    required this.id,
    required this.name,
    required this.questionCount,
    required this.createdAt,
  });
}