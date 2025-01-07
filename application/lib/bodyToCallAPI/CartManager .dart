import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();

  factory CartManager() => _instance;

  CartManager._internal();

  List<Map<String, dynamic>> _cartItems = [];

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      _cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
    }
  }

  Future<void> saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(_cartItems));
  }

  List<Map<String, dynamic>> getCartItems() => _cartItems;

  void addItem(Map<String, dynamic> item) {
    final index = _cartItems.indexWhere((i) => i['itemID'] == item['itemID']);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
      _cartItems[index]['total'] =
          _cartItems[index]['price'] * _cartItems[index]['quantity'];
    } else {
      _cartItems.add(item);
    }
  }

  void updateQuantity(int itemId, int delta) {
    final index = _cartItems.indexWhere((i) => i['itemID'] == itemId);
    if (index != -1) {
      _cartItems[index]['quantity'] += delta;
      if (_cartItems[index]['quantity'] <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index]['total'] =
            _cartItems[index]['price'] * _cartItems[index]['quantity'];
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
  }
}
