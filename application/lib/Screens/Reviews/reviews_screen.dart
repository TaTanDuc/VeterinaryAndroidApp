import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/Screens/Reviews/addReview_screen.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  final String serviceCODE;
  final int userID; // Added userID field

  const ReviewsScreen({
    Key? key,
    required this.serviceCODE,
    required this.userID, // Make userID required as well
  }) : super(key: key);
  @override
  State<ReviewsScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ReviewsScreen> {
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  _evaluate(),
                  const SizedBox(height: 30),
                  _buildRatingRow('Excellent', Color(0xff2D9A3E), .9),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildRatingRow('Good', Color(0xff4FD339), .7),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildRatingRow('Average', Color(0xffCCDF56), .5),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildRatingRow('Below Average', Color(0xffCDBF3E), .4),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildRatingRow('Poor', Color(0xffEA6868), .2),
                  const SizedBox(
                    height: 20,
                  ),
                  _itemReview(),
                  const SizedBox(
                    height: 20,
                  ),
                  _itemReview(),
                ],
              ),
            ),
          ),
        ),
        CustomNavContent(
          navText: 'Review',
          onBackPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RegisterScreen()), // Điều hướng đến trang mới
            ); // Quay lại trang trước đó
          },
        ),
        Positioned(
          top: 40, // Khoảng cách từ trên
          right: 20, // Khoảng cách từ bên phải
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReviewScreen()),
              );
            },
            child: Image.asset(
              'assets/icons/add_review.png', // Đường dẫn đến biểu tượng của bạn
              width: 30, // Chiều rộng của biểu tượng
              height: 30, // Chiều cao của biểu tượng
            ),
          ),
        ),
      ],
    );
  }

  Widget _evaluate() {
    return Column(
      children: [
        Text(
          '4.5',
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w800,
              color: Color(0xFF000000)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.yellow, size: 30),
            Icon(Icons.star, color: Colors.yellow, size: 30),
            Icon(Icons.star, color: Colors.yellow, size: 30),
            Icon(Icons.star, color: Colors.yellow, size: 30),
            Icon(Icons.star, color: Colors.grey, size: 30),
          ],
        ),
        Text(
          'Based on 89 reviews',
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF868889),
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w500),
        )
      ],
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

  Widget _itemReview() {
    return Container(
      height: 200,
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
                    'assets/images/avatar01.jpg', // Thay đổi URL với hình thật
                  ),
                ),
                SizedBox(width: 10),
                // Tên người dùng và thời gian
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Haylie Aminoff',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Just now',
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
                  '4.5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4
                          ? Icons.star
                          : Icons.star_half, // 4 sao đầy và 1 sao nửa
                      color: Colors.yellow[700],
                      size: 24,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Phần bình luận
            Text(
              'The thing I like best about COCO is the amount of time it has saved while trying to manage my three pets.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
