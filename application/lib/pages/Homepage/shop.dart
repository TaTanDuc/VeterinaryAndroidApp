import 'dart:convert';

import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopPage extends StatefulWidget {
  final int userID;

  const ShopPage({super.key, required this.userID});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedCategoryIndex = 0;
  String _currentCategory = 'FOOD';
  List<dynamic> _categoryItems = [];
  TextEditingController inputValueController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchCategory(); // Call fetchPets when the widget is initialized
  }

  Future<void> handleSearch(value) async {
    try {
      final url = Uri.parse(
          "http://localhost:8080/api/storage/search?itemCATEGORY=${_currentCategory}&itemNAME=${value}");
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Nếu đăng nhập thành công, chuyển tới MainPage
        setState(() {
          _categoryItems = data; // Hiển thị thông báo lỗi
        });
      }
    } catch (err) {
      print(err);
    }
  }

  // Track the selected category index
  Future<void> _fetchCategory() async {
    try {
      final url = Uri.parse(
          "http://localhost:8080/api/storage/getItems?category=${_currentCategory}");
      // Gửi yêu cầu POST tới API
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      // Kiểm tra trạng thái của API trả về
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _categoryItems = data;
        });
      } else {
        setState(() {
          _categoryItems = [];
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Center(
          child: Text(
            'Shop', // Văn bản bạn muốn thêm
            style: TextStyle(
              color: Colors.white, // Màu chữ
              fontSize: 16,
              fontFamily: 'Fredoka', // Kích thước chữ
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Điều hướng đến trang mới
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CartViewScreen()), // Thay NewPage bằng trang bạn muốn mở
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.11),
                  blurRadius: 40,
                  spreadRadius: 0.0,
                )
              ]),
              child: TextField(
                controller: inputValueController,
                onChanged: (value) {
                  handleSearch(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12.0),
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Items By Category',
                  hintStyle: TextStyle(
                      fontFamily: 'Fredoka',
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // My Pets Section
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const SizedBox(height: 20),
                  _buildCategoryItem(
                      0, 'Food', 'assets/icons/food.png', screenWidth),
                  _buildCategoryItem(1, 'Medicine',
                      'assets/icons/petmedicine.png', screenWidth),
                  _buildCategoryItem(2, 'Accessory',
                      'assets/icons/accessories.png', screenWidth),
                  _buildCategoryItem(
                      3, 'Toy', 'assets/icons/pet-toy.png', screenWidth),
                  _buildCategoryItem(
                      4, 'Furniture', 'assets/icons/house.png', screenWidth),
                ],
              ),
            ),
            const SizedBox(height: 0),

            Padding(
                padding: const EdgeInsets.all(
                    16.0), // Set the desired padding (which acts like a margin)
                child: Text(
                  "Our $_currentCategory",
                  style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),

            Center(
              child: Wrap(
                runSpacing: 20, // Vertical space between rows
                spacing: 20, // Horizontal space between items
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: _categoryItems.isEmpty
                    ? [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No items available",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Fredoka',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24)),
                            const SizedBox(height: 30),
                            Image.asset('assets/images/empty_image.png')
                          ],
                        )
                      ] // Hiển thị nếu không có dữ liệu
                    : _categoryItems.map((item) {
                        String imagePath = 'assets/images/${item['itemIMAGE']}';
                        return _buildShopRow(
                            item['itemNAME'],
                            item['itemDESCRIPTION'],
                            item['itemPRICE'].toString(),
                            imagePath,
                            item['itemQUANTITY'].toString());
                      }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      int index, String title, String imagePath, double screenWidth) {
    // Adjust icon and container size based on screen width
    double containerSize =
        screenWidth > 600 ? 90 : 60; // Larger container for bigger screens

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategoryIndex = index;
            _currentCategory =
                title.toUpperCase(); // Update the selected category index
          });
          _fetchCategory(); // Handle the click event
        },
        child: Column(
          children: [
            Container(
              width: containerSize,
              height: containerSize,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedCategoryIndex == index
                    ? const Color(0xFF5CB15A)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit
                    .contain, // Ensures the image fits well inside the container
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth > 600
                    ? 16
                    : 12, // Larger text for bigger screens
                color: _selectedCategoryIndex == index
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopRow(String brand, String description, String price,
      String imagePath, quantity) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // Sử dụng Column để cho phép nội dung tự động xuống hàng
          crossAxisAlignment:
              CrossAxisAlignment.start, // Căn chỉnh các widget sang bên trái
          children: [
            _buildShopCard(brand, description, price, imagePath, quantity),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(String brand, String description, String price,
      String imagePath, quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: double.infinity, // Chiều rộng tối đa
        constraints: BoxConstraints(
          minHeight: 300, // Thiết lập chiều cao tối thiểu cho card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
              height: 150,
              width: 240,
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                brand,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fredoka'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 4.0),
              constraints: BoxConstraints(
                minHeight: 40, // Thiết lập chiều cao tối thiểu cho mô tả
              ),
              child: Text(
                description,
                maxLines: 3, // Giới hạn số dòng
                overflow:
                    TextOverflow.ellipsis, // Hiển thị ... nếu mô tả quá dài
                style: TextStyle(
                    fontSize: 14, color: Colors.grey, fontFamily: 'Fredoka'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price: $price",
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w600),
                ),
                if (int.tryParse(quantity) != 0) // Nếu quantity > 0
                  Text(
                    'In stock: $quantity',
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 16,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.w600),
                  )
                else // Nếu quantity = 0
                  Text(
                    'Sold out',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.w600),
                  ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
              height: 20,
            ),
            if (int.tryParse(quantity) != 0) // Câu lệnh điều kiện
              GestureDetector(
                onTap: () {
                  // Action for the button
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add to cart',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Fredoka'),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.shopping_cart_outlined, color: Colors.red),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
