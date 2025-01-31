import 'package:application/Screens/Appointments/appointment_screen.dart';
import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/Screens/Homepage/explore.dart';
import 'package:application/Screens/Homepage/home.dart';
import 'package:application/Screens/Providers/googleSignin.dart';
import 'package:application/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51QXwiTC5mILZpjuwuFliYwCHPgV04qQErHY6cNGhvVQU8gGo2LsqD0WlavJ2zghYTKJdf6Hdhc8VZ2DsDvYj30PA00Kzc3pIYE";
  await Stripe.instance.applySettings();
  // await Firebase.initializeApp();

  // // Activate Firebase App Check
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  dynamic ID;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        ));
  }
}

class MainPage extends StatefulWidget {
  // Nhận userID từ trang trước

  const MainPage();
  @override
  // ignore: library_private_types_in_public_api
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
      HomePage1(),
      ExplorePage1(),
      ManagePage1(),
      ProfilePage1(),
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
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: HomePage()); // Truyền userID xuống HomePage
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
    return Center(child: AppointmentScreen());
  }
}

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: ProfileScreen());
  }
}
