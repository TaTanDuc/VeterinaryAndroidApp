class ServiceInvoice {
  final String serviceNAME; // Matches the JSON field name
  final int servicePRICE;

  ServiceInvoice({
    required this.serviceNAME,
    required this.servicePRICE,
  });

  factory ServiceInvoice.fromJson(Map<String, dynamic> json) {
    return ServiceInvoice(
      serviceNAME: json['serviceName'] ?? 'Unknown',
      servicePRICE: json['servicePRICE'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceNAME,
      'servicePRICE': servicePRICE,
    };
  }

  @override
  String toString() {
    return 'Service(serviceNAME: $serviceNAME, price: $servicePRICE)';
  }
}
