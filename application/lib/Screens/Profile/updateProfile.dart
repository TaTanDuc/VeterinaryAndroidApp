import 'dart:convert';
import 'package:application/bodyToCallAPI/Profile.dart';
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
  String? selectedGender;
  String? imagePath;
  dynamic ID;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Populate text fields with the user's current profile data
    nameController.text = widget.profile.profileNAME;
    emailController.text = widget.profile.profileEMAIL;
    ageController.text = widget.profile.AGE.toString();
    phoneController.text = widget.profile.PHONE;
    selectedGender = widget.profile.GENDER;
    imagePath = widget.profile.profileIMG;
  }

  Future<void> fetchUpdateUser() async {
    final userManager = UserManager(); // Ensure singleton access
    User? currentUser = userManager.user;

    if (currentUser != null) {
      ID = currentUser.userID;
    } else {
      print("No user is logged in in this.");
      return;
    }

    setState(() {
      _loading = true;
    });

    final url = Uri.parse('http://localhost:8080/api/profile/user/update');

    try {
      Profile profileDTO = Profile(
        userID: currentUser.userID,
        profileIMG: imagePath!,
        profileNAME: nameController.text,
        profileEMAIL: emailController.text,
        AGE: int.parse(ageController.text),
        PHONE: phoneController.text,
        GENDER: selectedGender!, // Include gender here
      );

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileDTO.toJson()), // Convert ProfileDTO to JSON
      );

      if (response.statusCode == 200) {
        // Handle successful response
        final data = jsonDecode(response.body);

        // Navigate to the ProfilePage and pass the updated ID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userID: ID),
          ),
        );
      } else {
        // Handle error response
        final errorMessage = jsonDecode(response.body);
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
        title: Text('Update Profile'),
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
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedGender,
                hint: Text('Select Gender'),
                items: ['MALE', 'FEMALE', 'OTHER'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue;
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
              await fetchUpdateUser();
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
