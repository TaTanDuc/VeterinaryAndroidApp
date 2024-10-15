// class Profile {
//   final int userID;
//   final String profileIMG;
//   final String profileNAME;
//   final String profileEMAIL;
//   final String GENDER;
//   final int AGE;

//   final String PHONE; // List of Pet objects

//   Profile({
//     required this.userID,
//     required this.profileIMG,
//     required this.profileNAME,
//     required this.profileEMAIL,
//     required this.GENDER,
//     required this.AGE,
//     required this.PHONE,
//   });
//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//         userID: json['userID'] ?? 0,
//         profileIMG: json['profileIMG'] ?? 'assets/images/avatar02.jpg',
//         profileNAME: json['profileNAME'] ?? 'Unknown',
//         profileEMAIL: json['profileEMAIL'] ?? 'Unknown',
//         GENDER: json['GENDER'] ?? 'Unknown',
//         AGE: json['AGE'] ?? 0,
//         PHONE: json['PHONE'] ?? 'Unkown and you need to update first');
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'userID': userID,
//       'profileIMG': profileIMG,
//       'profileNAME': profileNAME,
//       'profileEMAIL': profileEMAIL,
//       'AGE': AGE,
//       'PHONE': PHONE,
//       'GENDER': GENDER,
//     };
//   }
// }
class Profile {
  final int userID;
  final String? profileIMG;
  final String profileNAME;
  final String profileEMAIL;
  final String GENDER;
  final int? AGE;
  final String PHONE;

  Profile({
    required this.userID,
    this.profileIMG,
    required this.profileNAME,
    required this.profileEMAIL,
    required this.GENDER,
    required this.AGE,
    required this.PHONE,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        userID: json['userID'] ?? 0,
        profileIMG: json['profileIMG'] ?? 'assets/images/avatar02.jpg',
        profileNAME: json['profileNAME'] ?? 'Unknown',
        profileEMAIL: json['profileEMAIL'] ?? 'Unknown',
        GENDER: json['GENDER'] ?? 'Unknown',
        AGE: json['AGE'] ?? 0,
        PHONE: json['PHONE'] ?? 'Unkown and you need to update first');
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'profileIMG': profileIMG,
      'profileNAME': profileNAME,
      'profileEMAIL': profileEMAIL,
      'GENDER': GENDER,
      'AGE': AGE,
      'PHONE': PHONE,
    };
  }
}
