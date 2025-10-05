// features/auth/domain/signup_response.dart
class SignupResponse {
  final String accessToken;

  SignupResponse({required this.accessToken});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      accessToken: json['data'] as String,
    );
  }
}
