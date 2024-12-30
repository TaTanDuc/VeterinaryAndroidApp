import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreen();
}

class _CheckoutScreen extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _page(size),
    );
  }

  Widget _page(size) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          CustomNavContent(
              navText: 'Payment Method',
              onBackPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartViewScreen()),
                );
              }),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  _totalPrice(),
                  const SizedBox(height: 20),
                  _infoCard(),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: 'Pay Now',
                      onPressed: () {
                        // paymentSheetInitialization(

                        // );
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _totalPrice() {
  return Center(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Màu đường viền
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0), // Bo tròn góc
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0), // Khoảng cách giữa các dòng
          Text(
            'Transaction Amount',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            '15000.00 LKR',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Transaction Reference No',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            'A13XI45SCSA44J',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _infoCard() {
  return Container(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select card type',
            style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(
          height: 20,
        ),
        Image.asset('assets/images/card.png'),
        const SizedBox(
          height: 10,
        ),
        _Field('Card Number'),
        const SizedBox(height: 10),
        _Field('Name on the card'),
        const SizedBox(height: 10),
        _Field('Email'),
      ],
    ),
  );
}

Widget _Field(titleField) {
  return Container(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleField,
          style: TextStyle(
              fontFamily: 'Fredoka', fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            filled: true, // Bật background màu cho TextField
            fillColor: Color(0xFFA6A6A6), // Màu nền TextField (A6A6A6)
            hintText: titleField,

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12.0), // Bo tròn border-radius
              borderSide: BorderSide.none, // Không có border rõ ràng
            ),
          ),
        ),
      ],
    ),
  );
}
