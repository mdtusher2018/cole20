
import 'package:cole20/features/auth/domain/user_model.dart';

class ChangePasswordResponse {
  final User user;
  final bool success;
  final int statusCode;
  final String message;

  ChangePasswordResponse({
    required this.user,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final userJson = data['user'] as Map<String, dynamic>? ?? {};

    return ChangePasswordResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      user: User.fromJson(userJson),
    );
  }
}
