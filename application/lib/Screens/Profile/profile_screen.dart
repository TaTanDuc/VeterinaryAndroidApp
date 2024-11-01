import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/Screens/Profile/addPet_screen.dart';
import 'package:application/Screens/Profile/appointment_screen.dart';
import 'package:application/Screens/Profile/invoice_screen.dart';
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
        Uri.parse('http://10.0.2.2:8080/api/profile/user/get?userID=$ID');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Received data: $data'); // Log the received data for debugging

        setState(() {
          profile = Profile.fromJson(
              data); // Ensure you are calling fromJson correctly
          _loading = false;
          print("Parsed profile: $profile");
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
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
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

  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: const Color(0xFF5CB15A),
  //       title: const Center(
  //         child: Text(
  //           'Profile',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 16,
  //             fontFamily: 'Fredoka',
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: SizedBox(
  //             height: AppBar().preferredSize.height, // Match the AppBar height
  //             child: Image.asset(
  //               'assets/icons/logo.png',
  //               fit: BoxFit.contain,
  //             ),
  //           ),
  //         ),
  //       ],
  //       automaticallyImplyLeading: false,
  //     ),
  //     body: _page(),
  //   );
  // }

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
                    user.profileEMAIL,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateProfileScreen(profile: profile)),
                  );
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
