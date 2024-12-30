import 'package:application/Screens/Appointments/appointment_screen.dart';
import 'package:application/Screens/Chat/chatbox_screen.dart';
import 'package:application/Screens/Chat/select_chatbox.dart';
import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/Screens/Payment/MethodPayment.dart';
import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/Screens/Homepage/explore.dart';
import 'package:application/Screens/Homepage/home.dart';
import 'package:application/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      HomePage1(),
      ExplorePage1(),
      ManagePage1(),
      ProfilePage1(),
    ];
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
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
          icon: Icon(Icons.book_online_outlined),
          label: 'Book appointment',
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
  HomePage1();

  @override
  Widget build(BuildContext context) {
    return Center(child: HomePage());
  }
}

class ExplorePage1 extends StatelessWidget {
  ExplorePage1();
  @override
  Widget build(BuildContext context) {
    return Center(child: ExplorePage());
  }
}

class ManagePage1 extends StatelessWidget {
  ManagePage1();

  @override
  Widget build(BuildContext context) {
    return Center(child: AppointmentScreen());
  }
}

class ProfilePage1 extends StatelessWidget {
  ProfilePage1();

  @override
  Widget build(BuildContext context) {
    return Center(child: ProfileScreen()); // Truyền userID xuống HomePage
  }
}
