class CreateSetRequest {
  final String name;

  CreateSetRequest({required this.name});

  // Chuyển sang JSON để gửi lên Server
  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
