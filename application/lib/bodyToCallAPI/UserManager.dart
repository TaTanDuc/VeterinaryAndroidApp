import 'package:application/bodyToCallAPI/UserDTO.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  String? _username;
  bool? connected;

  String? get username => _username;
  bool? get connection => connected;

  void setUsername(String username, bool connection) {
    _username = username;
    connected = connection;
  }

  void clearUsername() {
    _username = null;
    connected = false;
  }
}
