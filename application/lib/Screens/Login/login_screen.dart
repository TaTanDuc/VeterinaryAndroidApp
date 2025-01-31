import 'dart:convert'; // Thêm import để xử lý JSON
import 'package:application/Screens/Providers/googleSignin.dart';
import 'package:application/Screens/Login/register_screen.dart'; // Thêm import cho MainPage
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'dart:convert';
import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:provider/provider.dart';
import 'package:application/components/customInputField.dart';
import 'package:application/controllers/GoogleController.dart';
import 'package:application/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
// Import http package

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var session;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _errorMessage = "";
  Future<void> _login() async {
    setState(() {
      _errorMessage = ''; // Xóa thông báo lỗi trước đó
    });
    try {
      final url = Uri.parse('http://192.168.137.1:8080/api/account/login');
      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        setState(() {
          _errorMessage =
              'Input data cannot be empty'; // Hiển thị thông báo lỗi
        });
        return;
      }
      // Gửi yêu cầu POST tới API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userId = data['userID'];
        final token = data['returned']['token'];
        final validationUrl =
            'http://192.168.137.1:8080/api/account/login/validate';
        final validationResponse = await http.get(
          Uri.parse(validationUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (validationResponse.statusCode == 200) {
          print('Token is valid!');
          String? setCookie = validationResponse.headers['set-cookie'];
          if (setCookie != null) {
            // Extract the session value
            final sessionCookie = setCookie.split(';').firstWhere(
                  (part) => part.trim().startsWith('SESSION='),
                  orElse: () => '',
                );

            if (sessionCookie.isNotEmpty) {
              // Rename the cookie to `SESSION`
              final sessionValue = sessionCookie.split('=').last;
              final customSessionCookie = 'SESSION=$sessionValue';
              await SessionManager().saveSession(customSessionCookie);
              final URLgetUsername =
                  'http://192.168.137.1:8080/api/account/login/getUsername';
              final UserNameResponse = await http.get(
                Uri.parse(URLgetUsername),
                headers: {
                  'Content-Type': 'application/json',
                  'Cookie': '$customSessionCookie',
                },
              );
              if (UserNameResponse.statusCode == 200) {
                final info = jsonDecode(UserNameResponse.body);
                print(info);

                final username = info['returned']['userName'];
                final id =
                    int.tryParse(info['returned']['userID'].toString()) ?? 0;
                print('sdsdsdsds: $id');
                final userManager = UserManager();
                userManager.setUsername(username, true, id);
                final test = UserManager().id;
                print('sdsdsdsdsdsdsdsdsdsdsdsd: $test');
              }
              print('Custom Session Cookie: $customSessionCookie');
            } else {
              print('Session cookie not found in headers.');
            }
          } else {
            print('No Set-Cookie header found in the response.');
          }
        } else {
          print('erroe when validate');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
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
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _icon(),
                  const SizedBox(height: 50),
                  CustomInput(
                      hintText: 'Username',
                      hintTextColor: Color(0xFFA6A6A6),
                      controller: usernameController,
                      pathImage: 'assets/icons/mail.png'),
                  const SizedBox(height: 30),
                  CustomInput(
                    hintText: 'Password',
                    hintTextColor: Color(0xFFA6A6A6),
                    controller: passwordController,
                    pathImage: 'assets/icons/lock.png',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  _forgotPasswordText(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF000000), // Màu chữ
                      backgroundColor: Color(0xFF5CB15A), // Màu nền
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'LOGIN',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildErrorMessage(),
                  const SizedBox(height: 30),
                  _infoLogin(),
                  const SizedBox(height: 20),
                  _extraText(),
                  const SizedBox(height: 20),
                  _socialList(),
                ],
              ),
            ),
          ),
        ),
        _topRightImages(), // Thêm hình ảnh ở góc trên bên phải
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

  Widget _buildErrorMessage() {
    return Text(_errorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontFamily: 'Fredoka',
        ));
  }

  Widget _forgotPasswordText() {
    return const Align(
      alignment: Alignment.centerRight, // Căn chữ sang bên phải
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          fontSize: 25,
          color: Color(0xFF5CB15A),
          fontFamily: 'Fredoka',
        ),
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      "or connect with",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 25, color: Color(0xFF747070), fontFamily: 'Fredoka'),
    );
  }

  Widget _topRightImages() {
    return Stack(
      children: [
        Positioned(
          top: -40, // Vị trí của ảnh thứ hai
          right: 20, // Điều chỉnh khoảng cách giữa hai ảnh
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/icons/icon2.png'), // Ảnh thứ hai
          ),
        ),
        Positioned(
          top: -50, // Vị trí của ảnh thứ nhất
          right: -75,
          // Xoay 30 độ cho ảnh đầu tiên
          child: SizedBox(
            width: 200, // Đặt chiều rộng của hình ảnh
            height: 200, // Đặt chiều cao của hình ảnh
            child: Image.asset('assets/icons/icon1.png'), // Ảnh đầu tiên
          ),
        ),
      ],
    );
  }

  Widget _infoLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
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
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            child: Text(
              "Register",
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

  Widget _socialList() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Căn đều khoảng cách giữa các ảnh
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 8), // Khoảng cách giữa các ảnh
          alignment: Alignment.center,
          height: 55,
          width: 55, // Đặt chiều rộng cho mỗi ảnh

          child: Image.asset('assets/icons/facebook_icon.png',
              fit: BoxFit.contain), // Hình ảnh đầu tiên
        ),
        GestureDetector(
          onTap: () async {
            await FirebaseServices().signInWithGoogle();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            height: 55,
            width: 55,
            child: Image.asset(
              'assets/icons/google1.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          height: 55,
          width: 55,
          child: Image.asset('assets/icons/ins_icon.jpg',
              fit: BoxFit.contain), // Hình ảnh thứ ba
        ),
      ],
    );
  }
}
