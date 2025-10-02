// features/auth/infrastructure/auth_repository.dart
import '../../../core/api/i_api_service.dart';
import '../../../core/apiEndPoints.dart';
import '../domain/auth_response.dart';
import '../domain/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final IApiService _api;

  AuthRepository(this._api);

  @override
  Future<AuthResponse> login(String email, String password) async {
    final res = await _api.post(
      ApiEndpoints.login,
      {
        "email": email,
        "password": password,
      },
    );

    return AuthResponse.fromJson(res['data']);
  }

  @override
  Future<void> logout() async {}
}
