// features/auth/domain/email_verification_response.dart
class VerifyOTPResponse {
  final String accessToken;

  VerifyOTPResponse({required this.accessToken});

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOTPResponse(
      accessToken: json['data'] as String,
    );
  }
}
