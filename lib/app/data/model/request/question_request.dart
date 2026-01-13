class QuestionRequest {
  final String? setId; // Chỉ dùng khi Create
  final String? type; // Chỉ dùng khi Create
  final String content;
  final int timeLimit;
  final bool isRandom;
  final List<String> options;
  final List<String> answers;

  QuestionRequest({
    this.setId,
    this.type,
    required this.content,
    required this.timeLimit,
    required this.isRandom,
    required this.options,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "content": content,
      "timeLimit": timeLimit,
      "isRandom": isRandom,
      "options": options,
      "answers": answers,
    };
    // Thêm các trường bắt buộc khi Create nếu chúng tồn tại
    if (setId != null) data["setId"] = setId!;
    if (type != null) data["type"] = type!;
    return data;
  }
}
