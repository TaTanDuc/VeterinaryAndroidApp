import 'package:application/Screens/Reviews/reviews_screen.dart';
import 'package:application/bodyToCallAPI/AddComment.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddReviewScreen extends StatefulWidget {
  final String serviceCODE;
  final int userID;
  const AddReviewScreen(
      {Key? key,
      required this.serviceCODE,
      required this.userID // Make userID required as well
      })
      : super(key: key);

  @override
  State<AddReviewScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddReviewScreen> {
  int hoveredIndex = -1; // Keeps track of the hovered star index
  int selectedIndex = -1; // Keeps track of the selected star rating
  bool _loading = true;
  dynamic serviceCommnets;
  dynamic ID;
  String content = '';
  bool _isContentValid = true;
  String name = '';
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchAddComment();
  }

  Future<void> fetchAddComment() async {
    final userManager = UserManager(); // Ensure singleton access
    User? currentUser = userManager.user;

    if (currentUser != null) {
      ID = currentUser.userID;
      name = currentUser.username;
    } else {
      print("No user is logged in in this.");
    }
    AddComment comment = AddComment(
      userID: ID,
      serviceCODE: widget.serviceCODE,
      rating: selectedIndex, // Use the DateTime string representation
      content: content,
    );

    final url = Uri.parse('http://10.0.2.2:8080/api/service/addComment');
    final body = jsonEncode(comment.toJson());
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body, // Replace with your actual userID
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewsScreen(
              userID: ID,
              serviceCODE: widget.serviceCODE,
            ), // Pass serviceCODE
          ),
        );
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Scaffold(
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    _infoUser(name),
                    const SizedBox(height: 20),
                    _listStars(),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft, // Căn lề trái
                      child: Text(
                        'Share more about your experience',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: 'Fredoka',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      controller:
                          _commentController, // Attach controller to TextField
                      minLines: 8,
                      maxLines: null, // Auto-adjust height based on content
                      maxLength: 200, // Set maximum character limit
                      style: TextStyle(fontSize: 20),
                      onChanged: (value) {
                        setState(() {
                          content =
                              value; // Update content variable on text change
                          _isContentValid = content.length >= 20 &&
                              content.length <=
                                  200; // Validate length between 20 and 200
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText:
                            'Share details of your own experience at this place',
                        counterText:
                            '${content.length}/200', // Show character count
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _isContentValid
                                ? Colors.green
                                : Colors.red, // Green if valid, red if not
                            width: 2,
                          ),
                        ),
                        errorText: !_isContentValid
                            ? 'Please enter between 20 and 200 characters.' // Show error if text is out of bounds
                            : null, // No error if content is valid
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buttonPostReview(),
                  ]),
            ),
          ),
        ),
        CustomNavContent(
            navText: 'Add Your Review Here',
            onBackPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewsScreen(
                        serviceCODE: widget.serviceCODE,
                        userID: ID)), // Điều hướng đến trang mới
              ); //
            })
      ],
    );
  }

  Widget _buttonPostReview() {
    return ElevatedButton(
      onPressed: _loading
          ? null
          : () async {
              setState(() {
                _loading = true; // Start loading
              });

              try {
                await fetchAddComment(); // Call submitAppointment asynchronously
                // Optionally show a success message
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('Comment Added successfully!')),
                // );
                DelightToastBar(
                  builder: (context) {
                    return const ToastCard(
                      leading: Icon(Icons.check, size: 20),
                      title: Text(
                        'Add successful',
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
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add comment: $error')),
                );
              } finally {
                setState(() {
                  _loading = false; // Stop loading
                });
              }
            },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color
        backgroundColor: Color(0xff5CB15A), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center text and icon
          children: [
            Text(
              _loading
                  ? 'Posting...'
                  : 'Post Review', // Change text when loading
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
                    strokeWidth: 2, // Adjust size
                  )
                : Icon(
                    Icons.rate_review, // Icon for posting review
                    size: 24, // Icon size
                  ),
          ],
        ),
      ),
    );
  }

  Widget _listStars() {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex =
                        index + 1; // Set rating based on selected star (1 to 5)
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        hoveredIndex =
                            index; // Update hovered index when hovering
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoveredIndex =
                            -1; // Reset to default when exiting hover
                      });
                    },
                    child: Image.asset(
                      (hoveredIndex >= index ||
                              selectedIndex >
                                  index) // If hovered or selected, display yellow star
                          ? 'assets/icons/star_yellow.png'
                          : 'assets/icons/star_icon1.png', // Default grey star
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoUser(String name) {
    return Container(
      child: Row(
        children: [
          // Avatar tròn

          // Tên người dùng và thời gian
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
