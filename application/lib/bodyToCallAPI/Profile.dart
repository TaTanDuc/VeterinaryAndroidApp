class Profile {
  final String? profileIMG;
  final String profileNAME;
  final String? Email;
  final String profileGENDER;
  final int? profileAGE;
  final String phone;

  Profile({
    required this.profileIMG,
    required this.profileNAME,
    required this.Email,
    required this.profileGENDER,
    required this.profileAGE,
    required this.phone,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileIMG: json['profileIMG'] ?? 'assets/icons/anonymus.webp',
      profileNAME: json['profileNAME'] ?? 'Unknown',
      Email: json['Email'] as String ?? '',
      profileGENDER: json['profileGENDER'] ?? 'Unknown',
      profileAGE: json['profileAGE'] != null ? json['profileAGE'] as int : null,
      phone: json['phone'] ?? 'No phone number',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileIMG': profileIMG,
      'profileNAME': profileNAME,
      'Email': Email,
      'profileGENDER': profileGENDER,
      'profileAGE': profileAGE,
      'phone': phone,
    };
  }

  @override
  String toString() {
    return 'Profile(profileNAME: $profileNAME, profileIMG: $profileIMG, email: $Email, profileGENDER: $profileGENDER,profileAGE: $profileAGE, phone: $phone)';
  }
}
