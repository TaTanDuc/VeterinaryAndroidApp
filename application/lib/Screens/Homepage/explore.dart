import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:application/Screens/Homepage/service.dart';
import 'package:application/Screens/Homepage/shop.dart';

// Define a simple model class for categories
class Category {
  final String title;
  final String description;
  final Widget Function(int userID) targetPageBuilder; // Page to navigate to

  Category({
    required this.title,
    required this.description,
    required this.targetPageBuilder,
  });
}

class ExplorePage extends StatefulWidget {
  final int userID;

  const ExplorePage({super.key, required this.userID});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // List of categories
  final List<Category> categories = [
    Category(
      title: 'Shop',
      description: 'Explore a variety of products.',
      targetPageBuilder: (userID) =>
          ShopPage(userID: userID), // The target page for this category
    ),
    Category(
      title: 'Service',
      description: 'Find the best services for your needs.',
      targetPageBuilder: (userID) =>
          ServicePage(userID: userID), // Change this to the actual Service page
    ),
    // You can add more categories here
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Navigate to ShopPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                    userID: widget.userID,
                  )), // Replace ShopPage with the actual widget for your shop page
        );
        return false; // Prevent the default pop action
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5CB15A),
          title: const Center(
            child: Text(
              'Detail',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Fredoka',
              ),
            ),
          ),
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: categories.map((category) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  category.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  category.description,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          OverflowBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                child: const Text('Explore'),
                                onPressed: () {
                                  // Navigate to the target page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => category
                                          .targetPageBuilder(widget.userID),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(), // Create cards dynamically from the list
            ),
          ),
        ),
      ),
    );
  }
}
