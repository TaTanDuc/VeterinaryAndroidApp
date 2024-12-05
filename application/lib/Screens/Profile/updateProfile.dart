import 'dart:convert';
import 'package:application/bodyToCallAPI/Profile.dart';
import 'package:application/main.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Profile profile; // Pass the profile data to this screen

  const UpdateProfileScreen({required this.profile, super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool? selectedGender;
  String? imagePath;
  dynamic ID;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Populate text fields with the user's current profile data
    nameController.text = widget.profile.profileNAME;
    emailController.text = widget.profile.profileEMAIL;
    ageController.text = widget.profile.age.toString();
    phoneController.text = widget.profile.phone;
    selectedGender = widget.profile.gender;
    imagePath = widget.profile.profileIMG;
  }

  Future<void> fetchUpdateUser() async {
    final userManager = UserManager(); // Ensure singleton access
    User? currentUser = userManager.user;

    if (currentUser != null) {
      print("User ID in here: ${currentUser.userID}");
      ID = currentUser.userID;
    } else {
      print("No user is logged in.");
      return;
    }

    setState(() {
      _loading = true;
    });

    final url = Uri.parse('http://10.0.2.2:8080/api/profile/user/update');

    try {
      int? age;
      if (ageController.text.isNotEmpty) {
        age = int.tryParse(ageController.text);
        if (age == null) {
          print('Invalid age input: ${ageController.text}');
          return; // Exit early if age is invalid
        }
      } else {
        print('Age input is empty.');
        return; // Exit early if age is empty
      }

      Profile profileDTO = Profile(
        userID: currentUser.userID,
        profileIMG: imagePath!,
        profileNAME: nameController.text,
        profileEMAIL: emailController.text,
        age: age,
        phone: phoneController.text,
        gender: selectedGender!,
      );

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileDTO.toJson()), // Convert ProfileDTO to JSON
      );

      print('Raw response: ${response.body}'); // Log the raw response

      if (response.statusCode == 200) {
        // Handle successful response
        print('User profile updated successfully: ${response.body}');
        DelightToastBar(
          builder: (context) {
            return const ToastCard(
              leading: Icon(Icons.check, size: 20),
              title: Text(
                'Update successful',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Fredoka',
                  color: Color(0xff5CB15A),
                ),
              ),
            );
          },
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: Durations.extralong4,
        ).show(context);
        // No need to decode, as the response is a plain string

        // Navigate to the ProfilePage and pass the updated ID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        // Handle error response
        print('Update failed with status code: ${response.statusCode}');
        final errorMessage = response.body; // Log raw error message
        print('Error updating profile: $errorMessage');
      }
    } catch (e) {
      print('Error occurred while updating profile: $e');
    } finally {
      setState(() {
        _loading = false;
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
            'Update user',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  errorText:
                      ageController.text.isEmpty ? 'Age is required' : null,
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  errorText:
                      phoneController.text.isEmpty ? 'Phone is required' : null,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              DropdownButton<bool>(
                value: selectedGender, // Set the value based on the boolean
                hint: Text('Select Gender'),
                items: [
                  DropdownMenuItem<bool>(
                    value: true, // Corresponds to "MALE"
                    child: Text('MALE'),
                  ),
                  DropdownMenuItem<bool>(
                    value: false, // Corresponds to "FEMALE"
                    child: Text('FEMALE'),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    selectedGender =
                        newValue; // Set the selected gender as a boolean
                  });
                },
              ),
              const SizedBox(height: 20),
              _buttonUpdate(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonUpdate() {
    return ElevatedButton(
      onPressed: _loading
          ? null
          : () async {
              if (ageController.text.isEmpty) {
                // Show an alert if age is required
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Age is required. Please sign in.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Process the age value
                int? age = int.tryParse(ageController.text);
                if (age != null) {
                  print('Age: $age');
                } else {
                  // Show an alert if the input is not a valid number
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid age.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
              if (phoneController.text.isEmpty) {
                // Show an alert if phone is required
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Phone is required. Please sign in.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                String phone = phoneController.text;

                final RegExp phoneRegExp = RegExp(r'^0[0-9]{9}$');

                if (!phoneRegExp.hasMatch(phone)) {
                  // Show an alert if the input is not in valid phone format
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a valid phone number (10 digits starting with 0).',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Phone number is valid, proceed with your logic
                  print('Phone: $phone');
                }
              }
              await fetchUpdateUser();
            },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff5CB15A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _loading ? 'Updating...' : 'Update Profile',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Fredoka',
              ),
            ),
            const SizedBox(width: 10),
            _loading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  )
                : Icon(
                    Icons.update,
                    size: 24,
                  ),
          ],
        ),
      ),
    );
  }
}
