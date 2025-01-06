class ServiceInvoice {
  final String serviceName;
  final int servicePRICE;

  ServiceInvoice({
    required this.serviceName,
    required this.servicePRICE,
  });

  factory ServiceInvoice.fromJson(Map<String, dynamic> json) {
    return ServiceInvoice(
      serviceName: json['serviceName'] ?? 'Unknown',
      servicePRICE: json['servicePRICE'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'servicePRICE': servicePRICE,
    };
  }

  @override
  String toString() {
    return 'Service(serviceName: $serviceName, price: $servicePRICE)';
  }
}
