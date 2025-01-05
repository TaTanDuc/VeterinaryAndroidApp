import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/Screens/Profile/addPet_screen.dart';
import 'package:application/Screens/Profile/appointment_screen.dart';
import 'package:application/Screens/Profile/createProfile.dart';
import 'package:application/Screens/Profile/invoice_screen.dart';
import 'package:application/Screens/Profile/updateProfile.dart';
import 'package:application/bodyToCallAPI/Profile.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/controllers/GoogleController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;

  dynamic profile;
  String link = '';

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final url = Uri.parse('http://192.168.137.1:8080/api/customer/profile/get');

    try {
      final session = await SessionManager().getSession();
      final response = await http.get(url,
          headers: {'Content-Type': 'application/json', 'Cookie': '$session'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['returned'];
        print('Received data: $data');

        setState(() {
          profile = Profile.fromJson(data);
          _loading = false;
          link = profile.profileIMG;
        });
      } else {
        throw Exception('Failed to load profile details');
      }
    } catch (e) {
      print('Error fetching profile details: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                height:
                    AppBar().preferredSize.height, // Match the AppBar height
                child: Image.asset(
                  'assets/icons/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          ClipPath(
            clipper: BottomRoundedClipper(),
            child: Image.network(
              link,
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
                userManager.clearUsername(); // Clear user session

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

  Future<void> check(context) async {
    final sm = await SessionManager().getSession();
    final response = await http.get(
        Uri.parse('http://192.168.137.1:8080/api/customer/profile/get'),
        headers: {'cookie': '$sm'});
    try {
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateProfileScreen(
              profile: profile,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfileScreen(),
          ),
        );
      }
    } catch (ex) {
      rethrow;
    }
  }

  Widget _infoUser(Profile user) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Set button dimensions and responsive font size
    double buttonWidth = screenWidth < 600 ? screenWidth * 0.8 : 100;
    double buttonHeight = 40;
    double responsiveFontSize = screenWidth < 600 ? 16 : 20;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 15, 15, 30),
        child: Column(
          children: [
            // Responsive layout for small and large screens
            if (screenWidth < 600) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.profileNAME ?? 'Unknown',
                    style: TextStyle(
                      fontSize: responsiveFontSize,
                      color: Color(0xff141415),
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _signOut();
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.red),
                      label: Text(
                        'Sign out',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveFontSize,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user.profileNAME ?? 'Unkonw',
                    style: TextStyle(
                        fontSize: responsiveFontSize,
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
                        fontSize: responsiveFontSize,
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
            ],
            const SizedBox(height: 20),
            // Email Row
            Row(
              children: [
                Icon(Icons.email),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user.Email!,
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: responsiveFontSize,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Phone Row
            Row(
              children: [
                Icon(Icons.call),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user.phone ?? 'Unknown need to update',
                    style: TextStyle(
                      fontSize: responsiveFontSize,
                      color: Color(0xff000000),
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              ],
            ),
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
                  check(context);
                },
                child: _optionItem(Icons.person, 'Update Information'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPetScreen()),
                  );
                },
                child: _optionItem(Icons.pets, 'Add your pet'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListApointment()),
                  );
                },
                child: _optionItem(Icons.book, 'Show all apponitments'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListOrder()),
                  );
                },
                child: _optionItem(Icons.gif_box, 'My orders'),
              ),
            ],
          )),
    );
  }

  Widget _optionItem(IconData icon, String nameItem) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size, with a maximum value of 20
    double responsiveFontSize = screenWidth < 600 ? 16 : 20;
    responsiveFontSize = responsiveFontSize > 20 ? 20 : responsiveFontSize;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // Vertical padding
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Ensure spacing between elements
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 24), // Icon size for consistency
                const SizedBox(width: 30),
                // The nameItem Text widget
                Expanded(
                  child: Text(
                    nameItem,
                    style: TextStyle(
                      fontSize: responsiveFontSize,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000),
                      fontFamily: 'Fredoka',
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Handle overflow gracefully
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 30,
          ),
        ],
      ),
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
