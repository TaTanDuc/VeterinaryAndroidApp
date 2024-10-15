class Shop {
  final String itemIMAGE;
  final String itemNAME;
  final String itemDESCRIPTION;
  final int itemPRICE;

  Shop({
    required this.itemIMAGE,
    required this.itemNAME,
    required this.itemDESCRIPTION,
    required this.itemPRICE,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      itemIMAGE: json['itemIMAGE'] ?? 'assets/icons/logo.png', // Default image
      itemNAME: json['itemNAME'] ?? 'Unknown', // Default name
      itemDESCRIPTION:
          json['itemDESCRIPTION'] ?? 'Unknown', // Default description
      itemPRICE: json['itemPRICE'] != null
          ? int.tryParse(json['itemPRICE'].toString()) ?? 0
          : 0, // Safe price parsing with default
    );
  }
  @override
  String toString() {
    return 'Shop(itemIMAGE: $itemIMAGE, itemNAME: $itemNAME, itemDESCRIPTION: $itemDESCRIPTION, itemPRICE: $itemPRICE)';
  }
}
