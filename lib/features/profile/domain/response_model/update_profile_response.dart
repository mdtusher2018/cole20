
import 'package:cole20/features/auth/domain/user_model.dart';

class UpdateProfileResponse {
  final User user;
  final bool success;
  final int statusCode;
  final String message;

  UpdateProfileResponse({
    required this.user,
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return UpdateProfileResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      user: User.fromJson(data),
    );
  }
}
