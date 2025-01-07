import 'dart:math';

import 'package:application/Screens/Chat/Client.dart';
import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:application/Screens/Chat/chatbox_screen.dart';
import 'package:application/Screens/Chat/select_chatbox.dart';
import 'package:application/bodyToCallAPI/Pet.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/Shop.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  List<Pet> _pets = [];
  List<Shop> _randItem = [];
  dynamic ID;

  @override
  void initState() {
    super.initState();
    fetchPets();
    fetchShops(); // Call fetchPets when the widget is initialized
  }

  // Method to fetch pets from API
  Future<void> fetchPets() async {
    final url = Uri.parse(
        'http://192.168.137.1:8080/api/customer/pet'); // Replace with your actual API URL
    try {
      final session = await SessionManager().getSession();
      print('Session: $session');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session',
        },
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> shopData = jsonDecode(response.body)['returned'];

        setState(() {
          _pets = shopData.map((json) => Pet.fromJson(json)).toList();
          _loading = false;
        });
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> fetchShops() async {
    final url =
        Uri.parse('http://192.168.137.1:8080/api/customer/shop/getRandom');
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session'
        }, // Optional for GET
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> shopData = jsonDecode(response.body)['returned'];
        setState(() {
          _randItem = shopData.map((json) => Shop.fromJson(json)).toList();
          _loading = false;
          print('Mapped shops: $_randItem');
        });
      } else {
        throw Exception('Failed to load shop');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5CB15A),
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
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 4, 4, 4),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/mypet.png',
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 10),
                            _loading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : _pets.isEmpty
                                    ? const Center(
                                        child: Text('No pets found.'))
                                    : SizedBox(
                                        height:
                                            100, // Set a fixed height for the horizontal ListView
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _pets.length,
                                          itemBuilder: (context, index) {
                                            return _buildPetCard(_pets[index]);
                                          },
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // The rest of the UI for the Shop section, etc.
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 4, 4, 4),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag), // Biểu tượng
                                  const SizedBox(
                                    height: 50,
                                    width: 8,
                                  ), // Khoảng cách giữa biểu tượng và nhãn
                                  const Text(
                                    'Shop', // Nhãn
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Fredoka',
                                      fontWeight: FontWeight.bold,
                                    ), // Bạn có thể điều chỉnh kiểu chữ ở đây
                                  ),
                                ],
                              ),
                              _loading
                                  ? Center(child: Text('No items found.'))
                                  : SizedBox(
                                      height: 330,
                                      child: ListView.builder(
                                        itemCount: _randItem.length,
                                        itemBuilder: (context, index) {
                                          return _buildPetFoodCard(
                                              _randItem[index]);
                                        },
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShopPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Shop Now', // Nhãn
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Fredoka',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Chat Button Section
            Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF5CB15A),
                  onPressed: () {
                    check(context);
                  },
                  child: const Icon(Icons.chat, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    print('Pet fetch:  ${pet.petIMAGE}');
    return Container(
      width: 80,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 60,
                height: 60,
                child: pet.petIMAGE.isNotEmpty
                    ? Image.network(
                        pet.petIMAGE,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/icons/house.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 5),
            // Use a FittedBox to ensure the text adjusts within the fixed size container
            FittedBox(
              fit: BoxFit.scaleDown, // This ensures the text does not overflow
              child: Text(
                pet.petNAME,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetFoodCard(Shop shop) {
    return Card(
      child: ListTile(
        leading: Image.network(shop.itemIMG, width: 50),
        title: Text(shop.itemName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shop.categoryName),
            const SizedBox(height: 5),
            Text(
              '\$${shop.price.toString()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Row(
              children: [
                Text(
                  shop.itemRating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                _buildStarRating(shop.itemRating ?? 0.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];

    int fullStars = rating.floor();
    bool hasHalfStar = (rating % 1) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      );
    }
    if (hasHalfStar) {
      stars.add(
        Icon(
          Icons.star_half,
          color: Colors.yellow,
        ),
      );
    }

    for (int i = stars.length; i < 5; i++) {
      stars.add(
        Icon(
          Icons.star_border,
          color: Colors.yellow,
        ),
      );
    }

    return Row(
      children: stars,
    );
  }
}

Future<void> check(context) async {
  final sm = await SessionManager().getSession();
  final response = await http.get(
      Uri.parse('http://192.168.137.1:8080/getCurrent'),
      headers: {'cookie': '$sm'});
  try {
    if (response.statusCode != 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserChatScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(),
        ),
      );
    }
  } catch (ex) {
    rethrow;
  }
}
