import '../user_model.dart';

class AuthResponseModel {
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;

  AuthResponseModel({this.accessToken, this.refreshToken, this.user});

  // Chuyển từ JSON trong trường "data" sang AuthResponseModel
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      // Nếu trường user tồn tại thì map tiếp sang UserModel
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  // Chuyển ngược lại Map (nếu cần lưu cả cục này vào Storage)
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
    };
  }
}
