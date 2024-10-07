// import 'package:flutter/material.dart';
// import 'package:tesst/pages/shop.dart';

// class ExplorePage extends StatefulWidget {
//   const ExplorePage({super.key});

//   @override
//   _ExplorePageState createState() => _ExplorePageState();
// }

// class _ExplorePageState extends State<ExplorePage> {
//   int _selectedCategoryIndex = 0; // Track the selected category index

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF5CB15A),
//         title: const Center(
//           child: Text(
//             'Explore', // Văn bản bạn muốn thêm
//             style: TextStyle(
//               color: Colors.white, // Màu chữ
//               fontSize: 16,
//               fontFamily: 'Fredoka', // Kích thước chữ
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Explore Section

//             Padding(
//               padding: EdgeInsets.all(12.0),
//               child: Wrap(
//                 runSpacing: 30, // Vertical space between rows
//                 //spacing: 100, // Horizontal space between items
//                 direction: Axis.horizontal,
//                 alignment: WrapAlignment.center,
//                 runAlignment: WrapAlignment.center,
//                 children: [

//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }
import 'package:flutter/material.dart';
import 'package:application/pages/Homepage/service.dart';
import 'package:application/pages/Homepage/shop.dart';

// Define a simple model class for categories
class Category {
  final String title;
  final String description;
  final Widget targetPage; // Page to navigate to

  Category(
      {required this.title,
      required this.description,
      required this.targetPage});
}

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // List of categories
  final List<Category> categories = [
    Category(
      title: 'Shop',
      description: 'Explore a variety of products.',
      targetPage: const ShopPage(), // The target page for this category
    ),
    Category(
      title: 'Service',
      description: 'Find the best services for your needs.',
      targetPage: const ServicePage(), // Change this to the actual Service page
    ),
    // You can add more categories here
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Center(
          child: Text(
            'Explore', // Title of the page
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 16,
              fontFamily: 'Fredoka', // Font family
            ),
          ),
        ),
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                      builder: (context) =>
                                          category.targetPage),
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
    );
  }
}
