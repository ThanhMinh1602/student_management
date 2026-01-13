enum UserRole {
  // 1. Khai báo các trường hợp (Cases)
  admin('Quản trị viên', 'admin'),
  teacher('Giáo viên', 'teacher'),
  student('Học sinh', 'student');

  // 2. Khai báo thuộc tính
  final String title;
  final String value;

  // 3. Constructor
  const UserRole(this.title, this.value);

  // 4. Hàm lấy Enum từ String value (Dùng khi map từ JSON)
  static UserRole fromValue(String? value) {
    return UserRole.values.firstWhere(
      (element) => element.value == value,
      orElse: () => UserRole.student, // Mặc định là student nếu không khớp
    );
  }
}
