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
  final bool GENDER;
  final int? AGE;
  final String PHONE;

  Profile({
    required this.userID,
    this.profileIMG,
    required this.profileNAME,
    required this.profileEMAIL,
    required this.GENDER,
    required this.AGE,
    this.PHONE = 'No phone number',
  });
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json['userID'] ?? 0, // Ensure this is an int
      profileIMG: json['profileIMG'] as String?,
      profileNAME: json['profileNAME'] as String ?? 'Unknow',
      profileEMAIL: json['profileEMAIL'] as String,
      GENDER: json['gender'] == 'MALE', // Converts to boolean
      AGE: json['age'] != null ? json['AGE'] as int : null, // Handle null
      PHONE: json['phone'] as String? ?? 'No phone number',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'profileIMG': profileIMG,
      'profileNAME': profileNAME,
      'profileEMAIL': profileEMAIL,
      'gender': GENDER ? 'MALE' : 'FEMALE',
      'age': AGE,
      'phone': PHONE,
    };
  }
}
