import 'package:blooket/app/config/network/api_client.dart';
import 'package:blooket/app/config/network/api_endpoints.dart';
import 'package:blooket/app/data/model/set_model.dart';
import 'package:blooket/app/data/model/response/api_response.dart';
import 'package:blooket/app/data/model/request/create_set_request.dart';

class SetService {
  final ApiClient _apiClient;

  SetService(this._apiClient);

  /// Lấy danh sách tất cả các bộ câu hỏi
  /// GET /api/sets
  Future<ApiResponse<List<SetModel>>> listSets() async {
    final response = await _apiClient.get(ApiEndpoints.sets);

    return ApiResponse<List<SetModel>>.fromJson(
      response.data,
      (json) => (json as List).map((e) => SetModel.fromJson(e)).toList(),
    );
  }

  /// Lấy thông tin chi tiết một bộ câu hỏi theo ID
  /// GET /api/sets/{id}
  Future<ApiResponse<SetModel>> getSetById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.sets}/$id');

    return ApiResponse<SetModel>.fromJson(
      response.data,
      (json) => SetModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Tạo một bộ câu hỏi mới
  /// POST /api/sets
  Future<ApiResponse<SetModel>> createSet(CreateSetRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.sets,
      data: request.toJson(),
    );

    return ApiResponse<SetModel>.fromJson(
      response.data,
      (json) => SetModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Cập nhật tên của một bộ câu hỏi
  /// PUT /api/sets/{id}
  Future<ApiResponse<SetModel>> updateSet(String id, String newName) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.sets}/$id',
      data: {"name": newName},
    );

    return ApiResponse<SetModel>.fromJson(
      response.data,
      (json) => SetModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Xóa một bộ câu hỏi và các câu hỏi thuộc bộ đó
  /// DELETE /api/sets/{id}
  Future<ApiResponse<bool>> deleteSet(String id) async {
    final response = await _apiClient.delete('${ApiEndpoints.sets}/$id');

    return ApiResponse<bool>(
      success: response.data['success'] ?? false,
      message: response.data['message'] ?? '',
      data: response.statusCode == 200,
    );
  }
}
