import "dart:convert";

import "package:application/Screens/Login/login_screen.dart";
import "package:application/components/customButton.dart";
import "package:application/components/customInputField.dart";
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedController = TextEditingController();
  String _errorMessage = "";
  Future<void> _register() async {
    setState(() {
      _errorMessage = ''; // Xóa thông báo lỗi trước đó
    });
    try {
      final url = Uri.parse("http://localhost:8080/api/user/login");
      if (usernameController.text.isEmpty ||
          passwordController.text.isEmpty ||
          emailController.text.isEmpty ||
          confirmedController.text.isEmpty) {
        setState(() {
          _errorMessage =
              'Input data cannot be empty'; // Hiển thị thông báo lỗi
        });
        return;
      }
      if (passwordController.text != confirmedController.text) {
        setState(() {
          _errorMessage =
              'Confirm Password must be the same as Password'; // Hiển thị thông báo lỗi
        });
        return;
      }
      // Gửi yêu cầu POST tới API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": usernameController.text, // Lấy text từ usernameController
          "email": emailController.text, // Lấy text từ usernameController
          "password": passwordController.text
        }),
      );
      print(response.statusCode);
      print(response.body);
      // Kiểm tra trạng thái của API trả về
      if (response.statusCode == 200) {
        // Nếu đăng nhập thành công, chuyển tới MainPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        setState(() {
          _errorMessage = response.body; // Hiển thị thông báo lỗi
        });
        return;
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _icon(),
                  const SizedBox(height: 50),
                  _extraText(),
                  const SizedBox(height: 40),
                  CustomInput(
                      hintText: 'Email',
                      hintTextColor: Color(0xFFA6A6A6),
                      controller: emailController,
                      pathImage: 'assets/icons/mail.png'),
                  const SizedBox(height: 20),
                  CustomInput(
                      hintText: 'Username',
                      hintTextColor: Color(0xFFA6A6A6),
                      controller: usernameController,
                      pathImage: 'assets/icons/user.jpg'),
                  const SizedBox(height: 20),
                  CustomInput(
                    hintText: 'Password',
                    hintTextColor: Color(0xFFA6A6A6),
                    controller: passwordController,
                    pathImage: 'assets/icons/lock.png',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  CustomInput(
                    hintText: 'Confirm Password',
                    hintTextColor: Color(0xFFA6A6A6),
                    controller: confirmedController,
                    pathImage: 'assets/icons/confirmed_icon.png',
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'Register',
                    onPressed: _register,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildErrorMessage(),
                  const SizedBox(height: 20),
                  _infoRegister(),
                ],
              ),
            ),
          ),
        ),
        _topRightImages(), // Thêm hình ảnh ở góc trên bên phải
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Text(_errorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontFamily: 'Fredoka',
        ));
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

  Widget _extraText() {
    return const Text(
      "Register now to become a member of the veterinary community on our app and receive special offers and care services just for your pet.",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16, color: Color(0xFF747070), fontFamily: 'Fredoka'),
    );
  }

  Widget _infoRegister() {
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

  Widget _topRightImages() {
    return Stack(
      children: [
        Positioned(
          top: -40, // Vị trí của ảnh thứ hai
          right: 20, // Điều chỉnh khoảng cách giữa hai ảnh
          child: Container(
            width: 100,
            height: 100,
            child: Image.asset('assets/icons/icon2.png'), // Ảnh thứ hai
          ),
        ),
        Positioned(
          top: -50, // Vị trí của ảnh thứ nhất
          right: -75,
          // Xoay 30 độ cho ảnh đầu tiên
          child: Container(
            width: 200, // Đặt chiều rộng của hình ảnh
            height: 200, // Đặt chiều cao của hình ảnh
            child: Image.asset('assets/icons/icon1.png'), // Ảnh đầu tiên
          ),
        ),
      ],
    );
  }
}
