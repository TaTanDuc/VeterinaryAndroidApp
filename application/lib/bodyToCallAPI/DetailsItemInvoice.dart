import 'package:application/bodyToCallAPI/ItemInvoice.dart';

class DetailsItemInvoice {
  final List<ItemInvoice> items;

  DetailsItemInvoice({
    required this.items,
  });

  factory DetailsItemInvoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return DetailsItemInvoice(
      items: (json['c'] as List)
              .map((serviceJson) => ItemInvoice.fromJson(serviceJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'returned': items.map((service) => service.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Details item(sdfjfhdfhff:$items)';
  }
}
