import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
// Track the selected category index

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Center(
          child: Text(
            'Service', // Văn bản bạn muốn thêm
            style: TextStyle(
              color: Colors.white, // Màu chữ
              fontSize: 16,
              fontFamily: 'Fredoka', // Kích thước chữ
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: AppBar().preferredSize.height, // Match the AppBar height
              child: Image.asset(
                'assets/icons/logo.png',
                fit: BoxFit.contain, // Fit the logo within the available space
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
            const SizedBox(height: 0),
            Padding(
                padding: const EdgeInsets.all(
                    16.0), // Set the desired padding (which acts like a margin)
                child: const Text(
                  "Our Service",
                  style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
            Center(
              child: Column(
                children: [
                  _buildSServiceCard('Josera', 'Josera Dog Master Mix 500g',
                      'assets/icons/logo.png', 5),
                  _buildSServiceCard('Happy Pet', 'Happy Dog High Energy 30-20',
                      'assets/icons/logo.png', 3),
                  _buildSServiceCard('Josera', 'Josera Dog Master Mix 500g',
                      'assets/icons/logo.png', 4),
                  _buildSServiceCard('Happy Pet', 'Happy Dog High Energy 30-20',
                      'assets/icons/logo.png', 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopRow(
      String service, String description, String imagePath, int rating) {
    // Method to build the star rating
    Widget _buildStarRating(int rating) {
      List<Widget> stars = [];
      for (int i = 0; i < 5; i++) {
        stars.add(
          Icon(
            i < rating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
        );
      }
      return Row(
        children: stars,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Get the available width
        double width = constraints.maxWidth;

        // Calculate font size based on width
        double fontSize = width < 400 ? 14 : (width < 600 ? 16 : 18);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: 100, // Set a fixed width for the image
                    height: 100, // Set a fixed height for the image
                  ),
                ],
              ),
              SizedBox(width: 20), // Space between the items
              Expanded(
                // Use Expanded to allow flexible space usage
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text(
                      service,
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style:
                          TextStyle(fontSize: fontSize, fontFamily: 'Fredoka'),
                      maxLines: 3, // Limit the number of lines
                      overflow:
                          TextOverflow.ellipsis, // Add ellipsis if overflow
                    ),
                    SizedBox(height: 8), // Space between description and rating
                    _buildStarRating(rating), // Display star rating
                    SizedBox(height: 8),
                    Container(
                      // Align the text to the bottom center
                      child: GestureDetector(
                        onTap: () {
                          // Add your tracking logic here
                        },
                        child: const Text(
                          'Show more',
                          style: TextStyle(
                            color: Color.fromARGB(255, 206, 51,
                                234), // Optional: Change text color to indicate it's clickable
                            fontSize:
                                16, // Optional: Adjust font size as needed
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSServiceCard(
      String service, String description, String imagePath, int rating) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: screenWidth * 0.8,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildShopRow(service, description, imagePath, rating),
            ],
          ),
        ),
      ),
    );
  }
}
