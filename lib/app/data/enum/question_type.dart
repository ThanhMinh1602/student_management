enum QuestionType {
  // 1. Khai báo các trường hợp (Cases)
  multipleChoice('Trắc nghiệm', 'multiple_choice'),
  trueFalse('Đúng / Sai', 'true_false'),
  typing('Nhập câu trả lời', 'typing'),
  rearrange('Sắp xếp câu', 'rearrange'),
  
  // Giá trị mặc định
  unknown('Không xác định', 'unknown'); 

  // 2. Khai báo thuộc tính
  final String title;
  final String value;

  // 3. Constructor
  const QuestionType(this.title, this.value);

  // 4. Hàm lấy Enum từ String value
  static QuestionType fromValue(String? value) {
    return QuestionType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => QuestionType.unknown,
    );
  }
}