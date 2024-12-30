import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Singleton instance
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  static const String _sessionKey = 'SESSION_COOKIE';

  // Save session
  Future<void> saveSession(String session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, session);
    print('Session saved: $session');
  }

  // Retrieve session
  Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  // Clear session
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    print('Session cleared.');
  }
}
