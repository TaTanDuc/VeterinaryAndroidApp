class AdminOrderManagement {
  final String status;
  final int code;
  final List<OrderDetail> returned;

  AdminOrderManagement({
    required this.status,
    required this.code,
    required this.returned,
  });

  factory AdminOrderManagement.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data cannot be null');
    }

    final returnedJson = json['returned'] as List<dynamic>? ?? const [];

    return AdminOrderManagement(
      status: json['status'] ?? 'UNKNOWN',
      code: json['code'] ?? 0,
      returned: returnedJson
          .map((item) => OrderDetail.fromJson(item as Map<String, dynamic>?))
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
    return 'AdminOrderManagement(status: $status, code: $code, returned: $returned)';
  }
}

class OrderDetail {
  final String departmentName;
  final int storageId;
  final int itemId;
  final String itemName;
  final int itemQuantity;

  OrderDetail({
    required this.departmentName,
    required this.storageId,
    required this.itemId,
    required this.itemName,
    required this.itemQuantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data for OrderDetail cannot be null');
    }

    return OrderDetail(
      departmentName: json['departmentNAME'] ?? 'UNKNOWN',
      storageId: json['storageID'] ?? 0,
      itemId: json['itemID'] ?? 0,
      itemName: json['itemNAME'] ?? 'UNKNOWN',
      itemQuantity: json['itemQuantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departmentNAME': departmentName,
      'storageID': storageId,
      'itemID': itemId,
      'itemNAME': itemName,
      'itemQuantity': itemQuantity,
    };
  }

  @override
  String toString() {
    return 'OrderDetail(departmentName: $departmentName, storageId: $storageId, itemId: $itemId, itemName: $itemName, itemQuantity: $itemQuantity)';
  }
}

