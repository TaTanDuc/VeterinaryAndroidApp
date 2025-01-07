import 'dart:convert';

import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/main.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    super.key,
  });

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedCategoryIndex = 0;
  String _currentCategory = 'FOOD';
  dynamic ID;
  dynamic cartID;
  List<dynamic> _categoryItems = [];
  bool _loading = true;
  List<Map<String, dynamic>> _cartItems = [];
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';

  TextEditingController inputValueController = TextEditingController();
  _getRequests() async {}
  @override
  void initState() {
    super.initState();

    loadCartFromLocalStorage();
    _fetchCategory();
  }

  void navigateToCart() async {
    bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartViewScreen()),
    );

    if (shouldRefresh ?? false) {
      loadCartFromLocalStorage();
    }
  }

  Future<void> saveCartToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isSaved = await prefs.setString('cart', jsonEncode(_cartItems));

    if (isSaved) {
      print('Cart saved successfully');
    } else {
      print('Failed to save cart');
    }
  }

  Future<void> loadCartFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      setState(() {
        _cartItems = List<Map<String, dynamic>>.from(jsonDecode(cartData));
        print('Cart loaded: $_cartItems');
      });
    }
  }

  Future<void> handleAddCart(Map<String, dynamic> value) async {
    setState(() {
      print('Inside setState');
      final existingItemIndex =
          _cartItems.indexWhere((item) => item['itemID'] == value['itemID']);

      if (existingItemIndex != -1) {
        print('Item found, updating quantity');
        _cartItems[existingItemIndex]['quantity'] += 1;
        _cartItems[existingItemIndex]['total'] = _cartItems[existingItemIndex]
                ['price'] *
            _cartItems[existingItemIndex]['quantity'];
      } else {
        print('Item not found, adding new item');
        _cartItems.add({
          "userID": value['session'],
          "itemName": value['itemName'],
          "itemID": value['itemID'],
          "categoryName": value['categoryName'],
          "price": value['price'],
          "quantity": 1,
          "total": value['price'],
        });
      }
    });

    await saveCartToLocalStorage();
  }

  Future<void> handleSearch(value) async {
    try {
      final session = await SessionManager().getSession();
      final url = Uri.parse(
          "http://192.168.137.1:8080/api/customer/shop?categoryCode=${_currentCategory}&searchString=${value}");
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['returned'];
        setState(() {
          _categoryItems = data;
        });
      } else {
        setState(() {
          _categoryItems = [];
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _fetchCategory() async {
    try {
      final session = await SessionManager().getSession();
      final url = Uri.parse(
          "http://192.168.137.1:8080/api/customer/shop?categoryCode=${_currentCategory}&searchString=");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['returned'];
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
        ),
        backgroundColor: const Color(0xFF5CB15A),
        title: const Center(
          child: Text(
            'Shop',
            style: TextStyle(
              color: Colors.white, // Màu chữ
              fontSize: 23,
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
                  size: 23,
                ),
                onPressed: () {
                  print('Cart current: $_cartItems');
                  navigateToCart();
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.11),
                    blurRadius: 40,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              child: TextField(
                controller: inputValueController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12.0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_off,
                      color: _isListening ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                  hintText: 'Search Items By Category',
                  hintStyle: TextStyle(
                    fontFamily: 'Fredoka',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Center(
              child: _buildCategoryBox(screenWidth),
            ),
            const SizedBox(height: 0),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Our $_currentCategory",
                  style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
            Center(
              child: Wrap(
                runSpacing: 20,
                spacing: 20,
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
                      ]
                    : List.generate(_categoryItems.length, (index) {
                        var item = _categoryItems[index];
                        //String imagePath = '${item['itemIMAGE']}';
                        return _buildShopRow(
                          index,
                          item['itemIMG'],
                          item['itemName'],
                          item['categoryName'],
                          item['price'].toString(),
                          item['itemRating'],
                        );
                      }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBox(double screenWidth) {
    double boxWidth = screenWidth > 600 ? 600 : screenWidth * 0.9;

    return Container(
      child: screenWidth > 600
          ? Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 20),
                  _buildCategoryItemRow(
                      0, 'Food', 'assets/icons/food.png', screenWidth),
                  _buildCategoryItemRow(1, 'Medicine',
                      'assets/icons/petmedicine.png', screenWidth),
                  _buildCategoryItemRow(2, 'Accessory',
                      'assets/icons/accessories.png', screenWidth),
                  _buildCategoryItemRow(
                      3, 'Toy', 'assets/icons/pet-toy.png', screenWidth),
                  _buildCategoryItemRow(
                      4, 'Furniture', 'assets/icons/house.png', screenWidth),
                ],
              ),
            )
          : Container(
              width: boxWidth, // Apply width here
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(
                      index,
                      [
                        'FOOD',
                        'MEDICINE',
                        'ACCESSORY',
                        'TOY',
                        'FURNITURE'
                      ][index],
                      [
                        'assets/icons/food.png',
                        'assets/icons/petmedicine.png',
                        'assets/icons/accessories.png',
                        'assets/icons/pet-toy.png',
                        'assets/icons/house.png'
                      ][index],
                      screenWidth,
                    );
                  },
                ),
              )),
    );
  }

  Widget _buildCategoryItem(
      int index, String title, String imagePath, double screenWidth) {
    double containerSize = screenWidth > 600 ? 80 : 60;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
          _currentCategory =
              title.toUpperCase(); // Update the selected category index
        });
        _fetchCategory(); // Handle the click event
      },
      child: Container(
        padding: const EdgeInsets.all(8.0), // Padding for the item
        decoration: BoxDecoration(
          color: _selectedCategoryIndex == index
              ? const Color(0xFF5CB15A)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center items vertically
          children: [
            Container(
              width: containerSize,
              height: containerSize,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white, // Background for the image container
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12), // Ensure image fits well
                child: Image.asset(
                  imagePath,
                  fit: BoxFit
                      .contain, // Ensures the image fits well inside the container
                ),
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
              textAlign: TextAlign.center, // Center align the text
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItemRow(
      int index, String title, String imagePath, double screenWidth) {
    double containerSize = screenWidth > 600 ? 80 : 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategoryIndex = index;
            _currentCategory = title.toUpperCase();
          });
          _fetchCategory();
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
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth > 600 ? 16 : 12,
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

  Widget _buildShopRow(int index, String imagePath, String brand,
      String description, String price, double quantity) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildShopCard(
            //     brand, description, price, imagePath, quantity, index),
            _buildShopCard(
                imagePath, brand, description, price, quantity, index),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(String imagePath, String brand, String description,
      String price, double quantity, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 300,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
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
                minHeight: 40,
              ),
              child: Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey, fontFamily: 'Fredoka'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStarRating(quantity),
                const SizedBox(width: 8),
                Text(
                  quantity.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                DelightToastBar(
                        builder: (context) {
                          return const ToastCard(
                            leading: Icon(Icons.check, size: 20),
                            title: const Text(
                              'Add successful',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Fredoka',
                                  color: Color(0xff5CB15A)),
                            ),
                          );
                        },
                        position: DelightSnackbarPosition.top,
                        autoDismiss: true,
                        snackbarDuration: Durations.extralong2)
                    .show(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      handleAddCart(_categoryItems[index]);
                      DelightToastBar(
                        builder: (context) {
                          return const ToastCard(
                            leading: Icon(Icons.check, size: 20),
                            title: Text(
                              'Add successful',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Fredoka',
                                color: Color(0xff5CB15A),
                              ),
                            ),
                          );
                        },
                        position: DelightSnackbarPosition.top,
                        autoDismiss: true,
                        snackbarDuration: Durations.extralong4,
                      ).show(context);
                    },
                    child: SizedBox(
                      child: Row(
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
                          Icon(Icons.shopping_cart_outlined, color: Colors.red)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.yellow, size: 18);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.yellow, size: 18);
        } else {
          return const Icon(Icons.star_border, color: Colors.yellow, size: 18);
        }
      }),
    );
  }
}
