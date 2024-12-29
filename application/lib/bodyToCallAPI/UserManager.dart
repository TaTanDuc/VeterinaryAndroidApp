import 'package:application/bodyToCallAPI/UserDTO.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  UserDTO? _user;

  UserDTO? get user => _user;

  void setUser(UserDTO user) {
    _user = user;
  }

  void clearUser() {
    _user = null;
  }
}
