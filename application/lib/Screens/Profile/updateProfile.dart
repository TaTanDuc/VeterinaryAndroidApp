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

// class UpdatePage extends StatefulWidget {
//   final int userID;
//   const UpdatePage(
//       {Key? key, required this.userID // Make userID required as well
//       })
//       : super(key: key);

//   @override
//   State<UpdatePage> createState() => _UpdatePageState();
// }

// class _UpdatePageState extends State<UpdatePage> {
//   int hoveredIndex = -1; // Keeps track of the hovered star index
//   int selectedIndex = -1; // Keeps track of the selected star rating
//   bool _loading = true;
//   dynamic serviceCommnets;
//   dynamic ID;
//   final TextEditingController name = TextEditingController();
//   final TextEditingController gender = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController phone = TextEditingController();
//   final TextEditingController age = TextEditingController();
//   @override
//   void initState() {
//     super.initState();

//     fetchUpdateUser();
//   }

//   // Future<void> fetchUpdateUser() async {
//   //   final userManager = UserManager(); // Ensure singleton access
//   //   User? currentUser = userManager.user;

//   //   if (currentUser != null) {
//   //     print("User ID in here: ${currentUser.userID}");
//   //     ID = currentUser.userID;
//   //     name = currentUser.username;
//   //   } else {
//   //     print("No user is logged in in this.");
//   //   }
//   //   Profile comment = Profile(
//   //     userID: ID,
//   //     serviceCODE: widget.serviceCODE,
//   //     rating: selectedIndex, // Use the DateTime string representation
//   //     content: content,
//   //   );

//   //   final url = Uri.parse('http://localhost:8080/api/profile/user/update');
//   //   final body = jsonEncode(comment.toJson());
//   //   print('Body: $body');
//   //   try {
//   //     final response = await http.post(
//   //       url,
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: body, // Replace with your actual userID
//   //     );
//   //     print('Response Body: ${response.body}');
//   //     if (response.statusCode == 200) {
//   //       print('Appointment saved successfully!');
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => ReviewsScreen(
//   //             userID: ID,
//   //             serviceCODE: widget.serviceCODE,
//   //           ), // Pass serviceCODE
//   //         ),
//   //       );
//   //     } else {
//   //       throw Exception('Failed to load pets');
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //     setState(() {
//   //       _loading = false;
//   //     });
//   //   }
//   // }
//   Future<void> fetchUpdateUser() async {
//     final url = Uri.parse('http://localhost:8080/api/user/update');
//     final userManager = UserManager(); // Ensure singleton access
//     User? currentUser = userManager.user;

//     if (currentUser != null) {
//       print("User ID in here: ${currentUser.userID}");
//       ID = currentUser.userID;
//     } else {
//       print("No user is logged in in this.");
//     }
//     try {
//       Profile profileDTO = Profile(
//         userID: ID,
//         profileIMG: pro,
//         profileNAME: name.text,
//         profileEMAIL: email.text,
//         GENDER: ,
//         AGE: age.text.toIn,
//         PHONE: phone.text,
//         // Add other properties if needed
//       );

//       final response = await http.patch(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(profileDTO.toJson()), // Convert ProfileDTO to JSON
//       );

//       if (response.statusCode == 200) {
//         // Handle successful response
//         final data = jsonDecode(response.body);
//         print('User profile updated successfully: $data');
//       } else {
//         // Handle error response
//         final errorMessage = jsonDecode(response.body);
//         print('Error updating profile: $errorMessage');
//       }
//     } catch (e) {
//       print('Error occurred while updating profile: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: double.infinity,
//       child: Scaffold(
//         body: _page(),
//       ),
//     );
//   }

//   Widget _page() {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Center(
//               child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 120),
//                     _infoUser(name),
//                     const SizedBox(height: 20),
//                     _listStars(),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Align(
//                       alignment: Alignment.centerLeft, // Căn lề trái
//                       child: Text(
//                         'Share more about your experience',
//                         style: TextStyle(
//                           fontSize: 25,
//                           color: Colors.black,
//                           fontFamily: 'Fredoka',
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     TextField(
//                       controller:
//                           _commentController, // Attach controller to TextField
//                       minLines: 8,
//                       maxLines: null, // Auto-adjust height based on content
//                       maxLength: 200, // Set maximum character limit
//                       style: TextStyle(fontSize: 20),
//                       onChanged: (value) {
//                         setState(() {
//                           content =
//                               value; // Update content variable on text change
//                           _isContentValid = content.length >= 20 &&
//                               content.length <=
//                                   200; // Validate length between 20 and 200
//                         });
//                       },
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         hintText:
//                             'Share details of your own experience at this place',
//                         counterText:
//                             '${content.length}/200', // Show character count
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Colors.grey,
//                             width: 2,
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: Colors.grey,
//                             width: 2,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: _isContentValid
//                                 ? Colors.green
//                                 : Colors.red, // Green if valid, red if not
//                             width: 2,
//                           ),
//                         ),
//                         errorText: !_isContentValid
//                             ? 'Please enter between 20 and 200 characters.' // Show error if text is out of bounds
//                             : null, // No error if content is valid
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buttonPostReview(),
//                   ]),
//             ),
//           ),
//         ),
//         CustomNavContent(
//             navText: 'Update your profile',
//             onBackPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         ProfileScreen(userID: ID)), // Điều hướng đến trang mới
//               ); //
//             })
//       ],
//     );
//   }

//   Widget _buttonPostReview() {
//     return ElevatedButton(
//       onPressed: _loading
//           ? null
//           : () async {
//               setState(() {
//                 _loading = true; // Start loading
//               });

//               try {
//                 //await fetchAddComment(); // Call submitAppointment asynchronously
//                 // Optionally show a success message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Comment Added successfully!')),
//                 );
//               } catch (error) {
//                 // Handle the error, show an error message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Failed to add comment: $error')),
//                 );
//               } finally {
//                 setState(() {
//                   _loading = false; // Stop loading
//                 });
//               }
//             },
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.white, // Text color
//         backgroundColor: Color(0xff5CB15A), // Background color
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//       child: SizedBox(
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center, // Center text and icon
//           children: [
//             Text(
//               _loading
//                   ? 'Posting...'
//                   : 'Post Review', // Change text when loading
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontFamily: 'Fredoka',
//               ),
//             ),
//             const SizedBox(width: 10),
//             _loading
//                 ? CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     strokeWidth: 2, // Adjust size
//                   )
//                 : Icon(
//                     Icons.rate_review, // Icon for posting review
//                     size: 24, // Icon size
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _listStars() {
//     return Container(
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             5,
//             (index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIndex =
//                         index + 1; // Set rating based on selected star (1 to 5)
//                   });
//                   print(
//                       'Rating: ${selectedIndex}'); // Print the rating for debugging
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: MouseRegion(
//                     onEnter: (_) {
//                       setState(() {
//                         hoveredIndex =
//                             index; // Update hovered index when hovering
//                       });
//                     },
//                     onExit: (_) {
//                       setState(() {
//                         hoveredIndex =
//                             -1; // Reset to default when exiting hover
//                       });
//                     },
//                     child: Image.asset(
//                       (hoveredIndex >= index ||
//                               selectedIndex >
//                                   index) // If hovered or selected, display yellow star
//                           ? 'assets/icons/star_yellow.png'
//                           : 'assets/icons/star_icon1.png', // Default grey star
//                       width: 50,
//                       height: 50,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoUser(String name) {
//     return Container(
//       child: Row(
//         children: [
//           // Avatar tròn

//           // Tên người dùng và thời gian
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
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
      print("User ID in here: ${currentUser.userID}");
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
        print('User profile updated successfully: $data');

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
