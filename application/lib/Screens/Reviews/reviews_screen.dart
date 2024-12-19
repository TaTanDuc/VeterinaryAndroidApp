import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/Screens/Reviews/addReview_screen.dart';
import 'package:application/Screens/Services/detailService_screen.dart';
import 'package:application/bodyToCallAPI/Comment.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:application/Screens/Homepage/service.dart';
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
  Map<int, int> _ratings = {};
  double Check = 0.0;
  dynamic ID;
  @override
  void initState() {
    super.initState();
    fetchserviceCommnets();
    fetchRatings();
    fetchCommentsService();
    // Fetch details when the page initializes
  }

  Future<void> fetchRatings() async {
    setState(() {
      _loading = false;
    });
    final url =
        'http://10.0.0.2/api/service/overallRating?serviceCODE=${widget.serviceCODE}'; // Replace with your URL
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _ratings = {
            1: data['1'] ?? 0,
            2: data['2'] ?? 0,
            3: data['3'] ?? 0,
            4: data['4'] ?? 0,
            5: data['5'] ?? 0,
          };
          _loading = false;
          print('xin chao jhdjfdhjfhjfdhfjdfhdjfhdjfhdjhfdjhfgfdj: $data');
        });
      } else {
        throw Exception('Failed to load ratings');
      }
    } catch (error) {
      print(error);
      setState(() {
        _loading = false;
      });
    }
  }

  Map<int, double> calculatePercentages(Map<int, int> ratings) {
    int totalRatings = ratings.values.fold(0, (sum, count) => sum + count);

    if (totalRatings == 0) {
      return {1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0};
    }

    return ratings.map((star, count) {
      return MapEntry(star, count / totalRatings);
    });
  }

  Future<void> fetchserviceCommnets() async {
    final url = Uri.parse(
        'http://10.0.0.2/api/service/detail?serviceCODE=${widget.serviceCODE}');

    setState(() {
      _loading = true; // Start loading
    });

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Process the comments only if available
        if (data['comments'] != null) {
          _comments = (data['comments'] as List)
              .map((commentData) => Comment.fromJson(commentData))
              .toList();
          Check = data["serviceRATING"];
        } else {
          _comments = []; // No comments found
        }

        // Store the service comments if necessary
        serviceCommnets = data; // Update with your response structure
      } else {
        throw Exception('Failed to load service details');
      }
    } catch (e) {
      print('Error fetching service details: $e');
    } finally {
      setState(() {
        _loading = false; // Stop loading in both success and error cases
      });
    }
  }

  Future<void> fetchCommentsService() async {
    setState(() {
      _loading = false;
    });
    final url = Uri.parse(
        'http://10.0.0.2/api/service/comments?serviceCODE=${widget.serviceCODE}');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      final userManager = UserManager(); // Ensure singleton access
      User? currentUser = userManager.user;
      if (currentUser != null) {
        print("User ID in review: ${currentUser.userID}");
        ID = currentUser.userID;
      } else {
        print("No user is logged in in here.");
      }
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _comments = data.map((json) => Comment.fromJson(json)).toList();
          _loading = false;
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
                  padding:
                      const EdgeInsets.fromLTRB(0, 95, 0, 0), // Apply padding
                  child: Column(
                    // Wrap the widgets inside a Column
                    children: [
                      serviceCommnets == null
                          ? Center(child: CircularProgressIndicator())
                          : _evaluate(
                              Check,
                              serviceCommnets['commentCOUNT'] ??
                                  0 // Added fallback
                              ), // Fallback UI
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: _loading
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: buildStarRatingSummary(_ratings),
                              ),
                      )
                    ],
                  ),
                ),
                _loading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show if no comments
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
                MaterialPageRoute(
                    builder: (context) => DetailServiceScreen(
                          serviceCODE: widget.serviceCODE,
                        )),
              ); // Navigate to the previous screen
            },
          ),
          // Positioned(
          //   top: 40, // Distance from the top
          //   right: 20, // Distance from the right
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => AddReviewScreen(
          //                   serviceCODE: serviceCommnets['serviceCODE'],
          //                   userID: ID,
          //                 )),
          //       );
          //       print('This is ID: ${serviceCommnets['serviceCODE']}');
          //     },
          //     child: Image.asset(
          //       'assets/icons/add_review.png', // Path to your icon
          //       width: 30, // Width of the icon
          //       height: 30, // Height of the icon
          //     ),
          //   ),
          // ),
          Stack(
            children: [
              // Your other widgets here
              _addReviewButton(context), // Call the function here
            ],
          ),
        ],
      ),
    );
  }

  Widget _evaluate(double rating, int number) {
    if (serviceCommnets == null) {
      return Text("No ratings available");
    }
    return Column(
      children: [
        Text(
          rating.toString() ?? "N/A",
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStarRating(serviceCommnets['serviceRATING'] ?? 0.0),
          ],
        ),
        Text(
          'Based on ${serviceCommnets['commentCOUNT'] ?? 0} reviews',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF868889),
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget _addReviewButton(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Set responsive values based on screen width
    double topPadding =
        screenWidth < 600 ? 20 : 40; // Vertical distance from the top
    double rightPadding =
        screenWidth < 600 ? 15 : 20; // Horizontal distance from the right
    double iconSize = screenWidth < 600 ? 20 : 30; // Size of the icon

    return Positioned(
      top: topPadding, // Distance from the top
      right: rightPadding, // Distance from the right
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(
                serviceCODE: serviceCommnets['serviceCODE'],
                userID: ID,
              ),
            ),
          );
          print('This is ID: ${serviceCommnets['serviceCODE']}');
        },
        child: Container(
          width: iconSize, // Set width for the container
          height: iconSize, // Set height for the container
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Optional: make the button circular
            color: Colors.white, // Optional: background color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Image.asset(
            'assets/icons/add_review.png', // Path to your icon
            width: iconSize, // Width of the icon
            height: iconSize, // Height of the icon
          ),
        ),
      ),
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

  Widget buildStarRatingSummary(Map<int, int> ratings) {
    Map<int, double> ratingPercentages = calculatePercentages(ratings);

    return Column(
      children: [
        _buildRatingRow('Excellent', Color(0xff2D9A3E), ratingPercentages[5]!),
        SizedBox(height: 20),
        _buildRatingRow('Good', Color(0xff4FD339), ratingPercentages[4]!),
        SizedBox(height: 20),
        _buildRatingRow('Average', Color(0xffCCDF56), ratingPercentages[3]!),
        SizedBox(height: 20),
        _buildRatingRow(
            'Below Average', Color(0xffCDBF3E), ratingPercentages[2]!),
        SizedBox(height: 20),
        _buildRatingRow('Poor', Color(0xffEA6868), ratingPercentages[1]!),
      ],
    );
  }

  Widget _buildRatingRow(String label, Color color, double percentage) {
    return Row(
      children: [
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust responsive font size for profileNAME based on screen width
    double responsiveFontSize =
        screenWidth < 600 ? 12 : 18; // Adjust for smaller screens

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
                // Circular Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    (comment.profileIMG != null &&
                            comment.profileIMG.isNotEmpty)
                        ? comment.profileIMG
                        : 'assets/images/avatar02.jpg',
                  ),
                ),
                SizedBox(width: 10),
                // Use Flexible to ensure the text can wrap or resize
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ensure profile name has a fallback in case it's null or empty
                      Text(
                        comment.profileNAME != null &&
                                comment.profileNAME.isNotEmpty
                            ? comment.profileNAME
                            : 'Unknown User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveFontSize, // Responsive font size
                        ),
                        maxLines: 1, // Restrict to one line
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth < 600
                              ? 12
                              : 14, // Adjust date font size too
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 8),
            // Rating and stars
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
            // Comment content
            Text(
              comment.CONTENT,
              style: TextStyle(
                color: Color(0xff191919),
                fontSize: 16,
                fontFamily: 'Fredoka',
              ),
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
