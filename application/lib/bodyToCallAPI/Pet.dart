class Pet {
  final int? userID;
  final int? petID;
  final String petIMAGE;
  final String petSPECIE;
  final String petNAME;
  final int petAGE;

  Pet({
    required this.userID,
    required this.petID,
    required this.petIMAGE,
    required this.petSPECIE,
    required this.petNAME,
    required this.petAGE,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      userID: json['userID'] ?? 0, // Provide default values if necessary
      petID: json['petID'] ?? 0,
      petIMAGE: json['imageLink'] ?? 'assets/icons/logo.png',
      petSPECIE: json['petSPECIE'] ?? '',
      petNAME: json['petNAME'] ?? '',
      petAGE: json['petAGE'] ?? 0,
    );
  }
  @override
  String toString() {
    return 'Pet(userID: $userID, petID: $petID, petIMAGE: $petIMAGE, petSPECIE: $petSPECIE, petNAME: $petNAME, petAGE: $petAGE)';
  }
}
