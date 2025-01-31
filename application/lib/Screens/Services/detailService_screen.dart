import 'package:application/Screens/Appointments/appointment_screen.dart';
import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/Screens/Reviews/reviews_screen.dart';
import 'package:application/Screens/Services/services_screen.dart';
import 'package:application/bodyToCallAPI/Comment.dart';
import 'package:application/bodyToCallAPI/Service.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:application/Screens/Homepage/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailServiceScreen extends StatefulWidget {
  final String serviceCODE;

  const DetailServiceScreen({
    Key? key,
    required this.serviceCODE,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailServiceScreen> {
  bool _loading = true;
  Service? serviceDetails;
  List<Comment> _comments = [];
  @override
  void initState() {
    super.initState();
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    final url = Uri.parse(
        'http://192.168.137.1:8080/api/customer/service/getServiceDetails?serviceCODE=${widget.serviceCODE}');
    setState(() {
      _loading = true; // Start loading
    });
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Cookie': '$session'});

      if (response.statusCode == 200) {
        setState(() {
          final data = jsonDecode(response.body)['returned'];
          print('service: $data');
          serviceDetails = Service.fromJson(data);

          if (data['serviceComments'] != null) {
            _comments = (data['serviceComments'] as List)
                .map((commentData) => Comment.fromJson(commentData))
                .toList();
            print('comment: $_comments');
          } else {
            _comments = [];
          }

          _loading = false;
        });
      } else {
        throw Exception('Failed to load service details');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Service? service = serviceDetails;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServicePage()),
        );
        return false;
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
                height: AppBar().preferredSize.height,
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
                    ? Center(child: const Text('dsdhssjjhdsjhsd'))
                    : serviceDetails != null
                        ? Column(
                            children: [
                              _buildServiceDetailView(),
                              const SizedBox(
                                  height:
                                      20), // Spacing between service details and button
                              _button(service!),
                              const SizedBox(height: 20),
                              _buttonBook(),
                              const SizedBox(height: 20),
                            ],
                          )
                        : Center(child: Text('No details available')),
              )
            ],
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
          _infoItem(serviceDetails?.serviceName, serviceDetails?.serviceRating,
              serviceDetails?.workingDate),
          const SizedBox(height: 20),
          SingleChildScrollView(
            child: Column(
              children: List.generate(_comments.length, (index) {
                return _Review(_comments[index]);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String? name, double? rating, String? des) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 128),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name ??
                    'Service Name Unavailable', // Default value for null name
                style: TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  fontFamily: 'Fredoka',
                ),
                overflow: TextOverflow.ellipsis, // Handle overflow
                maxLines: 1, // Limit to one line
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStarRating(rating ?? 0),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 15),
              _descItem(des ??
                  'Description Unavailable'), // Default value for null description
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

  Widget _button(Service? service) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (service != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewsScreen(
                  serviceCODE: service.serviceCode,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Service not available.')),
            );
          }
        },
        child: const Text(
          'See and add more comments',
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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(
                // Ensure you have userID in serviceDetails
                ),
          ),
        );
      },
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
    DateTime dateTime = DateTime.parse(comment.commentTime);

    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
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
                  backgroundImage: NetworkImage(
                    comment.profileIMG,
                  ),
                ),
                SizedBox(width: 10),
                // Tên người dùng và thời gian
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.profileName,
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
            // Phần bình luận
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  comment.content,
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
