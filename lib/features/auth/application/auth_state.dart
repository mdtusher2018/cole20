enum AuthStatus {
  initial,
  loading,
  emailVerificationPending,
  authenticated,
  forgotPassword,
  otpResent,
  resetPassword,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final int resendCooldown; // ⏳ seconds left before user can resend again

  const AuthState._({
    required this.status,
    this.errorMessage,
    this.resendCooldown = 0,
  });

  // copyWith so you can update parts of the state easily
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    int? resendCooldown,
  }) {
    return AuthState._(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resendCooldown: resendCooldown ?? this.resendCooldown,
    );
  }

  // Factories
  factory AuthState.initial() => const AuthState._(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);
  factory AuthState.emailVerificationPending({int cooldown = 0}) =>
      AuthState._(status: AuthStatus.emailVerificationPending,resendCooldown: cooldown);
  factory AuthState.authenticated() =>
      const AuthState._(status: AuthStatus.authenticated);
  factory AuthState.error(String message) =>
      AuthState._(status: AuthStatus.error, errorMessage: message);
  factory AuthState.forgotPassword({int cooldown = 0}) =>
      AuthState._(status: AuthStatus.forgotPassword,resendCooldown: cooldown);
  factory AuthState.otpResent({int cooldown = 60}) =>
      AuthState._(status: AuthStatus.otpResent, resendCooldown: cooldown);
  factory AuthState.reset() => const AuthState._(status: AuthStatus.resetPassword);

  // Convenience getters
  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isEmailVerificationPending =>
      status == AuthStatus.emailVerificationPending;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isForgotPassword => status == AuthStatus.forgotPassword;
  bool get isOtpResent => status == AuthStatus.otpResent;
  bool get isResetPassword => status == AuthStatus.resetPassword;
  bool get hasError => status == AuthStatus.error;
}
