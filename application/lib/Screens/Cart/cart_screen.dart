import 'dart:convert';

import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartViewScreen extends StatefulWidget {
  const CartViewScreen({super.key});

  @override
  State<CartViewScreen> createState() => _CartViewScreenState();
}

class _CartViewScreenState extends State<CartViewScreen> {
  List<bool> isClickedList = [];
  dynamic userID;
  dynamic cartID;
  List<dynamic> cartItemUser = [];
  @override
  void initState() {
    super.initState();
    // Giả sử có 5 item, khởi tạo danh sách trạng thái cho tất cả items
    _fetchCartUser();
    isClickedList =
        List.generate(5, (index) => false); // Tùy thuộc vào số lượng items
  }

  Future<void> _fetchCartUser() async {
    try {
      final userManager = UserManager(); // Ensure singleton access
      User? currentUser = userManager.user;
      if (currentUser != null) {
        userID = currentUser.userID;
        cartID = currentUser.cartID;
      } else {
        print("No user is logged in in HomePage.");
      }
      final url = Uri.parse("http://localhost:8080/api/cart/getUserCart");
      // Gửi yêu cầu POST tới API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userID": userID,
          "cartID": cartID // Lấy text từ usernameController
        }),
      );
      // Kiểm tra trạng thái của API trả về
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cartItemUser = data["cartDetails"]; // Hiển thị thông báo lỗi
        });
        print(data);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                  cartItemUser.isEmpty
                      ? Text(
                          'Hiện tại bạn không có item nào trong cart',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            fontFamily: 'Fredoka',
                          ),
                        )
                      : SizedBox(
                          height:
                              400, // Giới hạn chiều cao cho ListView.builder
                          child: ListView.builder(
                            itemCount:
                                cartItemUser.length, // Số lượng items từ API
                            itemBuilder: (context, index) {
                              final item = cartItemUser[index];
                              return _itemsCart(
                                item['itemIMAGE'], // Dữ liệu hình ảnh từ API
                                item['itemQUANTITY']
                                    .toString(), // Số lượng từ API
                                item[
                                    'itemNAME'], // Tên item từ API // Trọng lượng từ API
                                index,
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 70),
                  _priceItem('Subtotal', 'Rs.530.540'),
                  const SizedBox(height: 20),
                  _priceItem('Shipping charges', 'Rs 520.00'),
                  const SizedBox(height: 50),
                  _priceItem('Total', 'Rs 53,860'),
                  const SizedBox(height: 50),
                  CustomButton(text: 'Checkout', onPressed: () {})
                ],
              ),
            ),
          ),
        ),
        CustomNavContent(
          navText: "Cart",
          onBackPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RegisterScreen(), // Điều hướng đến trang mới
              ),
            );
          },
        )
      ],
    );
  }

  Widget _itemsCart(pathImage, quantityItem, nameItem, index) {
    int itemIndex = index as int;
    return GestureDetector(
      onTap: () {
        setState(() {
          isClickedList[itemIndex] =
              !isClickedList[itemIndex]; // Đổi trạng thái cho item hiện tại
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: Matrix4.translationValues(
            isClickedList[index] ? -50 : 0, 0, 0), // Di chuyển theo trục X
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
                  Image.asset(pathImage, width: 70, height: 70),
                  const SizedBox(width: 30),
                  _contentItem(quantityItem, nameItem),
                  const SizedBox(width: 15),
                  _counter(),
                ],
              ),
            ),
            // Icon "Remove" xuất hiện khi item này được click
            if (isClickedList[itemIndex])
              Positioned(
                right: 0,
                child: Container(
                  color: Colors.red,
                  width: 60,
                  height: 120,
                  child: Icon(Icons.delete, color: Colors.white, size: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _contentItem(quantityItem, nameItem) {
    return Column(
      children: [
        Text(
          quantityItem,
          style: TextStyle(
              color: Color(0xff5CB15A), fontSize: 16, fontFamily: 'Fredoka'),
        ),
        const SizedBox(height: 5),
        Text(nameItem,
            style: TextStyle(
                color: Color(0xff000000), fontSize: 20, fontFamily: 'Fredoka')),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _counter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add),
        const SizedBox(height: 10),
        Text('3', style: TextStyle(fontSize: 16, color: Color(0xff868889))),
        const SizedBox(height: 10),
        Icon(Icons.remove)
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
