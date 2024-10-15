class Invoice {
  final String invoiceCODE;
  final String invoiceID;
  final String invoiceDATE;
  final String total;

  Invoice({
    required this.invoiceCODE,
    required this.invoiceID,
    required this.invoiceDATE,
    required this.total,
  });

  factory Invoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Invoice(
      invoiceCODE: (json['invoiceCODE']).toString() ??
          'Unknown', // Provide default values if necessary
      invoiceID: (json['invoiceID']).toString() ?? '0',
      invoiceDATE: (json['invoiceDATE']).toString() ?? '0000-00-00',
      total: (json['total']).toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceCODE': invoiceCODE,
      'invoiceID': int.parse(invoiceID),
      'invoiceDATE': invoiceDATE,
      'total': int.parse(total),
    };
  }

  @override
  String toString() {
    return 'Appointment(invoiceCODE: $invoiceCODE, invoiceID: $invoiceID, invoiceDATE: $invoiceDATE, total: $total)';
  }
}
