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
  final bool gender;
  final int? age;
  final String phone;

  Profile({
    required this.userID,
    required this.profileIMG,
    required this.profileNAME,
    required this.profileEMAIL,
    required this.gender,
    required this.age,
    required this.phone,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userID: json['userID'] ?? 0, // Ensure this is an int
      profileIMG: json['profileIMG'] ?? 'assets/icons/anonymus.webp',
      profileNAME: json['profileNAME'] ?? 'Unknown',
      profileEMAIL: json['profileEMAIL'] as String,
      gender: json['GENDER'] == 'MALE', // Converts to boolean
      age: json['AGE'] != null ? json['AGE'] as int : null, // Handle null
      phone: json['PHONE'] ?? 'No phone number',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'profileIMG': profileIMG,
      'profileNAME': profileNAME,
      'profileEMAIL': profileEMAIL,
      'gender': gender ? true : false,
      'age': age,
      'phone': phone,
    };
  }
}
