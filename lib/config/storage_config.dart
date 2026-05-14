
import '../repositories/auth_storage.dart';
import '../repositories/shared_prefs_storage.dart';
import '../repositories/secure_auth_storage.dart';

class StorageConfig {
  static const bool useSecureStorage = false; 

  static IAuthStorage get storage {
    if (useSecureStorage) {
      return SecureAuthStorage();
    } else {
      return SharedPrefsStorage();
    }
  }
}