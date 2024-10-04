import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class CartViewScreen extends StatefulWidget {
  const CartViewScreen({super.key});

  @override
  State<CartViewScreen> createState() => _CartViewScreenState();
}

class _CartViewScreenState extends State<CartViewScreen> {
  List<bool> isClickedList = [];
  @override
  void initState() {
    super.initState();
    // Giả sử có 5 item, khởi tạo danh sách trạng thái cho tất cả items
    isClickedList =
        List.generate(5, (index) => false); // Tùy thuộc vào số lượng items
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
                  SizedBox(
                    // Bọc ListView.builder trong SizedBox với chiều cao cố định
                    height: 400, // Hoặc dùng chiều cao bạn muốn giới hạn
                    child: ListView.builder(
                      itemCount: 5, // Số lượng items trong cart
                      itemBuilder: (context, index) {
                        return _itemsCart(
                          'assets/images/food2.png', // pathImage
                          '2', // quantityItem
                          'Item $index', // nameItem
                          '1.5', // heavyItem
                          index,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 70),
                  _priceItem('Subtotal', 'Rs.530.540', 16),
                  const SizedBox(height: 20),
                  _priceItem('Shipping charges', 'Rs 520.00', 16),
                  const SizedBox(height: 50),
                  _priceItem('Total', 'Rs 53,860', 20),
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

  Widget _itemsCart(pathImage, quantityItem, nameItem, heavyItem, index) {
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
                  _contentItem(quantityItem, nameItem, heavyItem),
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

  Widget _contentItem(quantityItem, nameItem, heavyItem) {
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
        Text(heavyItem,
            style: TextStyle(
                color: Color(0xff868889),
                fontWeight: FontWeight.w300,
                fontFamily: 'Fredoka'))
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

  Widget _priceItem(subItem, priceItem, fzItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          subItem,
          style: TextStyle(
              fontSize: fzItem,
              color: Color(0xff000000),
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w600),
        ),
        Text(
          priceItem,
          style: TextStyle(
              fontSize: fzItem,
              color: Color(0xff000000),
              fontFamily: 'Fredoka'),
        ),
      ],
    );
  }
}
