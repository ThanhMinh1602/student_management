class CreateStudentRequest {
  final String fullName;
  final String username;
  final String password;
  final String role;

  CreateStudentRequest({
    required this.fullName,
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "username": username,
    "password": password,
    "role": role,
  };
}
