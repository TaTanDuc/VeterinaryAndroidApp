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
