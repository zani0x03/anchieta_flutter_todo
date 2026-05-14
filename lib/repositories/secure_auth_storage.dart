import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_storage.dart';

class SecureAuthStorage implements IAuthStorage {
  final _storage = const FlutterSecureStorage();
  final String _key = 'token';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  @override
  Future<String?> getAuthData() async {
    return await _storage.read(key: _key);
  }

  @override
  Future<void> deleteAuthData() async {
    await _storage.delete(key: _key);
  }
}