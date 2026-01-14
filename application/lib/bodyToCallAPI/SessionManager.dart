import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Singleton instance
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  static const String _sessionKey = 'SESSION_COOKIE';
  static const String _userRoleKey = 'USER_ROLE';
  static const String _isAdminKey = 'IS_ADMIN';
  static const String _userEmailKey = 'USER_EMAIL';

  // Save session with role
  Future<void> saveSession(String session,
      {String? role, String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, session);

    if (role != null) {
      await prefs.setString(_userRoleKey, role);
      await prefs.setBool(_isAdminKey, _isAdminRole(role));
    }

    if (email != null) {
      await prefs.setString(_userEmailKey, email);
    }

    print('Session saved: $session, Role: $role');
  }

  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  // Get user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminKey) ?? false;
  }

  // Get user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Check if role is admin
  bool _isAdminRole(String role) {
    return role == 'ADMIN' || role == 'MANAGER' || role == 'EMPLOYEE';
  }

  // Check if user has admin access
  Future<bool> hasAdminAccess() async {
    final isAdmin = await this.isAdmin();
    final role = await getUserRole();
    return isAdmin &&
        (role == 'ADMIN' || role == 'MANAGER' || role == 'EMPLOYEE');
  }

  // Clear session
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_isAdminKey);
    await prefs.remove(_userEmailKey);
    print('Session cleared.');
  }

  // Clear only admin session (keep user session)
  Future<void> clearAdminSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isAdminKey);
    print('Admin session cleared.');
  }
}
