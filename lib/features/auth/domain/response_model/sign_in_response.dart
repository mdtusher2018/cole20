// features/auth/domain/auth_response.dart
import '../user_model.dart';

class SignInResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  SignInResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      user: User.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
