import 'package:blooket/app/data/api/api_client.dart';
import 'package:blooket/app/data/api/api_endpoints.dart';
import 'package:blooket/app/data/model/request/question_request.dart';
import 'package:dio/dio.dart';

class QuestionService {
  final ApiClient _apiClient;

  QuestionService(this._apiClient);

  Future<Response> getAllQuestions({String? setId}) async {
    return await _apiClient.get(
      ApiEndpoints.questions,
      query: setId != null ? {"setId": setId} : null,
    );
  }

  Future<Response> createQuestion(QuestionRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.questions,
      data: request.toJson(),
    );
  }

  Future<Response> getQuestionById(String id) async {
    return await _apiClient.get(ApiEndpoints.questionById(id));
  }

  Future<Response> updateQuestion(String id, QuestionRequest request) async {
    return await _apiClient.put(
      ApiEndpoints.questionById(id),
      data: request.toJson(),
    );
  }

  Future<Response> deleteQuestion(String id) async {
    return await _apiClient.delete(ApiEndpoints.questionById(id));
  }
}
