class Service {
  final String serviceCODE;
  final String serviceNAME;
  final double serviceRATING;
  final int commentCOUNT;
  final String serviceDATE;
  final String imageService;
  final int userID;

  Service({
    required this.serviceCODE,
    required this.serviceNAME,
    required this.serviceRATING,
    required this.commentCOUNT,
    required this.serviceDATE,
    required this.imageService,
    required this.userID,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceCODE:
          json['serviceCODE'] ?? 0, // Provide default values if necessary
      serviceNAME: json['serviceNAME'] ?? 0,
      serviceRATING: json['serviceRATING'] ?? 0.0,
      commentCOUNT: json['commentCOUNT'] ?? 0,
      serviceDATE: json['serviceDATE'] ?? '',
      imageService: json['imageService'] ?? 'assets/icons/logo.png',
      userID: json['userID'] ?? 0,
    );
  }
  // @override
  // String toString() {
  //   return 'Pet(userID: $serviceCODE, petID: $serviceNAME, petIMAGE: $serviceRATING, petSPECIE: $commentCOUNT, petNAME: $serviceDATE)';
  // }
}
