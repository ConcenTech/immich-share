import '../models/user.dart';
import 'api_service.dart';
import 'database_service.dart';

class AuthService {
  const AuthService(this._db, this._api);

  final DatabaseService _db;
  final ApiService _api;

  Future<void> setEndpoint(String serverUrl) async {
    final endpoint = await _api.checkAndSetEndpoint(serverUrl);

    if (endpoint == null){
      return;
    }

    await _db.setEndpoint(endpoint);
  }

  Future<bool> checkAuthStatus() async {
    final endpoint = await _db.getEndpoint();
    if (endpoint == null) {
      return false;
    }

    await _api.checkAndSetEndpoint(endpoint.serverUrl);
    return await _api.validateAuthToken();
  }

  Future<User> login(String email, String password) async {
    final user =  await _api.login(email, password);
    // If login flow is triggered by token expiry, 
    // we need to ensure its the same user logging back in.
    final oldUser = await _db.getUser();
    if (oldUser !=null && oldUser != user) {
      await _db.clear();
    }

    await _db.setUser(user);
    return user;
  }

  Future<bool> logout() async {
    final loggedOut = await _api.logout();

    if (loggedOut) {
      await _db.clear();
    }

    return loggedOut;
  }

  /// Gets the currently signed in user, or null if not authenticated.
  Future<User?> currentUser() async {
    final authenticated = await checkAuthStatus();

    if (!authenticated) {
      return null;
    }

    var user = await _db.getUser();

    if (user !=null) {
      return user;
    }

    user = await _api.currentUser();
    await _db.setUser(user);

    return user;
  }

}
