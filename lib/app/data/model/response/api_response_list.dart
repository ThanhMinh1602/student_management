class ApiResponseList<T> {
  final bool success;
  final List<T> data;
  final String message;
  final int total;

  ApiResponseList({
    required this.success,
    required this.data,
    required this.message,
    required this.total,
  });

  factory ApiResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponseList<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      data: json['data'] != null
          ? (json['data'] as List).map((i) => fromJsonT(i)).toList()
          : [],
    );
  }
}
