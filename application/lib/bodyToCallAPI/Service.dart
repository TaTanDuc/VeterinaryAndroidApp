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

  factory Service.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Service(
      serviceCODE: json['serviceCODE'] ??
          'Unknown', // Provide default values if necessary
      serviceNAME: json['serviceNAME'] ?? 'Unknown',
      serviceRATING: json['serviceRATING'] ?? 0.0,
      commentCOUNT: json['commentCOUNT'] ?? 0,
      serviceDATE: json['serviceDATE'] ?? '',
      imageService: json['imageService'] ?? 'assets/icons/logo.png',
      userID: json['userID'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceCODE':
          serviceCODE ?? 'Unknown', // Provide a default value if null
      'serviceNAME': serviceNAME ?? 'Unknown',
      'serviceRATING': serviceRATING ?? 0.0, // Example: use 0 if rating is null
      'commentCOUNT': commentCOUNT ?? 0,
      'serviceDATE':
          serviceDATE?.toString() ?? '', // Convert to String if necessary
      'imageService': imageService ?? 'Not Found',
      'userID': userID ?? '0',
    };
  }

  @override
  String toString() {
    return 'Service(serviceCODE: $serviceCODE, serviceNAME: $serviceNAME, serviceRATING: $serviceRATING, commentCOUNT: $commentCOUNT, serviceDATE: $serviceDATE, imageService: $imageService, userID: $userID)';
  }
}
