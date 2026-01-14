class AdminOrderList {
  final String orderSTATUS;
  final String username;
  final String orderedDATE;
  final List<OrderSummary> returned;

  AdminOrderList({
    required this.orderSTATUS,
    required this.username,
    required this.orderedDATE,
    required this.returned,
  });

  factory AdminOrderList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data cannot be null');
    }

    final returnedJson = json['returned'] as List<dynamic>? ?? const [];

    return AdminOrderList(
      orderSTATUS: json['orderSTATUS'] ?? 'UNKNOWN',
      username: json['username'] ?? 'UNKNOWN',
      orderedDATE: json['orderedDATE'].toString() ?? 'UNKNOWN',
      returned: returnedJson
          .map((item) => OrderSummary.fromJson(item as Map<String, dynamic>?))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderSTATUS': orderSTATUS,
      'username': username,
      'orderedDATE': orderedDATE,
      'returned': returned.map((order) => order.toJson()).toList(),
    };
  }
}

class OrderSummary {
  final int orderId;
  final String? username;
  final String? status;
  final String? orderedDATE;
  final int? totalQuantity;
  final int? departmentCount;

  OrderSummary({
    required this.orderId,
    this.username,
    this.status,
    this.orderedDATE,
    this.totalQuantity,
    this.departmentCount,
  });

  factory OrderSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON data for OrderSummary cannot be null');
    }

    return OrderSummary(
      orderId: json['orderID'] ?? 0,
      username: json['username'] as String?,
      status: json['orderSTATUS'] as String?,
      orderedDATE: json['orderedDATE'] as String?,
      totalQuantity: json['totalQuantity'] as int?,
      departmentCount: json['departmentCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderId,
      'username': username,
      'status': status,
      'orderedDATE': orderedDATE,
      'totalQuantity': totalQuantity,
      'departmentCount': departmentCount,
    };
  }

  @override
  String toString() {
    return 'OrderSummary(orderId: $orderId, username: $username, status: $status, orderedDATE: $orderedDATE, totalQuantity: $totalQuantity, departmentCount: $departmentCount)';
  }
}

