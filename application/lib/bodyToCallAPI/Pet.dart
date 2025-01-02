class Pet {
  final int? petID;
  final String petIMAGE;
  final String petNAME;
  final String petGENDER;
  final int petAGE;
  final String animal;
  final String petSPECIE;

  Pet({
    required this.petID,
    required this.petIMAGE,
    required this.petNAME,
    required this.petGENDER,
    required this.petAGE,
    required this.animal,
    required this.petSPECIE,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petID: json['petID'] ?? 0,
      petIMAGE: json['imageLink'] ?? 'assets/icons/logo.png',
      petNAME: json['petNAME'] ?? '',
      petGENDER: json['petGENDER'] ?? 'unknown',
      petAGE: json['petAGE'] ?? 0,
      animal: json['animal'] ?? '',
      petSPECIE: json['petSPECIE'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Pet( petID: $petID, petIMAGE: $petIMAGE, petSPECIE: $petSPECIE, petNAME: $petNAME, petAGE: $petAGE, petGENDER: $petGENDER)';
  }
}
