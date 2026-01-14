class Item {
  final int itemID;
  final String itemIMAGE;
  final String itemName;
  final String categoryName;
  final double itemRating;
  final int price;

  Item({
    required this.itemID,
    required this.itemIMAGE,
    required this.itemName,
    required this.categoryName,
    required this.itemRating,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemID: json['itemID'] is int
          ? json['itemID']
          : int.tryParse(json['itemID'].toString()) ?? 0,
      itemIMAGE: json['itemIMAGE'] ??
          'http://10.0.2.2:8080/api/image/getItem?name=defaultItemIMG.png',
      itemName: json['itemName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      itemRating: json['itemRating'] is double
          ? json['itemRating']
          : double.tryParse(json['double'].toString()) ?? 0.0,
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemID': itemID,
      'itemIMAGE': itemIMAGE,
      'itemName': itemName,
      'categoryName': categoryName,
      'itemRating': itemRating,
      'price': price,
    };
  }
}
