import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/api/api_endpoints.dart';
import 'package:blooket/app/data/model/request/register_request.dart';
import 'package:blooket/app/data/model/request/login_request.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<Response> register(RegisterRequest request) async {
    return await _apiClient.post(ApiEndpoints.register, data: request.toJson());
  }

  Future<Response> login(LoginRequest request) async {
    return await _apiClient.post(ApiEndpoints.login, data: request.toJson());
  }

  Future<Response> getCurrentUser() async {
    return await _apiClient.get(ApiEndpoints.me);
  }
}
