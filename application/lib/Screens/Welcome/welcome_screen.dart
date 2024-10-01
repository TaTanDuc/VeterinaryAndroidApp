import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/Screens/Login/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFF09e8e1),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _icon(),
                const SizedBox(height: 50),
                Text(
                  'Hey! Welcome',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Fredoka',
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 250, // Đặt chiều rộng mong muốn để ép xuống dòng
                  child: Text(
                    'While You Sit and Stay - We\'ll Go Out And Play',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFf4f5f0),
                      fontWeight: FontWeight.w100,
                      height: 1.5,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 50),
                _buttonStarted(),
                const SizedBox(height: 70),
                _infoWelcome(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.rectangle),
      child: Image.asset(
        'assets/icons/Icon.jpg',
        width: 120, // Đặt kích thước
        height: 120,
      ),
    );
  }

  Widget _buttonStarted() {
    return SizedBox(
      width: 500,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegisterScreen()), // Thay RegisterScreen bằng trang đăng ký của bạn
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
          children: [
            Text(
              'GET STARTED',
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Fredoka',
              ),
            ),
            SizedBox(width: 10), // Khoảng cách giữa chữ và icon
            Icon(
              Icons.arrow_forward, // Thay đổi icon tại đây
              size: 30,
              color: Colors.white, // Màu của icon
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFFFFFFFF), // Màu chữ
          backgroundColor: Color(0xFF5CB15A), // Màu nền
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _infoWelcome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF747070),
            fontFamily: 'Fredoka',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF5CB15A),
                fontFamily: 'Fredoka',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
