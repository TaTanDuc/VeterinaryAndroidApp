class Shop {
  final int itemID;
  final String itemIMG;
  final String itemName;
  final String categoryName;
  final double itemRating;
  final int price;
  final int total;

  Shop(
      {required this.itemID,
      required this.itemIMG,
      required this.itemName,
      required this.categoryName,
      required this.itemRating,
      required this.price,
      required this.total});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      itemID: json['itemID'] ?? 0,
      itemIMG: json['itemIMG'] ?? 'assets/icons/logo.png', // Default image
      itemName: json['itemName'] ?? 'Unknown', // Default name
      categoryName: json['categoryName'] ?? 'Unknown', // Default description
      itemRating: json['itemRating'] != null
          ? double.tryParse(json['itemRating'].toString()) ?? 0.0
          : 0.0,
      price: json['price'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
  @override
  String toString() {
    return 'Shop(itemID: $itemID, itemName: $itemName, itemIMG:$itemIMG, categoryName: $categoryName, itemRating: $itemRating, price, $price, total: $total)';
  }
}
