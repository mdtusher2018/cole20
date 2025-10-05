import 'package:cole20/features/auth/domain/repository/i_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'localstorage/local_storage_service.dart';
import 'api/api_client.dart';
import 'api/api_service.dart';
import 'api/i_api_service.dart';
import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/features/auth/application/auth_notifier.dart';
import 'package:cole20/features/auth/application/auth_state.dart';
import 'package:cole20/features/auth/infrastructure/auth_repository.dart';

final Provider<ILocalStorageService> localStorageProvider = Provider<ILocalStorageService>((ref) {
  return LocalStorageService();
});

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final Provider<IApiService> apiServiceProvider = Provider<IApiService>((ref) {
  final client = ref.read(apiClientProvider);
  final storage = ref.read(localStorageProvider);
  return ApiService(client, storage);
});




// Auth Repository Provider
final Provider<IAuthRepository> authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthRepository(apiService);
});

// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  final localStorage = ref.read(localStorageProvider);
  return AuthNotifier(repository, localStorage);
});
