import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopPage extends StatefulWidget {
  final int userID;

  const ShopPage({required this.userID});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedCategoryIndex = 0;
  String _currentCategory = 'FOOD';
  List<dynamic> _categoryItems = [];
  @override
  void initState() {
    super.initState();
    _fetchCategory(); // Call fetchPets when the widget is initialized
  }

  // Track the selected category index
  Future<void> _fetchCategory() async {
    print("Fetching category: $_currentCategory");
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
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white, // Set icon color
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
                        print(item);
                        return _buildShopCard(
                            item['itemNAME'],
                            item['itemDESCRIPTION'],
                            item['itemPRICE'].toString(),
                            'assets/icons/logo.png');
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

  Widget _buildShopRow(
      String brand, String description, String price, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.contain,
            height: 50,
            width: 50,
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
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey, fontFamily: 'Fredoka'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Price: $price",
            style: TextStyle(
                color: Color(0xff000000), fontSize: 16, fontFamily: 'Fredoka'),
          ),
          Divider(
            color: Colors.black, // Change color temporarily for visibility
            thickness: 3,
            height: 20, // Increase thickness for visibility
          ),
          GestureDetector(
            onTap: () {
              // Action for the button
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add to cart',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Fredoka'),
                ),
                const SizedBox(width: 8),
                Icon(Icons.shopping_cart_outlined, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(
      String brand, String description, String price, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 250,
        height: 234,
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            _buildShopRow(brand, description, price, imagePath),
          ],
        ),
      ),
    );
  }
}
