import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/api/api_endpoints.dart';
import 'package:blooket/app/data/model/request/assign_student_request.dart';
import 'package:blooket/app/data/model/request/create_student_request.dart';
import 'package:dio/dio.dart';

class StudentService {
  final ApiClient _apiClient;

  StudentService(this._apiClient);

  Future<Response> getAllStudents({
    String? classId,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiClient.get(
      ApiEndpoints.students,
      queryParameters: {
        if (classId != null) "classId": classId,
        "page": page,
        "limit": limit,
      },
    );
  }

  Future<Response> createStudent(CreateStudentRequest request) async {
    return await _apiClient.post(ApiEndpoints.students, data: request.toJson());
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
    return await _apiClient.put(ApiEndpoints.toggleStudentStatus(id));
  }

  Future<Response> resetPassword(String id) async {
    return await _apiClient.put(ApiEndpoints.resetStudentPassword(id));
  }

  Future<Response> deleteStudent(String id) async {
    return await _apiClient.delete(ApiEndpoints.studentById(id));
  }
}
