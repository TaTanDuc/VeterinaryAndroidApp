class ItemInvoice {
  final String itemNAME;
  final int price;
  final int itemQUANTITY;

  ItemInvoice({
    required this.itemNAME,
    required this.price,
    required this.itemQUANTITY,
  });

  factory ItemInvoice.fromJson(Map<String, dynamic> json) {
    return ItemInvoice(
      itemNAME: json['itemNAME'] ?? 'Unknown',
      price: json['price'] ?? 0,
      itemQUANTITY: json['itemQUANTITY'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemNAME': itemNAME,
      'price': price,
      'itemQUANTITY': itemQUANTITY,
    };
  }

  @override
  String toString() {
    return 'Service(itemNAME: $itemNAME, price: $price,price: $itemQUANTITY)';
  }
}
