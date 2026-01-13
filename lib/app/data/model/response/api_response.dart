class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;

  ApiResponse({required this.success, this.data, required this.message});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      // Nếu data tồn tại thì map sang Model T, ngược lại trả về null
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
