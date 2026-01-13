import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/api/api_endpoints.dart';
import 'package:blooket/app/data/model/request/set_request.dart';
import 'package:dio/dio.dart';

class SetService {
  final ApiClient _apiClient;

  SetService(this._apiClient);

  Future<Response> getAllSets() async {
    return await _apiClient.get(ApiEndpoints.sets);
  }

  Future<Response> createSet(SetRequest request) async {
    return await _apiClient.post(ApiEndpoints.sets, data: request.toJson());
  }

  Future<Response> getSetById(String id) async {
    return await _apiClient.get(ApiEndpoints.setById(id));
  }

  Future<Response> updateSet(String id, SetRequest request) async {
    return await _apiClient.put(
      ApiEndpoints.setById(id),
      data: request.toJson(),
    );
  }

  Future<Response> deleteSet(String id) async {
    return await _apiClient.delete(ApiEndpoints.setById(id));
  }
}
