enum AuthStatus {
  initial,
  loading,
  emailVerificationPending,
  authenticated,
  forgotPassword,
  otpResent,
  error,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState._({required this.status, this.errorMessage});

  // Factories
  factory AuthState.initial() => const AuthState._(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);
  factory AuthState.emailVerificationPending() =>
      const AuthState._(status: AuthStatus.emailVerificationPending);
  factory AuthState.authenticated() =>
      const AuthState._(status: AuthStatus.authenticated);
  factory AuthState.error(String message) =>
      AuthState._(status: AuthStatus.error, errorMessage: message);
  factory AuthState.forgotPassword() =>
      AuthState._(status: AuthStatus.forgotPassword);
  factory AuthState.otpResent() =>
      const AuthState._(status: AuthStatus.otpResent);

  // Convenience getters
  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isEmailVerificationPending =>
      status == AuthStatus.emailVerificationPending;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isForgotPassword => status == AuthStatus.forgotPassword;
  bool get isOtpResent => status == AuthStatus.otpResent;
  bool get hasError => status == AuthStatus.error;
}
