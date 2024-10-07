import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/pages/Homepage/explore.dart';
import 'package:application/pages/Homepage/home.dart';
//import 'package:application/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      //home: ShopPage(),
      //home: ExplorePage(),
      //home: ServicePage()
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage1(),
    ExplorePage1(),
    ManagePage1(),
    ProfilePage1(),
  ];

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
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: HomePage());
  }
}

class ExplorePage1 extends StatelessWidget {
  const ExplorePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: ExplorePage());
  }
}

class ManagePage1 extends StatelessWidget {
  const ManagePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Manage Page'));
  }
}

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: ProfileScreen());
  }
}
