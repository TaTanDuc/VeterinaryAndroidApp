class UserDTO {
  final int userID;
  final String username;
  final String email;
  final int cartID; // List of Pet objects

  UserDTO({
    required this.userID,
    required this.username,
    required this.email,
    required this.cartID,
  });
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
        userID: json['userID'],
        username: json['userNAME'],
        email: json['userEMAIL'],
        cartID: json['cartID']);
  }
}
