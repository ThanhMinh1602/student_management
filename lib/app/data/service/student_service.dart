import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/api/api_endpoints.dart';
import 'package:blooket/app/data/model/request/assign_student_request.dart';
import 'package:blooket/app/data/model/request/create_student_request.dart';
import 'package:dio/dio.dart';

class userervice {
  final ApiClient _apiClient;

  userervice(this._apiClient);

  Future<Response> getAlluser({
    String? classId,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiClient.get(
      ApiEndpoints.user,
      query: {
        if (classId != null) "classId": classId,
        "page": page,
        "limit": limit,
      },
    );
  }

  Future<Response> createStudent(CreateStudentRequest request) async {
    return await _apiClient.post(ApiEndpoints.user, data: request.toJson());
  }

  Future<Response> assignToClass(
    String id,
    AssignStudentRequest request,
  ) async {
    return await _apiClient.put(
      ApiEndpoints.assignStudent(id),
      data: request.toJson(),
    );
  }

  Future<Response> removeFromClass(String id) async {
    return await _apiClient.put(ApiEndpoints.removeStudentFromClass(id));
  }

  Future<Response> toggleStatus(String id) async {
    return await _apiClient.put(ApiEndpoints.toggleusertatus(id));
  }

  Future<Response> resetPassword(String id) async {
    return await _apiClient.put(ApiEndpoints.resetStudentPassword(id));
  }

  Future<Response> deleteStudent(String id) async {
    return await _apiClient.delete(ApiEndpoints.studentById(id));
  }
}
