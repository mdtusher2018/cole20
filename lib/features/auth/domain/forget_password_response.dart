// features/auth/domain/forget_password_response.dart
class ForgetPasswordResponse {
  final String forgetToken;

  ForgetPasswordResponse({required this.forgetToken});

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      forgetToken: json['forgetToken'],
    );
  }
}
