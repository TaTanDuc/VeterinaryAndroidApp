class AdminPurchaseManagement {
  final String status;
  final int code;
  final List<PurchaseDetail> returned;

  AdminPurchaseManagement({
    required this.status,
    required this.code,
    required this.returned,
  });

  factory AdminPurchaseManagement.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data cannot be null');
    }

    final returnedJson = json['returned'] as List<dynamic>? ?? const [];

    return AdminPurchaseManagement(
      status: json['status'] ?? 'UNKNOWN',
      code: json['code'] ?? 0,
      returned: returnedJson
          .map((item) => PurchaseDetail.fromJson(item as Map<String, dynamic>?))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'returned': returned.map((detail) => detail.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AdminPurchaseManagement(status: $status, code: $code, returned: $returned)';
  }
}

class PurchaseDetail {
  final String itemNAME;
  final int itemQUANTITY;

  PurchaseDetail({
    required this.itemNAME,
    required this.itemQUANTITY,
  });

  factory PurchaseDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data for PurchaseDetail cannot be null');
    }

    return PurchaseDetail(
      itemNAME: json['itemNAME'] ?? 'UNKNOWN',
      itemQUANTITY: json['itemQUANTITY'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemNAME': itemNAME,
      'itemQUANTITY': itemQUANTITY,
    };
  }

  @override
  String toString() {
    return 'PurchaseDetail(itemNAME: $itemNAME, itemQUANTITY: $itemQUANTITY)';
  }
}
