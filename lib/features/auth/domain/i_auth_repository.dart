// features/auth/domain/i_auth_repository.dart
import 'package:cole20/features/auth/domain/email_verification_response.dart';
import 'package:cole20/features/auth/domain/forget_password_response.dart';
import 'package:cole20/features/auth/domain/signup_response.dart';
import 'package:cole20/features/auth/domain/verify_otp_response.dart';

import 'sign_in_response.dart';

abstract class IAuthRepository {
  Future<SignInResponse> signin(String email, String password);

  Future<void> signout();

  Future<SignupResponse> signup(String email, String password, String fullName);

  Future<EmailVerificationResponse> verifyEmail(String otp);

  Future<ForgetPasswordResponse> forgetPassword(String email);

  Future<VerifyOTPResponse> verifyOTP(String otp);

  Future<void> resendOtp();

  Future<void> resetPassword(String password,String confirmPassword);
}
