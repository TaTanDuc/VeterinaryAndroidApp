class Invoice {
  final int apmInvoiceID;
  final String method;
  final String paidDate;
  final int total;

  Invoice({
    required this.apmInvoiceID,
    required this.method,
    required this.paidDate,
    required this.total,
  });

  factory Invoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Invoice(
      apmInvoiceID: (json['apmInvoiceID']) ?? 0,
      method: (json['method']) ?? 'unknown',
      paidDate: (json['paidDate']) ?? 'unknown',
      total: json['total'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Appointment(invoiceCODE: $apmInvoiceID, invoiceID: $method, invoiceDATE: $paidDate, total: $total)';
  }
}
