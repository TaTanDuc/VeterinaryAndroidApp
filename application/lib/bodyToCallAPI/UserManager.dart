import 'package:application/bodyToCallAPI/UserDTO.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  String? _username;
  bool? connected;
  int? _id;

  String? get username => _username;
  bool? get connection => connected;
  int? get id => _id;

  void setUsername(String username, bool connection, int id) {
    _username = username;
    connected = connection;
    _id = id;
  }

  void clearUsername() {
    _username = null;
    connected = false;
  }
}
