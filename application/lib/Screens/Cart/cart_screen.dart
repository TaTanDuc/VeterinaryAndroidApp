import 'dart:convert';

import 'package:application/Screens/Checkout/key.dart';
import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/bodyToCallAPI/User.dart';
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
    // Giả sử có 5 item, khởi tạo danh sách trạng thái cho tất cả items
    _fetchCartUser();
    isClickedList =
        List.generate(5, (index) => false); // Tùy thuộc vào số lượng items
  }

  Future<void> handleDecreaseItem(int index, bool isDecreasing) async {
    try {
      int currentQuantity;
      final userManager = UserManager(); // Ensure singleton access
      User? currentUser = userManager.user;
      if (currentUser != null) {
        userID = currentUser.userID;
        cartID = currentUser.cartID;
      } else {
        print("No user is logged in in HomePage.");
        return;
      }

      // Lấy thông tin của item đang được cập nhật
      var item = cartItemUser[index];
      currentQuantity = item['itemQUANTITY'];
      ;

      // Tăng hoặc giảm số lượng dựa trên nút đã được nhấn
      if (isDecreasing) {
        currentQuantity--;
      } else {
        currentQuantity = currentQuantity == 1
            ? currentQuantity
            : currentQuantity - 1; // Không để số lượng nhỏ hơn 1
      }

      // Gọi API để cập nhật số lượng mới
      final url = Uri.parse("http://10.0.2.2:8080/api/cart/updateCart");
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userID": userID,
          "cartID": cartID,
          "cartItems": [
            {
              "itemCODE": item['itemCODE'], // Mã item
              "itemID": item['itemID'], // ID item
              "itemQUANTITY": currentQuantity.toString() // Số lượng mới
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var updatedItem = data['cartDetails'][0];
        setState(() {
          cartItemUser = cartItemUser.map((existingItem) {
            if (existingItem['itemNAME'] == updatedItem['itemNAME']) {
              return updatedItem; // Thay thế item có cùng tên
            }
            return existingItem; // Không thay đổi các item khác
          }).toList();
          setState(() {
            totalPrice = 0; // Reset lại totalPrice
            cartItemUser.forEach((item) {
              int itemPrice = int.parse(item['itemPRICE'].toString());
              int itemQuantity = int.parse(item['itemQUANTITY'].toString());
              totalPrice += itemPrice * itemQuantity;
            });
          });
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> handleIncreaseItem(int index, bool isIncreasing) async {
    try {
      int currentQuantity;
      final userManager = UserManager(); // Ensure singleton access
      User? currentUser = userManager.user;
      if (currentUser != null) {
        userID = currentUser.userID;
        cartID = currentUser.cartID;
      } else {
        print("No user is logged in in HomePage.");
        return;
      }

      // Lấy thông tin của item đang được cập nhật
      var item = cartItemUser[index];
      currentQuantity = item['itemQUANTITY'];
      ;

      // Tăng hoặc giảm số lượng dựa trên nút đã được nhấn
      if (isIncreasing) {
        currentQuantity++;
      } else {
        currentQuantity = currentQuantity > 1
            ? currentQuantity - 1
            : 1; // Không để số lượng nhỏ hơn 1
      }

      // Gọi API để cập nhật số lượng mới
      final url = Uri.parse("http://10.0.2.2:8080/api/cart/updateCart");
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userID": userID,
          "cartID": cartID,
          "cartItems": [
            {
              "itemCODE": item['itemCODE'], // Mã item
              "itemID": item['itemID'], // ID item
              "itemQUANTITY": currentQuantity.toString() // Số lượng mới
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var updatedItem = data['cartDetails'][0];
        setState(() {
          cartItemUser = cartItemUser.map((existingItem) {
            if (existingItem['itemNAME'] == updatedItem['itemNAME']) {
              return updatedItem; // Thay thế item có cùng tên
            }
            return existingItem; // Không thay đổi các item khác
          }).toList();
        });
        setState(() {
          totalPrice = 0; // Reset lại totalPrice
          cartItemUser.forEach((item) {
            int itemPrice = int.parse(item['itemPRICE'].toString());
            int itemQuantity = int.parse(item['itemQUANTITY'].toString());
            totalPrice += itemPrice * itemQuantity;
          });
        });
      } else {
        print("Failed to update item.");
      }
    } catch (err) {
      print(err);
    }
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
      final url = Uri.parse("http://10.0.2.2:8080/api/cart/getUserCart");
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
          totalPrice = data['TOTAL'];
          cartItemUser = data["cartDetails"];
          // totalPrice = int.parse(data['TOTAL']);
          isClickedList = List.generate(cartItemUser.length, (index) => false);
        });
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
                          height: 400, // Giới hạn chiều cao của vùng chứa
                          child: ListView.builder(
                            shrinkWrap:
                                true, // Đảm bảo ListView thu nhỏ theo nội dung
                            physics:
                                AlwaysScrollableScrollPhysics(), // Cho phép cuộn
                            itemCount:
                                cartItemUser.length, // Số lượng item từ API
                            itemBuilder: (context, index) {
                              final item = cartItemUser[index];
                              final imagePath =
                                  'assets/images/${item['itemIMAGE']}';
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0), // Khoảng cách phía trên
                                child: _itemsCart(
                                  imagePath, // Dữ liệu hình ảnh từ API
                                  item['itemQUANTITY']
                                      .toString(), // Số lượng từ API
                                  item['itemNAME'], // Tên item từ API
                                  item['itemPRICE'], // Giá item từ API
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
                        paymentSheetInitialization(amount.toString(), "VND");
                      })
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
                builder: (context) => ShopPage(), // Điều hướng đến trang mới
              ),
            );
          },
        )
      ],
    );
  }

  Widget _itemsCart(pathImage, quantityItem, nameItem, priceItem, index) {
    // Kiểm tra nếu index nằm ngoài phạm vi của cartItemUser
    if (index >= cartItemUser.length) {
      return SizedBox.shrink(); // Trả về widget rỗng nếu index không hợp lệ
    }

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
                  Image.asset(pathImage, width: 200, height: 150),
                  const SizedBox(width: 30),
                  _contentItem(priceItem, nameItem),
                  const SizedBox(width: 15),
                  _counter(quantityItem, index),
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

  Widget _contentItem(priceItem, nameItem) {
    return Column(
      children: [
        Text(nameItem,
            style: TextStyle(
                color: Color(0xff000000),
                fontSize: 30,
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        Text(
          "${priceItem}\$",
          style: TextStyle(
              color: Color(0xff5CB15A), fontSize: 20, fontFamily: 'Fredoka'),
        ),
      ],
    );
  }

  Widget _counter(quantityItem, index) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.add), // Biểu tượng nút
            onPressed: () {
              handleIncreaseItem(index, true);
              // _fetchCartUser();
            },
          ),
          Text("${quantityItem}",
              style: TextStyle(fontSize: 16, color: Color(0xff868889))),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              handleDecreaseItem(index, isDecreasing);
            },
          )
        ],
      ),
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
