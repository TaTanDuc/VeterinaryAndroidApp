import 'package:application/Screens/Appointments/appointment_screen.dart';
import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/Screens/Services/detailService_screen.dart';
import 'package:application/pages/Homepage/explore.dart';
import 'package:application/pages/Homepage/home.dart';
//import 'package:application/profile.dart';
import 'package:flutter/material.dart';
import 'package:application/pages/Homepage/service.dart';
import 'package:application/pages/Homepage/shop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: LoginScreen(),
      home: AppointmentScreen(),
      //home: ShopPage(),
      //home: ExplorePage(),
      //home: ServicePage(),
      // home: DetailServiceScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  final int userID; // Nhận userID từ trang trước

  const MainPage({required this.userID});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các trang với userID được truyền vào từ widget
    _children = [
      HomePage1(userID: widget.userID),
      ExplorePage1(
        userID: widget.userID,
      ),
      ManagePage1(userID: widget.userID),
      ProfilePage1(userID: widget.userID),
    ];
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index; // Cập nhật chỉ số trang hiện tại
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF5CB15A),
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.black,
      currentIndex: _currentIndex,
      onTap: onTappedBar,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Manage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

class HomePage1 extends StatelessWidget {
  final int userID; // Nhận userID qua constructor

  HomePage1({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: HomePage(userID: userID)); // Truyền userID xuống HomePage
  }
}

class ExplorePage1 extends StatelessWidget {
  final int userID; // Nhận userID qua constructor

  ExplorePage1({required this.userID});
  @override
  Widget build(BuildContext context) {
    return Center(child: ExplorePage(userID: userID));
  }
}

class ManagePage1 extends StatelessWidget {
  final int userID; // Nhận userID qua constructor

  ManagePage1({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ManagePage1(userID: userID)); // Truyền userID xuống HomePage
  }
}

class ProfilePage1 extends StatelessWidget {
  final int userID; // Nhận userID qua constructor

  ProfilePage1({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ProfilePage1(userID: userID)); // Truyền userID xuống HomePage
  }
}
