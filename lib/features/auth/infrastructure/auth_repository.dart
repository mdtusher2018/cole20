// features/auth/infrastructure/auth_repository.dart
import 'dart:io';

import 'package:cole20/features/auth/domain/response_model/compleate_profile_response.dart';
import 'package:cole20/features/auth/domain/response_model/email_verification_response.dart';
import 'package:cole20/features/auth/domain/response_model/forget_password_response.dart';
import 'package:cole20/features/auth/domain/response_model/signup_response.dart';
import 'package:cole20/features/auth/domain/response_model/verify_otp_response.dart';

import '../../../core/api/i_api_service.dart';
import '../../../core/apiEndPoints.dart';
import '../domain/response_model/sign_in_response.dart';
import '../domain/repository/i_auth_repository.dart';

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
  Future<VerifyOTPResponse> verifyOTP(String otp) async {
    final res = await _api.patch(ApiEndpoints.verifyOTP, {"otp": otp});
    return VerifyOTPResponse.fromJson(res);
  }

  @override
  Future<void> resendOtp() async {
    await _api.patch(ApiEndpoints.resendOTP, {});
  }

  @override
  Future<void> resetPassword(String password, String confirmPassword) async {
    await _api.patch(ApiEndpoints.resetPassword, {
      "newPassword": password,
      "confirmPassword": confirmPassword,
    });
  }

  @override
  Future<CompleteProfileResponse> completeProfile(
    String fullName,
    String phone,
    String gender,
    File? image,
  ) async {
    final res = await _api.multipart(
      ApiEndpoints.completeProfile,
      method: "PATCH",
      body: {"fullName": fullName, "phone": phone, "gender": gender},
      files: {if (image != null) "image": image},
    );

    return CompleteProfileResponse.fromJson(res);
  }

  @override
  Future<SignInResponse> facebookSignin(String token) async{
    final res = await _api.post(ApiEndpoints.facebookSignin, {"accessToken": token});
  
    return SignInResponse.fromJson(res['data']);
  }

  @override
  Future<SignInResponse> googleSignin(String token) async {
    final res = await _api.post(ApiEndpoints.googleSignin, {"accessToken": token});
  
    return SignInResponse.fromJson(res['data']);
  }
  
  @override
  Future<void> signout() async{
    
  }
}
