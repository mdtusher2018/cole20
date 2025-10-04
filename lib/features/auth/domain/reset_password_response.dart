// features/auth/domain/email_verification_response.dart
import 'package:cole20/features/auth/domain/user_model.dart';

class ResetPasswordResponse {
  final User user;

  ResetPasswordResponse({required this.user});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      user: User.fromJson(json['data']),
    );
  }
}
