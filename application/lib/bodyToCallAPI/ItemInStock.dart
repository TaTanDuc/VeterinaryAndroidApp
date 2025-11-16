class ItemInStock {
  final int itemID;
  final String itemName;
  final String categoryName;
  final int price;
  final int quantity;

  ItemInStock({
    required this.itemID,
    required this.itemName,
    required this.categoryName,
    required this.price,
    required this.quantity,
  });

  factory ItemInStock.fromJson(Map<String, dynamic> json) {
    return ItemInStock(
      itemID: json['itemID'] is int
          ? json['itemID']
          : int.tryParse(json['itemID'].toString()) ?? 0,
      itemName: json['itemName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'categoryName': categoryName,
      'quantity': quantity,
      'price': price,
    };
  }
}
