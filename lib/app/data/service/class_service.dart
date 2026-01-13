import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/api/api_endpoints.dart';
import 'package:blooket/app/data/model/request/class_request.dart';
import 'package:dio/dio.dart';

class ClassService {
  final ApiClient _apiClient;

  ClassService(this._apiClient);

  Future<Response> getAllClasses({int page = 1, int limit = 10}) async {
    return await _apiClient.get(
      ApiEndpoints.classes,
      queryParameters: {"page": page, "limit": limit},
    );
  }

  Future<Response> createClass(ClassRequest request) async {
    return await _apiClient.post(ApiEndpoints.classes, data: request.toJson());
  }

  Future<Response> getClassById(String id) async {
    return await _apiClient.get(ApiEndpoints.classById(id));
  }

  Future<Response> updateClass(String id, ClassRequest request) async {
    return await _apiClient.put(
      ApiEndpoints.classById(id),
      data: request.toJson(),
    );
  }

  Future<Response> deleteClass(String id) async {
    return await _apiClient.delete(ApiEndpoints.classById(id));
  }
}
