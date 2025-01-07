class Service {
  final String serviceCode;
  final String serviceName;
  final double serviceRating;
  final int servicePrice;
  final String workingDate;
  final String imageService;
  final String description;
  Service({
    required this.serviceCode,
    required this.serviceName,
    required this.serviceRating,
    required this.servicePrice,
    required this.workingDate,
    required this.imageService,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Service(
      serviceCode: json['serviceCode'] ?? 'Unknown',
      serviceName: json['serviceName'] ?? 'Unknown',
      serviceRating: json['serviceRating'] ?? 0.0,
      servicePrice: json['servicePrice'] ?? 0,
      workingDate: json['workingDate'] ?? '',
      imageService: json['imageService'] ?? 'assets/icons/logo.png',
      description: json['description'] ?? 'hello',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceCode': serviceCode ?? 'Unknown',
      'serviceName': serviceName ?? 'Unknown',
      'serviceRating': serviceRating ?? 0.0,
      'workingDate': workingDate?.toString() ?? '',
      'imageService': imageService ?? 'Not Found',
      'description': description ?? '0',
    };
  }

  @override
  String toString() {
    return 'Service(serviceCODE: $serviceCode, serviceNAME: $serviceName, serviceRATING: $serviceRating, serviceDATE: $workingDate, imageService: $imageService, userID: $description)';
  }
}
