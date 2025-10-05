import '../user_model.dart';

class CompleteProfileResponse {
  final User user;
  final String message;
  final bool success;
  final int statusCode;

  CompleteProfileResponse({
    required this.user,
    required this.message,
    required this.success,
    required this.statusCode,
  });

  factory CompleteProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompleteProfileResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      user: User.fromJson(json['data'] ?? {}),
    );
  }
}
