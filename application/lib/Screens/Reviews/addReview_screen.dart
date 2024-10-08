import 'package:application/Screens/Reviews/reviews_screen.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class AddReviewScreen extends StatefulWidget {
  @override
  State<AddReviewScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddReviewScreen> {
  int hoveredIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Scaffold(
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
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    _infoUser(),
                    const SizedBox(height: 20),
                    _listStars(),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft, // Căn lề trái
                      child: Text(
                        'Share more about your experience',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      autofillHints: [
                        'Share details of your own experience at this place'
                      ],
                      minLines: 8,
                      maxLines:
                          null, // Để TextField tự điều chỉnh độ cao khi nội dung lớn hơn
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        filled: true, // Cho phép nền
                        fillColor: Colors.grey[200], // Màu nền của TextField
                        hintText:
                            'Share details of your own experience at this place', // Gợi ý văn bản
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Góc bo tròn cho viền
                          borderSide: BorderSide(
                            color: Colors.grey, // Màu viền
                            width: 2, // Độ dày của viền
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey, // Viền khi chưa được chọn
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.green, // Viền khi TextField được chọn
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // CustomButton(
                    //     text: 'Post Review',
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 ReviewsScreen()), // Điều hướng đến trang mới
                    //       ); //
                    //     })
                  ]),
            ),
          ),
        ),
        // CustomNavContent(
        //     navText: 'Add Review',
        //     onBackPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 ReviewsScreen()), // Điều hướng đến trang mới
        //       ); //
        //     })
      ],
    );
  }

  Widget _listStars() {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      hoveredIndex =
                          index; // Khi hover vào một ngôi sao, cập nhật index
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      hoveredIndex =
                          -1; // Trở lại trạng thái ban đầu khi rời khỏi ngôi sao
                    });
                  },
                  child: Image.asset(
                    hoveredIndex >=
                            index // Kiểm tra nếu index hiện tại nhỏ hơn hoặc bằng hoveredIndex
                        ? 'assets/icons/star_yellow.png' // Hình ảnh màu vàng khi hover
                        : 'assets/icons/star_icon1.png', // Hình ảnh bình thường
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoUser() {
    return Container(
      child: Row(
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
    );
  }
}
