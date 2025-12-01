class ListInvoice {
  final int purchaseInvoiceID;
  final String userName;
  final String paymentMethod;
  final String createdDate;
  final int total;

  ListInvoice({
    required this.purchaseInvoiceID,
    required this.userName,
    required this.paymentMethod,
    required this.createdDate,
    required this.total,
  });

  factory ListInvoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return ListInvoice(
      purchaseInvoiceID: json['purchaseInvoiceID'] ?? 0,
      userName: (json['userName']).toString() ?? 'Unknown',
      paymentMethod: json['paymentMethod'] ?? 'VISA',
      createdDate: json['createdDate'],
      total: (json['total']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchaseInvoiceID': purchaseInvoiceID,
      'userName': userName,
      'createdDate': createdDate,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'Appointment(purchaseInvoiceID: $purchaseInvoiceID, userName: $userName, createdDate: $createdDate,paymentMethod:$paymentMethod, appointmentTIME: $total)';
  }
}
