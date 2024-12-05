// import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';
import 'dart:async';
import 'dart:developer';
import 'package:application/Screens/Payment/PaymentError.dart';
import 'package:application/Screens/Payment/PaymentSuccess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class MethodPaymentPage extends StatefulWidget {
  const MethodPaymentPage({super.key});

  @override
  State<MethodPaymentPage> createState() => _MethodPaymentPageState();
}

class _MethodPaymentPageState extends State<MethodPaymentPage> {
  int _seconds = 300;
  late Timer _timer;
  int? _selectedPaymentIndex;

  @override
  void initState() {
    super.initState();
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     if (_seconds > 0) {
    //       _seconds--;
    //     } else {
    //       timer.cancel();
    //       Navigator.pop(context);
    //     }
    //   });
    // });
  }

  String _formatTime() {
    final min = (_seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_seconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildPaymentMethod(String image, String title, int index,
      {String? cardNumber}) {
    bool isSelected = _selectedPaymentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentIndex = index;
        });
      },
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 10, 21, 52),
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                cardNumber != null
                    ? '${'*' * (cardNumber.length - 4)}${cardNumber.substring(cardNumber.length - 4)}'
                    : title,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Color(0xff0CB15A),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0CB15A),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Payment Method',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.white),
            ),
            Text(
              _formatTime(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPaymentMethod(
                    'assets/images/Payment/Paypal.jpg', 'Paypal', 0),
                _buildPaymentMethod(
                    'assets/images/Payment/googlePay.jpg', 'Google Pay', 1),
                _buildPaymentMethod(
                    'assets/images/Payment/applesStore.jpg', 'Apple Store', 2),
                _buildPaymentMethod(
                    'assets/images/Payment/visa.jpg', '**** 4973', 3,
                    cardNumber: '1368497534973'),
                _buildPaymentMethod(
                    'assets/images/Payment/masterCard.jpg', '**** 4973', 4,
                    cardNumber: '1368497534973'),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select a payment method"),
                        ),
                      );
                      return;
                    }
                    if (_selectedPaymentIndex == 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => PaypalCheckoutView(
                          sandboxMode: false,
                          clientId:
                              "AVFsFZ3PBaF23GL2rlnD4_THkoByZ4VPa7LudTLwvqEJGlaA7V45jkRPBhX_ms4ti0Xu7ObHsnXgDuXo",
                          secretKey:
                              "EJLtE7NgDynt0UtnfLpjCY8E01zX2muF7Y7GcGARyh1Ft4FZ4iZI7p9-Q8i9UooM-sm48uHrHMCib903",
                          transactions: const [
                            {
                              "amount": {
                                "total": '100',
                                "currency": "USD",
                                "details": {
                                  "subtotal": '100',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description":
                                  "The payment transaction description.",
                              // "payment_options": {
                              //   "allowed_payment_method":
                              //       "INSTANT_FUNDING_SOURCE"
                              // },
                              "item_list": {
                                "items": [
                                  {
                                    "name": "Apple",
                                    "quantity": 4,
                                    "price": '10',
                                    "currency": "USD"
                                  },
                                  {
                                    "name": "Pineapple",
                                    "quantity": 5,
                                    "price": '12',
                                    "currency": "USD"
                                  }
                                ],
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            log("onSuccess: $params");
                            Navigator.pop(context);
                          },
                          onError: (error) {
                            log("onError: $error");
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            print('cancelled:');
                            Navigator.pop(context);
                          },
                        ),
                      ));
                    }
                    if (_selectedPaymentIndex == 3) {
                      // Visa
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccessPage()),
                      );
                    } else if (_selectedPaymentIndex == 4) {
                      // MasterCard
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentErrorPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("This payment method is not yet supported"),
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Text(
                        "Confirm Payment - \$50.00",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
