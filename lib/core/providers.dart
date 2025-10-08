import 'package:cole20/core/localstorage/session_memory.dart';
import 'package:cole20/features/auth/domain/repository/i_auth_repository.dart';
import 'package:cole20/features/meditation/application/notification_notifier.dart';
import 'package:cole20/features/meditation/application/notification_state.dart';
import 'package:cole20/features/meditation/infrastructure/notification_repository.dart';
import 'package:cole20/features/rituals/application/homepage_notifier.dart';
import 'package:cole20/features/rituals/application/homepage_state.dart';
import 'package:cole20/features/rituals/domain/repository/i_ritual_repository.dart';
import 'package:cole20/features/rituals/infrastructure/ritual_repository.dart';
import 'package:cole20/features/profile/application/profile_notifier.dart';
import 'package:cole20/features/profile/application/profile_state.dart';
import 'package:cole20/features/profile/domain/repository/i_profile_repository.dart';
import 'package:cole20/features/profile/infrastructure/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

final sessionMemoryProvider = Provider<SessionMemory>((ref) {
  return SessionMemory();
});

final Provider<ILocalStorageService> localStorageProvider =
    Provider<ILocalStorageService>((ref) {
      return LocalStorageService();
    });

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final Provider<IApiService> apiServiceProvider = Provider<IApiService>((ref) {
  final client = ref.read(apiClientProvider);
  final storage = ref.read(localStorageProvider);
  final sessionMemory = ref.read(sessionMemoryProvider);
  return ApiService(client, storage, sessionMemory);
});

// FirebaseAuth provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Auth Repository Provider
final Provider<IAuthRepository> authRepositoryProvider =
    Provider<IAuthRepository>((ref) {
      final apiService = ref.read(apiServiceProvider);

      return AuthRepository(apiService);
    });

// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final repository = ref.read(authRepositoryProvider);
  final localStorage = ref.read(localStorageProvider);
  final sessionMemory = ref.read(sessionMemoryProvider);
  
  return AuthNotifier(repository, localStorage, sessionMemory);
});

// profile repository provider
final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final api = ref.read(apiServiceProvider); 
  return ProfileRepository(api);
});

// profile notifier provider
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      final repo = ref.read(profileRepositoryProvider);
      return ProfileNotifier(repo);
    });

final ritualRepositoryProvider = Provider.family<IRitualRepository, int>((
  ref,
  day,
) {
  final api = ref.read(apiServiceProvider);
  return RitualRepository(api);
});

final homePageNotifierProvider =
    StateNotifierProvider.family<HomePageNotifier, HomepageState, int>((
      ref,
      day,
    ) {
      final repo = ref.read(ritualRepositoryProvider(day));
      final localStorage = ref.read(localStorageProvider);
      return HomePageNotifier(repo, localStorage);
    });

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final api = ref.read(apiServiceProvider);
  return NotificationRepository(api);
});

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final repo = ref.read(notificationRepositoryProvider);
      return NotificationNotifier(repo);
    });
