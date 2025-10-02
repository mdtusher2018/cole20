import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'package:cole20/features/auth/domain/i_auth_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;
  final ILocalStorageService _localStorage; // Injected dependency

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
      state = AuthState.emailVerificationPending();
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

  Future<void> forgetPassword(String email) async {
    state = AuthState.loading();
    try {
      final response = await _repository.forgetPassword(email);
      await _localStorage.saveString(StorageKey.token, response.forgetToken);

      state = AuthState.forgotPassword();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // features/auth/application/auth_notifier.dart
  Future<void> resendOtp() async {
    state = AuthState.loading();
    try {
      await _repository.resendOtp();
      state = AuthState.otpResent(); // 🔥 update state
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
