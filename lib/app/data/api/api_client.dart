import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart'; // Giả định bạn dùng GetStorage để lưu token
import 'package:blooket/app/core/config/remote_config.dart';
import 'package:blooket/app/core/utils/logger.dart';

class ApiClient {
  late Dio _dio;
  final storage = GetStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: RemoteConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 1. Tự động đính kèm Access Token vào Header (trừ khi gọi refresh)
          final token = storage.read('accessToken');
          if (token != null && !options.path.contains('/refresh')) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          _logError(e);

          // 2. Xử lý Refresh Token tự động khi gặp lỗi 401
          if (e.response?.statusCode == 401 &&
              storage.hasData('refreshToken') &&
              !e.requestOptions.path.contains('/refresh')) {
            final bool isRefreshed = await _handleRefreshToken();

            if (isRefreshed) {
              // Retry request cũ với token mới
              final options = e.requestOptions;
              options.headers['Authorization'] =
                  'Bearer ${storage.read('accessToken')}';

              final response = await _dio.fetch(options);
              return handler.resolve(response);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  // ============================ LOGGING METHODS ============================

  void _logRequest(RequestOptions options) {
    logger.i("🚀 SEND [${options.method}] => ${options.path}");
    if (options.data != null) {
      try {
        final prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(options.data);
        logger.d("📦 Payload:\n$prettyJson");
      } catch (_) {
        logger.d("📦 Payload: ${options.data}");
      }
    }
  }

  void _logResponse(Response response) {
    logger.f(
      "✅ RECEIVE [${response.statusCode}] <= ${response.requestOptions.path}",
    );
    try {
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(response.data);
      logger.v("Body:\n$prettyJson"); // logger.v để in JSON chi tiết
    } catch (_) {
      logger.v("Body: ${response.data}");
    }
  }

  void _logError(DioException e) {
    logger.e("❌ ERROR [${e.response?.statusCode}] <= ${e.requestOptions.path}");
    if (e.response?.data != null) {
      try {
        final prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(e.response?.data);
        logger.w("Error Detail:\n$prettyJson");
      } catch (_) {
        logger.w("Error Detail: ${e.response?.data}");
      }
    }
  }

  // ============================ REFRESH TOKEN LOGIC ============================

  Future<bool> _handleRefreshToken() async {
    try {
      final rt = storage.read('refreshToken');
      // Sử dụng một instance Dio mới để tránh bị lặp vô hạn interceptor
      final response = await Dio().post(
        "${RemoteConfig.baseUrl}/api/auth/refresh",
        data: {'refreshToken': rt},
      );

      if (response.statusCode == 200) {
        final newAt = response.data['data']['accessToken'];
        // Nếu BE trả về cả RT mới thì cập nhật luôn (Rotation)
        final newRt = response.data['data']['refreshToken'];

        await storage.write('accessToken', newAt);
        if (newRt != null) await storage.write('refreshToken', newRt);

        logger.i("🔄 Token refreshed successfully");
        return true;
      }
    } catch (e) {
      logger.e("🔄 Refresh token failed, logging out...");
      storage.erase(); // Xóa sạch và bắt đăng nhập lại
    }
    return false;
  }

  // ============================ REST METHODS ============================

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

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

  String _handleError(DioException error) {
    if (error.type == DioExceptionType.badResponse) {
      return error.response?.data['message'] ?? "Lỗi server";
    }
    return "Lỗi kết nối mạng";
  }
}
