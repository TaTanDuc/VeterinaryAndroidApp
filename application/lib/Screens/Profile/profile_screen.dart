import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/Screens/Profile/updateProfile.dart';
import 'package:application/bodyToCallAPI/Profile.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
// import 'package:first_flutter/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final int userID;
  const ProfileScreen({required this.userID, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true; // Change the type based on your response

  dynamic profile;
  dynamic ID;

  @override
  void initState() {
    super.initState();
    fetchProfile(); // Fetch details when the page initializes
  }

  Future<void> fetchProfile() async {
    final userManager = UserManager(); // Ensure singleton access
    User? currentUser = userManager.user;

    if (currentUser != null) {
      print("User ID in here: ${currentUser.userID}");
      ID = currentUser.userID;
      print("data: $ID");
    } else {
      print("No user is logged in in HomePage.");
      setState(() {
        _loading = false; // Stop loading if no user is found
      });
      return;
    }

    final url =
        Uri.parse('http://localhost:8080/api/profile/user/get?userID=$ID');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          profile = Profile.fromJson(data); // Assume you have a fromJson method
          _loading = false;
          print('body: $data');
          print("Parsed profile: $profile.");
        });
      } else {
        throw Exception('Failed to load profile details');
      }
    } catch (e) {
      print('Error fetching profile details: $e');
      setState(() {
        _loading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Fredoka',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: AppBar().preferredSize.height, // Match the AppBar height
              child: Image.asset(
                'assets/icons/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: _page(),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          ClipPath(
            clipper: BottomRoundedClipper(),
            child: Image.asset(
              'assets/images/avatar02.jpg',
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 400,
                  ),
                  _loading
                      ? Center(child: CircularProgressIndicator())
                      : profile != null
                          ? Column(
                              children: [
                                _infoUser(profile),
                              ],
                            )
                          : Center(child: Text('No details available')),
                  const SizedBox(height: 50),
                  _optionUser(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final userManager = UserManager();
                userManager.clearUser(); // Clear user session

                Navigator.of(context).pop(); // Close the dialog
                // Use pushAndRemoveUntil for proper navigation
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _infoUser(Profile user) {
    return Container(
      width: double.infinity,
      height: 200,
      // color: Color(0xffFFFFFF),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 15, 15, 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Information',
                  style: TextStyle(
                      fontSize: 26,
                      color: Color(0xff141415),
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w700),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('Sign out button pressed');
                    _signOut(); // Call the sign-out function
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.email),
                const SizedBox(width: 30),
                Text(
                  user.profileEMAIL,
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontFamily: 'Fredoka'),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.call),
                const SizedBox(width: 30),
                Text(
                  user.PHONE ?? 'Unknown need to  update',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontFamily: 'Fredoka'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _optionUser() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
          color: Color(0xffffffff), borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePage(
                              userID: ID,
                            )),
                  );
                },
                child: _optionItem(Icons.person, 'Update Information'),
              ),
            ],
          )),
    );
  }

  Widget _optionItem(icon, nameItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 30),
            Text(
              nameItem,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                  fontFamily: 'Fredoka'),
            )
          ],
        ),
        Icon(
          Icons.chevron_right,
          size: 30,
        ),
      ],
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0.0, size.height - 50); // Start point from the bottom left corner
    var controlPoint = Offset(
        size.width / 2, size.height - 100); // Control point for the curve
    var endPoint = Offset(size.width, size.height - 50); // End point
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0.0); // Connect back to the top right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
