import 'package:application/Screens/Chat/chatbox_screen.dart';
import 'package:application/bodyToCallAPI/Pet.dart';
import 'package:application/bodyToCallAPI/Shop.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:application/Screens/Homepage/shop.dart';
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
        'http://10.0.0.2/api/pet/getUserPets'); // Replace with your actual API URL
    try {
      final userManager = UserManager();
      UserDTO? currentUser = userManager.user;
      var id;
      if (currentUser != null) {
        print("User ID in HomePage: ${currentUser.userID}");
        id = currentUser.userID;
      } else {
        print("No user is logged in in HomePage.");
      }
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userID": id}),
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> shopData = jsonDecode(response.body);

        final userManager = UserManager();
        UserDTO? currentUser = userManager.user;

        if (currentUser != null) {
          print("User ID in HomePage: ${currentUser.userID}");
        } else {
          print("No user is logged in in HomePage.");
        }
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
    final url = Uri.parse('http://10.0.0.2/api/storage/getRandom');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'}, // Optional for GET
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> shopData = jsonDecode(response.body);
        setState(() {
          _randItem = shopData.map((json) => Shop.fromJson(json)).toList();
          _loading = false;
          print('Mapped shops: $_randItem'); // Check the mapped pets
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
                    // My Pets Section
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
                            _loading
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox(
                                    height: 300,
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
                    const SizedBox(height: 10),
                    // Add any other sections here...
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(userId: "1"),
                      ),
                    );
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
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 60, // Same as CircleAvatar diameter (2 * radius)
                    height: 60,
                    child: Image.asset(
                      pet.petIMAGE.isNotEmpty
                          ? pet.petIMAGE
                          : 'assets/icons/house.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  pet.petNAME,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPetFoodCard(Shop shop) {
    return Card(
      child: ListTile(
        leading: Image.asset(shop.itemIMAGE, width: 50),
        title: Text(shop.itemNAME),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
          children: [
            Text(shop.itemDESCRIPTION), // Description
            const SizedBox(height: 5), // Spacing between description and price
            Text(
              '\$${shop.itemPRICE.toString()}', // Price
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the price bold
                color: Colors.green, // Color of the price
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
