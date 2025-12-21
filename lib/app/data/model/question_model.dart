enum QuestionType {
  multipleChoice, // Loại 1: Trắc nghiệm ABCD
  rearrange,      // Loại 2: Sắp xếp câu
  translate,      // Loại 3: Dịch câu
}

class QuestionModel {
  final String id;
  final String setId; // Thuộc bộ đề nào
  final QuestionType type;
  final String content; // Nội dung câu hỏi
  
  // Dữ liệu tùy biến theo loại
  final List<String>? options; // Dùng cho Trắc nghiệm (4 đáp án)
  final String correctAnswer;  // Đáp án đúng (Trắc nghiệm/Dịch)
  final List<String>? correctOrder; // Dùng cho Sắp xếp

  QuestionModel({
    required this.id,
    required this.setId,
    required this.type,
    required this.content,
    this.options,
    required this.correctAnswer,
    this.correctOrder,
  });

  Map<String, dynamic> toJson() => {
    'setId': setId,
    'type': type.name, // Lưu dạng string: 'multipleChoice'
    'content': content,
    'options': options,
    'correctAnswer': correctAnswer,
    'correctOrder': correctOrder,
  };
}