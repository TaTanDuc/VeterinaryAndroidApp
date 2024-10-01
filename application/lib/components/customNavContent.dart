import 'package:flutter/material.dart';

class CustomNavContent extends StatelessWidget {
  final String navText;
  final Color backgroundColor;
  final VoidCallback onBackPressed;
  final bool hideImage;
  final String? pathImage;
  final IconData? iconNav;
  final VoidCallback? onNextPressed;

  CustomNavContent(
      {required this.navText,
      required this.onBackPressed,
      this.backgroundColor = const Color(0xFF5CB15A),
      this.hideImage = false,
      this.iconNav,
      this.onNextPressed,
      this.pathImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: Color(0xff5CB15A),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: onBackPressed,
                  ),
                  Expanded(
                    child: Text(
                      navText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Fredoka',
                        color: Color(0xffFFFFFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      iconNav,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: onNextPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Điều kiện để hiển thị ClipPath khi hideImage == true
        if (hideImage && pathImage != null)
          ClipPath(
            clipper: BottomRoundedClipper(),
            child: Image.asset(
              pathImage!,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 50); // Điểm bắt đầu từ góc trái dưới
    var controlPoint = Offset(
        size.width / 2, size.height - 100); // Điểm điều khiển của đường cong
    var endPoint = Offset(size.width, size.height - 50); // Điểm kết thúc
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0); // Nối lại với góc phải trên
    path.close(); // Đóng đường path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
