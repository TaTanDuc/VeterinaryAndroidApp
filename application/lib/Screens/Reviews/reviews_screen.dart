import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/Screens/Reviews/addReview_screen.dart';
import 'package:application/Screens/Services/detailService_screen.dart';
import 'package:application/bodyToCallAPI/Comment.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:application/Screens/Homepage/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  final String serviceCODE;

  const ReviewsScreen({
    Key? key,
    required this.serviceCODE,
  }) : super(key: key);
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
  }

  Future<void> fetchRatings() async {
    setState(() {
      _loading = false;
    });

    final url =
        'http://192.168.137.1:8080/api/customer/service/getOverAll?serviceCODE=${widget.serviceCODE}';
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(Uri.parse(url),
          headers: {'Content-Type': 'application/json', 'Cookie': '$session'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body)['returned'];
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
        'http://192.168.137.1:8080/api/customer/service/getServiceDetails?serviceCODE=${widget.serviceCODE}');

    setState(() {
      _loading = true;
    });

    setState(() {
      _loading = true;
    });

    try {
      final session = await SessionManager().getSession();
      final response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Cookie': '$session'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['returned'];

        if (data['serviceComments'] != null) {
          _comments = (data['serviceComments'] as List)
              .map((commentData) => Comment.fromJson(commentData))
              .toList();
          Check = data["serviceRating"];
        } else {
          _comments = [];
        }

        serviceCommnets = data;
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
        'http://192.168.137.1:8080/api/customer/service/getServiceDetails?serviceCODE=${widget.serviceCODE}');

    try {
      final session = await SessionManager().getSession();
      final response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Cookie': '$session'});

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body)['returned']['serviceComments'];
        setState(() {
          _comments = data.map((json) => Comment.fromJson(json)).toList();
          _loading = false;
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailServiceScreen(
                          serviceCODE: widget.serviceCODE,
                        )),
              );
            },
          ),
          backgroundColor: const Color(0xFF5CB15A),
          title: const Center(
            child: Text(
              'Review',
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
                child: IconButton(
                  icon: const Icon(
                    Icons.reviews_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReviewScreen(
                          serviceCODE: serviceCommnets['serviceCode'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
                  padding: const EdgeInsets.fromLTRB(0, 95, 0, 0),
                  child: Column(
                    // Wrap the widgets inside a Column
                    children: [
                      serviceCommnets == null
                          ? Center(child: CircularProgressIndicator())
                          : _evaluate(Check),
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
                    ? Center(child: CircularProgressIndicator())
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
        ],
      ),
    );
  }

  Widget _evaluate(double rating) {
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
            _buildStarRating(serviceCommnets['serviceRating'] ?? 0.0),
          ],
        ),
      ],
    );
  }

  Widget _addReviewButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double topPadding = screenWidth < 600 ? 20 : 40;
    double rightPadding = screenWidth < 600 ? 15 : 20;
    double iconSize = screenWidth < 600 ? 20 : 30;

    return Positioned(
      top: topPadding,
      right: rightPadding,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(
                serviceCODE: serviceCommnets['serviceCODE'],
              ),
            ),
          );
          print('This is ID: ${serviceCommnets['serviceCODE']}');
        },
        child: Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Image.asset(
            'assets/icons/add_review.png',
            width: iconSize,
            height: iconSize,
          ),
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
    DateTime dateTime = DateTime.parse(comment.commentTime);

    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    final screenWidth = MediaQuery.of(context).size.width;

    double responsiveFontSize = screenWidth < 600 ? 12 : 18;

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    comment.profileIMG,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.profileName != null &&
                                comment.profileName.isNotEmpty
                            ? comment.profileName
                            : 'Unknown User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveFontSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth < 600 ? 12 : 14,
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
            Row(
              children: [
                Text(
                  comment.serviceRating.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                _buildStarRatingForUser(comment.serviceRating),
              ],
            ),
            SizedBox(height: 8),
            Text(
              comment.content,
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
    path.lineTo(0.0, size.height - 50);
    var controlPoint = Offset(size.width / 2, size.height - 100);
    var endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
