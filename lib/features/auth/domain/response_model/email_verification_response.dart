// features/auth/domain/email_verification_response.dart
class EmailVerificationResponse {
  final String accessToken;

  EmailVerificationResponse({required this.accessToken});

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return EmailVerificationResponse(
      accessToken: data['accessToken'] as String,
    );
  }
}
