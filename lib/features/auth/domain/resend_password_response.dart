// features/auth/domain/forget_password_response.dart
class ResendOtpResponse {
  final String forgetToken;

  ResendOtpResponse({required this.forgetToken});

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      forgetToken: json['forgetToken'],
    );
  }
}
