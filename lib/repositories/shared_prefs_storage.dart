import 'package:shared_preferences/shared_preferences.dart';
import 'auth_storage.dart';

class SharedPrefsStorage implements IAuthStorage {
  final String _key = 'token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  @override
  Future<String?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  @override
  Future<void> deleteAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}