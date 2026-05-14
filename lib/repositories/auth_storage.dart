abstract class IAuthStorage {
  Future<void> saveToken(String jsonBody);
  Future<String?> getAuthData();
  Future<void> deleteAuthData();
}