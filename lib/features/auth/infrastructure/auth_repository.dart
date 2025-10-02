// features/auth/infrastructure/auth_repository.dart
import 'package:cole20/features/auth/domain/email_verification_response.dart';
import 'package:cole20/features/auth/domain/forget_password_response.dart';
import 'package:cole20/features/auth/domain/signup_response.dart';

import '../../../core/api/i_api_service.dart';
import '../../../core/apiEndPoints.dart';
import '../domain/sign_in_response.dart';
import '../domain/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final IApiService _api;

  AuthRepository(this._api);

  @override
  Future<SignInResponse> signin(String email, String password) async {
    final res = await _api.post(ApiEndpoints.signin, {
      "email": email,
      "password": password,
    });

    return SignInResponse.fromJson(res['data']);
  }

  @override
  Future<void> signout() async {}

  @override
  Future<SignupResponse> signup(
    String email,
    String password,
    String fullName,
  ) async {
    final res = await _api.post(ApiEndpoints.signup, {
      "email": email,
      "password": password,
      "fullName": fullName,
    });

    return SignupResponse.fromJson(res);
  }

  @override
  Future<EmailVerificationResponse> verifyEmail(String otp) async {
    final res = await _api.post(ApiEndpoints.verifyEmail, {"otp": otp});
    return EmailVerificationResponse.fromJson(res);
  }

  @override
  Future<ForgetPasswordResponse> forgetPassword(String email) async {
    final res = await _api.post(ApiEndpoints.forgetPassword, {"email": email});
    return ForgetPasswordResponse.fromJson(res['data']);
  }

  @override
  Future<void> resendOtp() async {
    await _api.patch(
      ApiEndpoints.resendOTP,{}
    );
    // response only contains success + message, no data to return
  }
}
