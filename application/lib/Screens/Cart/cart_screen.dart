import 'dart:convert';

import 'package:application/Screens/Homepage/shop.dart';
import 'package:application/components/customButton.dart';
import 'package:application/main.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartViewScreen extends StatefulWidget {
  const CartViewScreen({super.key});

  @override
  State<CartViewScreen> createState() => _CartViewScreenState();
}

class _CartViewScreenState extends State<CartViewScreen> {
  List<bool> isClickedList = [];
  dynamic userID;
  dynamic cartID;
  List<Map<String, dynamic>> _cartItems = [];
  bool isIncreasing = false;
  bool isDecreasing = false;
  int totalPrice = 0;
  int shipPrice = 2;
  double amount = 0;
  Map<String, dynamic>? intentPaymentData;
  final String _secretKey =
      "sk_test_51QXwiTC5mILZpjuwQ5ktL2zo91QyzUB275GKmR9vaXC8myKL7LCRO6Fs2CKYbtEwQgztaGe7FsOZ8hsEXaiTlGtX00LjtvEEdt";

  makeIntentForPayment(amountChanged, currency) async {
    try {
      Map<String, dynamic>? paymentInfo = {
        "amount": (int.parse(amountChanged)).toString(),
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var responseFromScripeAPI = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: paymentInfo,
          headers: {
            "Authorization": "Bearer $_secretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      print("This is your key" + _secretKey);
      print("response  from API: " + responseFromScripeAPI.body);
      return jsonDecode(responseFromScripeAPI.body);
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg);
      }
      print(errorMsg.toString());
    }
  }

  showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((val) {
        intentPaymentData = null;
        const ToastCard(
          leading: Icon(Icons.check, size: 20),
          title: const Text(
            'Payment successful',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                fontFamily: 'Fredoka',
                color: Color(0xff5CB15A)),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }).onError((errorMsg, sTrace) {
        if (kDebugMode) {
          print(errorMsg.toString() + sTrace.toString());
        }
      });
      clearCart();
    } on StripeException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showDialog(
          context: context,
          builder: (c) => const AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print(s);
      }
      print(errorMsg.toString());
    }
  }

  paymentSheetInitialization(amountChanged, currency) async {
    try {
      int? amountToSend = (double.tryParse(amountChanged) ?? 0 * 100).toInt();

      if (amountToSend == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid amount format')),
        );
        return; // Important: Stop execution if parsing fails
      }
      intentPaymentData =
          await makeIntentForPayment(amountToSend.toString(), currency);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  allowsDelayedPaymentMethods: true,
                  paymentIntentClientSecret:
                      intentPaymentData!["client_secret"],
                  style: ThemeMode.dark,
                  merchantDisplayName: "Spa Pet"))
          .then((val) {
        print(val);
      });
      showPaymentSheet();
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print(s);
      }
      print(errorMsg.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    await _fetchCartUser();
    setState(() {
      isClickedList = List.generate(5, (index) => false);
    });
  }

  Future<void> clearCart() async {
    setState(() {
      _cartItems.clear();
    });
    await saveCartToLocalStorage();
  }

  Future<void> increaseQuantity(int itemId) async {
    int? updatedTotalPrice;
    final itemIndex = _cartItems.indexWhere((item) => item['itemID'] == itemId);
    if (itemIndex != -1) {
      _cartItems[itemIndex]['quantity'] += 1;
      updatedTotalPrice =
          _cartItems[itemIndex]['price'] * _cartItems[itemIndex]['quantity'];
    }
    setState(() {
      totalPrice = updatedTotalPrice ?? totalPrice;
    });
    await saveCartToLocalStorage();
  }

  Future<void> decreaseQuantity(int itemId) async {
    int? updatedTotalPrice;
    final itemIndex = _cartItems.indexWhere((item) => item['itemID'] == itemId);
    if (itemIndex != -1) {
      if (_cartItems[itemIndex]['quantity'] > 1) {
        _cartItems[itemIndex]['quantity'] -= 1;
        _cartItems[itemIndex]['total'] =
            _cartItems[itemIndex]['price'] * _cartItems[itemIndex]['quantity'];
        updatedTotalPrice = _cartItems[itemIndex]['total'];
      } else {
        setState(() {
          _cartItems.removeAt(itemIndex);
          totalPrice = calculateCartTotal(_cartItems);
        });
      }
    }
    print('cart after add:  $_cartItems');
    setState(() {
      totalPrice = updatedTotalPrice ?? totalPrice;
    });

    await saveCartToLocalStorage();
  }

  int calculateCartTotal(List<Map<String, dynamic>> cartItems) {
    int total = 0;
    for (var item in cartItems) {
      // Ensure 'total' is an int or cast it to int if it's a String
      var totalValue = item['total'];
      if (totalValue is String) {
        totalValue = int.tryParse(totalValue) ??
            0; // Parse string to int, or default to 0
      }

      total += totalValue as int; // Now it's safe to cast as int
    }
    return total;
  }

  Future<void> saveCartToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cart', jsonEncode(_cartItems));
  }

  Future<void> _fetchCartUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        _cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
        totalPrice = calculateCartTotal(_cartItems);
        print('$totalPrice');
        print('Cart: $_cartItems');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          backgroundColor: const Color(0xFF5CB15A),
          title: const Center(
            child: Text(
              'Cart ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Fredoka',
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height:
                    AppBar().preferredSize.height, // Match the AppBar height
                child: Image.asset(
                  'assets/icons/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 240, 238, 238),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  _cartItems.isEmpty
                      ? Text(
                          'Hiện tại bạn không có item nào trong cart',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            fontFamily: 'Fredoka',
                          ),
                        )
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final item = _cartItems[index];
                              print(
                                  'this is item : ${_cartItems[index]['itemID']}');
                              return Container(
                                child: _itemsCart(
                                  item['quantity'].toString(),
                                  item['itemName'],
                                  item['total'],
                                  index,
                                ),
                              );
                            },
                          ),
                        ),
                  _priceItem('Subtotal', "${totalPrice}\$"),
                  const SizedBox(height: 20),
                  _priceItem('Shipping charges', "${shipPrice}\$"),
                  const SizedBox(height: 50),
                  _priceItem('Total', "${totalPrice + shipPrice}\$"),
                  const SizedBox(height: 50),
                  CustomButton(
                      text: 'Checkout',
                      onPressed: () {
                        setState(() {
                          amount =
                              (totalPrice + shipPrice) * 100.roundToDouble();
                        });
                        paymentSheetInitialization(amount.toString(), "USD");
                      })
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemsCart(quantityItem, nameItem, priceItem, index) {
    if (index >= _cartItems.length) {
      return SizedBox.shrink();
    }

    int itemIndex = index as int;
    return GestureDetector(
      onTap: () {
        setState(() {
          isClickedList[itemIndex] = !isClickedList[itemIndex];
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform:
            Matrix4.translationValues(isClickedList[index] ? -50 : 0, 0, 0),
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity,
        height: 150,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Image.asset(pathImage, width: 200, height: 150),
                  const SizedBox(
                    width: 30,
                  ),
                  _contentItem(priceItem, nameItem),
                  _counter(quantityItem, index),
                ],
              ),
            ),
            if (isClickedList[itemIndex])
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    // Kiểm tra xem key 'cart' có tồn tại không
                    if (prefs.containsKey('cart')) {
                      // In ra thông báo rằng cart tồn tại
                      print('Cart exists in local storage');

                      // Xóa cart khỏi local storage
                      await prefs.remove('cart');
                      print('Cart has been removed from local storage');
                    } else {
                      // In ra thông báo rằng cart không tồn tại
                      print('No cart found in local storage');
                    }

                    // Cập nhật giao diện để xóa item khỏi danh sách
                    setState(() {
                      _cartItems.removeAt(index);
                      totalPrice = calculateCartTotal(_cartItems);
                      saveCartToLocalStorage();
                    });
                  },
                  child: Container(
                    color: Colors.red,
                    width: 60,
                    height: 150,
                    child: Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _contentItem(priceItem, nameItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Container(
          width: 250,
          child: Text(
            nameItem,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${priceItem}\$",
          style: TextStyle(
            color: Color(0xff5CB15A),
            fontSize: 20,
            fontFamily: 'Fredoka',
          ),
        ),
      ],
    );
  }

  Widget _counter(quantityItem, index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
              icon: Icon(
                Icons.remove,
                size: 20,
              ),
              onPressed: () {
                decreaseQuantity(_cartItems[index]['itemID']);
              },
            ),
            Text(
              "$quantityItem",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff868889),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 20,
              ),
              onPressed: () {
                increaseQuantity(_cartItems[index]['itemID']);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceItem(subItem, priceItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          subItem,
          style: TextStyle(
              fontSize: 20,
              color: Color(0xff000000),
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w600),
        ),
        Text(
          priceItem,
          style: TextStyle(
              fontSize: 20, color: Color(0xff000000), fontFamily: 'Fredoka'),
        ),
      ],
    );
  }
}
