import 'dart:convert';

import 'package:application/Screens/Checkout/key.dart';
import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:application/Screens/Homepage/shop.dart';
import 'package:application/Screens/Checkout/key.dart';
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
        Future<void> clearCart() async {
          setState(() {
            _cartItems.clear();
          });
          await saveCartToLocalStorage();
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }).onError((errorMsg, sTrace) {
        if (kDebugMode) {
          print(errorMsg.toString() + sTrace.toString());
        }
      });
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
    _fetchCartUser();
    isClickedList = List.generate(5, (index) => false);
  }

  Future<void> clearCart() async {
    setState(() {
      _cartItems.clear();
    });
    await saveCartToLocalStorage();
  }

  void increaseQuantity(int itemId) async {
    setState(() {
      final itemIndex =
          _cartItems.indexWhere((item) => item['itemID'] == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex]['quantity'] += 1;
        _cartItems[itemIndex]['total'] =
            _cartItems[itemIndex]['price'] * _cartItems[itemIndex]['quantity'];
        totalPrice = _cartItems[itemIndex]['total'];
      }
    });

    await saveCartToLocalStorage();
  }

  void decreaseQuantity(int itemId) async {
    setState(() {
      final itemIndex =
          _cartItems.indexWhere((item) => item['itemID'] == itemId);
      if (itemIndex != -1) {
        if (_cartItems[itemIndex]['quantity'] > 1) {
          _cartItems[itemIndex]['quantity'] -= 1;
          _cartItems[itemIndex]['total'] = _cartItems[itemIndex]['price'] *
              _cartItems[itemIndex]['quantity'];
          totalPrice = _cartItems[itemIndex]['total'];
        } else {
          _cartItems.removeAt(itemIndex);
        }
      }
    });

    await saveCartToLocalStorage();
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
        print('Cart: $_cartItems');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
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
                  const SizedBox(height: 120),
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
                              // final imagePath =
                              //     'assets/images/${item['itemIMAGE']}';
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: _itemsCart(
                                  // imagePath,
                                  item['quantity'].toString(),
                                  item['itemName'],
                                  item['total'],
                                  index,
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 70),
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
                          amount = (totalPrice + shipPrice).roundToDouble();
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
        height: 120,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Image.asset(pathImage, width: 200, height: 150),
                  const SizedBox(width: 30),
                  _contentItem(priceItem, nameItem),
                  const SizedBox(width: 15),
                  _counter(quantityItem, index),
                ],
              ),
            ),
            if (isClickedList[itemIndex])
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      _cartItems.removeAt(index);
                    });
                    await saveCartToLocalStorage();
                  },
                  child: Container(
                    color: Colors.red,
                    width: 60,
                    height: 120,
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
        // Make the name item flexible to prevent overflow
        Flexible(
          child: Text(
            nameItem,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis, // Truncates text if it overflows
            ),
            maxLines: 1, // Make sure the name doesn't take more than one line
          ),
        ),
        const SizedBox(height: 10), // Adjusted space between name and price
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
