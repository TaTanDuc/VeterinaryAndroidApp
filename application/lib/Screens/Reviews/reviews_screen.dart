import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/Screens/Reviews/addReview_screen.dart';
import 'package:application/bodyToCallAPI/Comment.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  final String serviceCODE;
  final int userID; // Added userID field

  const ReviewsScreen(
      {Key? key,
      required this.serviceCODE,
      required this.userID // Make userID required as well
      })
      : super(key: key);
  @override
  State<ReviewsScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ReviewsScreen> {
  bool _loading = true; // Change the type based on your response
  List<Comment> _comments = [];
  dynamic serviceCommnets;
  dynamic ID;
  @override
  void initState() {
    super.initState();

    fetchCommentsService();
    fetchserviceCommnets(); // Fetch details when the page initializes
  }

  Future<void> fetchserviceCommnets() async {
    final url = Uri.parse(
        'http://localhost:8080/api/service/detail?serviceCODE=${widget.serviceCODE}');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serviceCommnets =
              jsonDecode(response.body); // Update with your response structure
          _loading = false;
          if (data['rating'] != null) {
            _comments = (data['comments'] as List)
                .map((commentData) => Comment.fromJson(commentData))
                .toList();
          }

          print("Parsed comments: $_comments.");
          print('User ID nerjdfhjhjhj: ${data['serviceCODE']}');

// Stop loading when data is fetched
        });
        print("data: ${serviceCommnets}");
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

  Future<void> fetchCommentsService() async {
    final url = Uri.parse(
        'http://localhost:8080/api/service/comments?serviceCODE=${widget.serviceCODE}');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final userManager = UserManager(); // Ensure singleton access
        User? currentUser = userManager.user;
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _loading = false;
          _comments = data.map((json) => Comment.fromJson(json)).toList();
          print("Parsed comments: $_comments.");
          if (currentUser != null) {
            print("User ID in review: ${currentUser.userID}");
            ID = currentUser.userID;
          } else {
            print("No user is logged in in HomePage.");
          }

// Stop loading when data is fetched
        });
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
    return Container(
      height: double.infinity,
      child: Scaffold(
        backgroundColor: Color(0xffEBEBEB),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0), // Apply padding
                  child: Column(
                    // Wrap the widgets inside a Column
                    children: [
                      const SizedBox(height: 80),
                      _evaluate(serviceCommnets['serviceRATING'],
                          serviceCommnets['commentCOUNT']),
                      const SizedBox(height: 30),
                      _buildRatingRow('Excellent', Color(0xff2D9A3E), .9),
                      const SizedBox(height: 20),
                      _buildRatingRow('Good', Color(0xff4FD339), .7),
                      const SizedBox(height: 20),
                      _buildRatingRow('Average', Color(0xffCCDF56), .5),
                      const SizedBox(height: 20),
                      _buildRatingRow('Below Average', Color(0xffCDBF3E), .4),
                      const SizedBox(height: 20),
                      _buildRatingRow('Poor', Color(0xffEA6868), .2),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                _loading
                    ? Center(
                        child:
                            Text('No comments found.')) // Show if no comments
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: List.generate(
                            _comments.length,
                            (index) => _Review(_comments[index]),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          CustomNavContent(
            navText: 'Review',
            onBackPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              ); // Navigate to the previous screen
            },
          ),
          Positioned(
            top: 40, // Distance from the top
            right: 20, // Distance from the right
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddReviewScreen(
                            serviceCODE: serviceCommnets['serviceCODE'],
                            userID: ID,
                          )),
                );
              },
              child: Image.asset(
                'assets/icons/add_review.png', // Path to your icon
                width: 30, // Width of the icon
                height: 30, // Height of the icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _evaluate(double rating, int number) {
    return Column(
      children: [
        Text(
          rating.toString(),
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStarRating(rating),
          ],
        ),
        Text(
          'Based on $number reviews',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF868889),
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w500),
        )
      ],
    );
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

  Widget _buildRatingRow(String label, Color color, double percentage) {
    return Row(
      children: [
        // Text label
        SizedBox(
          width: 200,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Fredoka',
                color: Color(0xff868889)),
          ),
        ),
        SizedBox(width: 10),
        // Progress Bar
        Expanded(
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navReview() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Color(0xff5CB15A),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: 30),
            const SizedBox(width: 30),
            Expanded(
              child: Text(
                'Review',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Fredoka',
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      )),
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
