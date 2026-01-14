class Invoice {
  final int apmInvoiceID;
  final String paymentMethod;
  final String paidDate;
  final int total;

  Invoice({
    required this.apmInvoiceID,
    required this.paymentMethod,
    required this.paidDate,
    required this.total,
  });

  factory Invoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Invoice(
      apmInvoiceID: (json['apmInvoiceID']) ?? 0,
      paymentMethod: (json['paymentMethod']) ?? 'unknown',
      paidDate: (json['paidDate']) ?? 'unknown',
      total: json['total'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Appointment(invoiceCODE: $apmInvoiceID, invoiceID: $paymentMethod, invoiceDATE: $paidDate, total: $total)';
  }
}
