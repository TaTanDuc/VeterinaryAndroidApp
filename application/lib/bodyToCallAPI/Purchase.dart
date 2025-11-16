class Purchase {
  final String userName;
  final String createdDate;
  final int purchaseInvoiceID;
  final String paymentMethod;
  final int total;
  Purchase({
    required this.userName,
    required this.createdDate,
    required this.purchaseInvoiceID,
    required this.paymentMethod,
    required this.total,
  });

  factory Purchase.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Purchase(
      purchaseInvoiceID: json['purchaseInvoiceID'] ?? 0,
      userName: json['userName'] ?? 'Unknown',
      createdDate: json['createdDate'].toString() ?? 'Unknown',
      paymentMethod: json['paymentMethod'] ?? '',
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchaseInvoiceID': purchaseInvoiceID ?? 0,
      'userName': userName ?? 'Unknown',
      'createdDate': createdDate.toString() ?? '',
      'paymentMethod': paymentMethod?.toString() ?? '',
      'total': total ?? 0,
    };
  }

  @override
  String toString() {
    return 'Purchase(purchaseInvoiceID: $purchaseInvoiceID, userName: $userName, createdDate: $createdDate, paymentMethod: $paymentMethod, total: $total)';
  }
}
