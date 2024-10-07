class User {
  final int userID;
  final String username;
  final String email;
  final int cartID; // List of Pet objects

  User({
    required this.userID,
    required this.username,
    required this.email,
    required this.cartID,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userID: json['userID'],
        username: json['username'],
        email: json['email'],
        cartID: json['cartID']);
  }
}
