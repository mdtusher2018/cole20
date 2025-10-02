import 'storage_key.dart';

/// Abstract interface (for testability)
abstract class ILocalStorageService {
  Future<void> saveString(StorageKey key, String value);
  Future<String?> getString(StorageKey key);
  Future<void> saveBool(StorageKey key, bool value);
  Future<bool?> getBool(StorageKey key);
  Future<void> remove(StorageKey key);
  Future<void> clearAll();
    Future<Map<String, String>> getSavedLogins();
  Future<void> saveLogin(String email, String password);
  Future<void> removeLogin(String email);
}
