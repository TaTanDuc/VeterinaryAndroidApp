class ServiceInvoice {
  final String serviceNAME; // Matches the JSON field name
  final int servicePRICE;

  ServiceInvoice({
    required this.serviceNAME,
    required this.servicePRICE,
  });

  factory ServiceInvoice.fromJson(Map<String, dynamic> json) {
    return ServiceInvoice(
      serviceNAME: json['serviceNAME'] ?? 'Unknown',
      servicePRICE: json['servicePRICE'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceNAME': serviceNAME,
      'servicePRICE': servicePRICE,
    };
  }

  @override
  String toString() {
    return 'Service(serviceNAME: $serviceNAME, price: $servicePRICE)';
  }
}
