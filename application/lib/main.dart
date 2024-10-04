import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:application/pages/Homepage/service.dart';
import 'package:application/pages/Homepage/shop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProfileScreen(),
    );
  }
}

class HomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: HomePage());
  }
}

class ExplorePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: ExplorePage());
  }
}

class ManagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Manage Page'));
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Page'));
  }
}
