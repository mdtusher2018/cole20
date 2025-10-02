// features/auth/domain/i_auth_repository.dart
import 'auth_response.dart';

abstract class IAuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
}
