// features/auth/domain/i_auth_repository.dart
import 'dart:io';

import 'package:cole20/features/auth/domain/response_model/compleate_profile_response.dart';
import 'package:cole20/features/auth/domain/response_model/email_verification_response.dart';
import 'package:cole20/features/auth/domain/response_model/forget_password_response.dart';
import 'package:cole20/features/auth/domain/response_model/signup_response.dart';
import 'package:cole20/features/auth/domain/response_model/verify_otp_response.dart';

import '../response_model/sign_in_response.dart';

abstract class IAuthRepository {
  Future<SignInResponse> signin(String email, String password);

  Future<void> signout();

  Future<SignupResponse> signup(String email, String password, String fullName);

  Future<EmailVerificationResponse> verifyEmail(String otp);

  Future<ForgetPasswordResponse> forgetPassword(String email);

  Future<VerifyOTPResponse> verifyOTP(String otp);

  Future<void> resendOtp();

  Future<void> resetPassword(String password, String confirmPassword);

  Future<CompleteProfileResponse> completeProfile(
     String fullName,
     String phone,
     String gender,
     File? image
  );


  Future<SignInResponse> googleSignin(String token);
  Future<SignInResponse> facebookSignin(String token);


}

