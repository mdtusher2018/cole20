import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/core/localstorage/session_memory.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'package:cole20/features/auth/domain/repository/i_auth_repository.dart';
import 'package:cole20/features/rituals/presentation/root_page.dart';
import 'package:cole20/utils/helpers.dart';
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
      // await _localStorage.saveString(StorageKey.token, response.accessToken);
      if (rememberMe) {
        // Save token persistently
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
    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await _localStorage.clearAll();
      _sessionMemory.clear();

      clearAllProviders(ref);

      state = AuthState.initial();

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
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status != LoginStatus.success) {
        state = AuthState.error("Facebook sign-in failed");
        return;
      }

      state = AuthState.authenticated();
    } catch (e) {
      log("googleUser".toString());
      state = AuthState.error(e.toString());
    }
  }
}









 // Future<void> loginWithGoogle() async {
  //   isLoading.value = true;
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) return; // user canceled
  //
  //     var name = googleUser.displayName;
  //     var image = googleUser.photoUrl;
  //     var email = googleUser.email;
  //     var role = PrefsHelper.myRole;
  //
  //     log(">>>>>>>>>> Name : $name");
  //     log(">>>>>>>>>> email : $email");
  //     log(">>>>>>>>>> image : $image");
  //     log(">>>>>>>>>> role : $role");
  //
  //     var body = {
  //       "email": email,
  //       "name": name ,
  //       "profileImage": image,
  //       "role": role,
  //     };
  //
  //     final response = await authRepository.loginWithGoogle(body);
  //     if (response.statusCode == 200) {
  //       if (response.data['user']['role'] != PrefsHelper.myRole) {
  //         Get.snackbar(
  //           "Access Denied",
  //           "You're trying to log in as a ${response.data['user']['role']}, but this portal is intended for ${PrefsHelper.myRole} access.",
  //         );
  //         return;
  //       }
  //
  //       _handleSuccessfulLogin(response);
  //        Get.to(
  //         LocationPermissionScreen(
  //
  //           parentBusiness: response.data['user']['parentBusiness'],
  //         ),
  //       );
  //     } else {
  //       Get.snackbar("Error".tr,response.message);
  //     }
  //   } catch (e, s) {
  //     log("Google Sign-In Error: $e");
  //     log("StackTrace: $s");
  //     Get.snackbar("Google Sign-In Failed", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }





