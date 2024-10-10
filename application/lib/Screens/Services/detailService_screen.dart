import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/Screens/Reviews/reviews_screen.dart';
import 'package:application/Screens/Services/services_screen.dart';
import 'package:application/bodyToCallAPI/Comment.dart';
import 'package:application/bodyToCallAPI/Service.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailServiceScreen extends StatefulWidget {
  final String serviceCODE;
  final int userID; // Added userID field

  const DetailServiceScreen({
    Key? key,
    required this.serviceCODE,
    required this.userID, // Make userID required as well
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailServiceScreen> {
  bool _loading = true;
  dynamic serviceDetails; // Change the type based on your response
  List<Comment> _comments = [];
  @override
  void initState() {
    super.initState();

    fetchServiceDetails(); // Fetch details when the page initializes
  }

  Future<void> fetchServiceDetails() async {
    final url = Uri.parse(
        'http://localhost:8080/api/service/detail?serviceCODE=${widget.serviceCODE}');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serviceDetails =
              jsonDecode(response.body); // Update with your response structure
          _loading = false;
          if (data['comments'] != null) {
            _comments = (data['comments'] as List)
                .map((commentData) => Comment.fromJson(commentData))
                .toList();
          }

          print("Parsed comments: $_comments.");
          print('User ID nerjdfhjhjhj: ${widget.userID}');

// Stop loading when data is fetched
        });
        print("data: ${serviceDetails}");
      } else {
        throw Exception('Failed to load service details');
      }
    } catch (e) {
      print('Error fetching service details: $e');
      setState(() {
        _loading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Service service = Service.fromJson(serviceDetails);
    return Scaffold(
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
            child: Column(
          children: [
            ClipPath(
              clipper: BottomRoundedClipper(),
              child: Image.asset(
                'assets/icons/Icon.jpg',
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : serviceDetails != null
                      ? Column(
                          children: [
                            _buildServiceDetailView(),
                            const SizedBox(
                                height:
                                    20), // Spacing between service details and button
                            // Add button here
                            _button(service),
                            const SizedBox(height: 20),
                            _buttonBook(),
                            const SizedBox(height: 20),
                          ],
                        )
                      : Center(child: Text('No details available')),
            )
          ],
        )));
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];

    // Determine the number of full, half, and empty stars
    int fullStars = rating.floor(); // Number of full stars
    bool hasHalfStar = (rating % 1) >= 0.5; // Determine if there is a half star

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      );
    }

    // Add half star if needed
    if (hasHalfStar) {
      stars.add(
        Icon(
          Icons.star_half,
          color: Colors.yellow,
        ),
      );
    }

    // Add empty stars to make the total 5
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

  Widget _buildStarRatingForUser(int rating) {
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

  Widget _buildServiceDetailView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adjust or remove this SizedBox for smaller spacing
          _infoItem(
              serviceDetails['serviceNAME'],
              serviceDetails['serviceRATING'],
              serviceDetails['commentCOUNT'],
              serviceDetails['serviceDATE']),

          const SizedBox(height: 20),

          SingleChildScrollView(
            child: Column(
              children: List.generate(_comments.length, (index) {
                print('user image: ${_comments[index].profileIMG}');
                return _Review(_comments[index]);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String name, double rating, int number, String des) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 128),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8, horizontal: 15), // Reduced vertical padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  fontFamily: 'Fredoka',
                ),
              ),
              const SizedBox(
                  height: 8), // Reduced from 20 to 8 for closer spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStarRating(rating),
                  const SizedBox(width: 10),
                  Text(
                    '($number reviews)',
                    style: TextStyle(color: Color(0xffA6A6A6)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _descItem(des),
            ],
          ),
        ),
      ),
    );
  }

  Widget _descItem(String des) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          des,
          style: TextStyle(
              color: Color(0xff191919), fontSize: 16, fontFamily: 'Fredoka'),
        ),
      ],
    );
  }

  Widget _button(Service service) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          print("User ID: ${widget.userID}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewsScreen(
                serviceCODE: serviceDetails['serviceCODE'],
                userID:
                    service.userID, // Ensure you have userID in serviceDetails
              ),
            ),
          );
        },
        child: const Text(
          'See and add more comments', // Button label
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Fredoka',
          ),
        ),
      ),
    );
  }

  Widget _buttonBook() {
    return ElevatedButton(
      onPressed: () {},
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Đẩy icon về bên phải
          children: [
            Center(
              child: Row(
                children: [
                  Text(
                    'Book appointment',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  const SizedBox(width: 30),
                  // Icon bên phải
                  Icon(
                    Icons.book_online, // Thay đổi icon theo ý muốn
                    size: 24, // Kích thước icon
                    // Màu icon
                  ),
                ],
              ),
            )
            // Text ở giữa
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xffffffff), // Màu chữ
        backgroundColor: Color(0xff5CB15A), // Màu nền
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _Review(Comment comment) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    // Parse and format the comment date
    String formattedDate = dateFormat.format(comment.commentDATE);
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar tròn
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    comment.profileIMG != null && comment.profileIMG.isNotEmpty
                        ? comment.profileIMG
                        : 'assets/images/avatar02.jpg',
                    // Thay đổi URL với hình thật
                  ),
                ),
                SizedBox(width: 10),
                // Tên người dùng và thời gian
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.profileNAME,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            // Hiển thị điểm số và các ngôi sao
            Row(
              children: [
                Text(
                  comment.commentRATING.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                _buildStarRatingForUser(comment.commentRATING),
              ],
            ),
            SizedBox(height: 8),
            // Phần bình luận
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  comment.CONTENT,
                  style: TextStyle(
                      color: Color(0xff191919),
                      fontSize: 16,
                      fontFamily: 'Fredoka'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0.0, size.height - 50); // Start point from the bottom left corner
    var controlPoint = Offset(
        size.width / 2, size.height - 100); // Control point for the curve
    var endPoint = Offset(size.width, size.height - 50); // End point
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0); // Connect back to the top right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
