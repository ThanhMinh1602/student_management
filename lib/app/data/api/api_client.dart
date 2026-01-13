import 'package:blooket/app/core/config/remote_config.dart';
import 'package:blooket/app/core/utils/logger.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;

  // Khởi tạo các cấu hình mặc định
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: RemoteConfig.baseUrl, // Thay bằng URL của bạn
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    // Thêm Interceptors (để xử lý log hoặc tự động đính kèm Token)
    // Sử dụng Interceptor để log chuyên nghiệp hơn
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i(
            "🚀 SEND REQUEST[${options.method}] => PATH: ${options.path}",
          );
          // logger.d("Data: ${options.data}"); // Debug dữ liệu gửi đi
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.f(
            "✅ RECEIVE RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}",
          );
          // logger.v("Response Data: ${response.data}"); // Log chi tiết data nhận về
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e(
            "❌ ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}",
          );
          logger.e("Message: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  // Phương thức GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Phương thức POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Thêm vào trong class ApiClient
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Xử lý lỗi tập trung
  String _handleError(DioException error) {
    String errorDescription = "";
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorDescription = "Kết nối quá hạn.";
        break;
      case DioExceptionType.badResponse:
        errorDescription =
            "Lỗi server: ${error.response?.data['message'] ?? error.response?.statusCode}";
        break;
      default:
        errorDescription = "Lỗi không xác định.";
    }

    // Log lỗi chi tiết ra console để dev xem
    logger.w("Handling Error: $errorDescription");
    return errorDescription;
  }
}
