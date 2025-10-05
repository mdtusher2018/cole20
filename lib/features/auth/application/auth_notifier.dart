import 'dart:async';
import 'dart:io';

import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'package:cole20/features/auth/domain/repository/i_auth_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;
  final ILocalStorageService _localStorage; // Injected dependency

  Timer? _cooldownTimer;

  AuthNotifier(this._repository, this._localStorage)
    : super(AuthState.initial());

  Future<void> signin(String email, String password) async {
    state = AuthState.loading();
    try {
      final response = await _repository.signin(email, password);
      await _localStorage.saveString(StorageKey.token, response.accessToken);
      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void signout() {
    state = AuthState.initial();
  }

  Future<void> signup(String email, String password, String fullName) async {
    state = AuthState.loading();
    try {
      final response = await _repository.signup(email, password, fullName);
      await _localStorage.saveString(StorageKey.token, response.accessToken);
      state = AuthState.emailVerificationPending(cooldown: 60);
      _startCooldown();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyEmail(String otp) async {
    state = AuthState.loading();
    try {
      final response = await _repository.verifyEmail(otp);
      await _localStorage.saveString(StorageKey.token, response.accessToken);
      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyOTP(String otp) async {
    state = AuthState.loading();
    try {
      final response = await _repository.verifyOTP(otp);
      await _localStorage.saveString(StorageKey.token, response.accessToken);
      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }



  Future<void> forgetPassword(String email) async {
    state = AuthState.loading();
    try {
      final response = await _repository.forgetPassword(email);
      await _localStorage.saveString(StorageKey.token, response.forgetToken);
      state = AuthState.forgotPassword(cooldown: 60);
      _startCooldown();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> resendOtp() async {
    state = AuthState.loading();
    try {
      await _repository.resendOtp();
      state = AuthState.otpResent(cooldown: 60);
      _startCooldown();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel(); // cancel if already running

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCooldown > 0) {
        state = state.copyWith(resendCooldown: state.resendCooldown - 1);
      } else {
        timer.cancel();
        // Reset back to verification pending (so "Resend" is enabled again)
        state = AuthState.emailVerificationPending();
      }
    });
  }



  Future<void> resetPassword(String password,String confirmPassword) async {
    state = AuthState.loading();
    try {
      await _repository.resetPassword(password,confirmPassword);
      state = AuthState.reset();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }




Future<void> completeProfile({
  required String fullName,
  required String phone,
  required String gender,
  File? image,
}) async {
  state = AuthState.loading();
  try {
    final response = await _repository.completeProfile(
       fullName,
       phone,
       gender,
       image
    );
    state = AuthState.profileCompleted(response);
  } catch (e) {
    state = AuthState.error(e.toString());
  }
}






  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}
