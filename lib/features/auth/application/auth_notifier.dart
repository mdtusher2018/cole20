import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/core/localstorage/session_memory.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'package:cole20/features/auth/domain/repository/i_auth_repository.dart';
import 'package:cole20/features/rituals/presentation/root_page.dart';
import 'package:cole20/main.dart';
import 'package:cole20/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;
  final ILocalStorageService _localStorage;
  final SessionMemory _sessionMemory;

  Timer? _cooldownTimer;

  AuthNotifier(this._repository, this._localStorage, this._sessionMemory)
    : super(AuthState.initial());

  Future<void> signin(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    state = AuthState.loading();
    try {
      final response = await _repository.signin(email, password);

      if (rememberMe) {
        await _localStorage.saveString(StorageKey.token, response.accessToken);
      } else {
        _sessionMemory.setToken(response.accessToken);
      }
      state = AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<bool> signout(WidgetRef ref) async {
    log("Signing out...");
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      final accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        await FacebookAuth.instance.logOut();
      }

      await _localStorage.clearAll();
      _sessionMemory.clear();

      clearAllProviders(ref);
      RootPage.selectedIndex = 0;

      state = AuthState.initial();
      runApp(ProviderScope(child: AppLifecycleHandler(child: const MyApp())));
      return true;
    } catch (e, stack) {
      print("Signout error: $e");
      print(stack);
      state = AuthState.error(e.toString());
      return false;
    }
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

  Future<void> resetPassword(String password, String confirmPassword) async {
    state = AuthState.loading();
    try {
      await _repository.resetPassword(password, confirmPassword);
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
        image,
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

  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = AuthState.error("Google sign-in cancelled");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final response = await _repository.googleSignin(googleAuth.accessToken!);
      await _localStorage.saveString(StorageKey.token, response.accessToken);
      state = AuthState.authenticated();
    } catch (e) {
      log(e.toString());
      state = AuthState.error(e.toString());
    }
  }

  /// Facebook Sign-In
  Future<void> signInWithFacebook({bool rememberMe = false}) async {
    state = AuthState.loading();
    log("1");
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      log("2");

      if (result.status != LoginStatus.success) {
        state = AuthState.error("Facebook sign-in failed");
        return;
      }
      final response = await _repository.facebookSignin(
        result.accessToken!.tokenString,
      );
      await _localStorage.saveString(StorageKey.token, response.accessToken);
      state = AuthState.authenticated();
      state = AuthState.authenticated();
    } catch (e) {
      log(e.toString());
      state = AuthState.error(e.toString());
    }
  }
}
