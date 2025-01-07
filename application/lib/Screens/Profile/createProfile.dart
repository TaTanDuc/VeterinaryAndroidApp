import 'dart:convert';
import 'dart:io';
import 'package:application/bodyToCallAPI/Profile.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/main.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? selectedGender;
  String? imagePath;
  dynamic ID;
  bool _loading = false;
  File? _imageFile;
  String? test;
  String path = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final imageTempolary = await _save(pickedFile.path);
      test = pickedFile.path;
      setState(() {
        this._imageFile = imageTempolary; // Save the picked image
      });
      imagePath = await _getAssetsImagePath(imageTempolary.path);
      print('Simulated path: $path');
    }
  }

  Future<File> _save(String originalPath) async {
    // Save to a writable directory
    final directory = await getApplicationDocumentsDirectory();

    final fileName = Path.basename(originalPath);
    final newPath = '${directory.path}/$fileName';

    return File(originalPath).copy(newPath);
  }

  Future<String> _getAssetsImagePath(String savedPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = Path.basename(savedPath);
    var uri = Uri.parse('http://192.168.137.1:8080/image/upload');
    var request = http.MultipartRequest('POST', uri);
    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      test!,
      filename: fileName,
    );
    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      final customPath = '$fileName';
      return customPath;
    } else {
      return 'Error uploading image';
    }
  }

  Future<void> fetchUpdateUser() async {
    setState(() {
      _loading = true;
    });

    final url =
        Uri.parse('http://192.168.137.1:8080/api/customer/profile/create');

    try {
      int? age;
      if (ageController.text.isNotEmpty) {
        age = int.tryParse(ageController.text);
        if (age == null) {
          print('Invalid age input: ${ageController.text}');
          return;
        }
      } else {
        print('Age input is empty.');
        return;
      }

      Profile profileDTO = Profile(
        profileIMG: '',
        profileNAME: nameController.text,
        Email: '',
        profileAGE: age,
        phone: phoneController.text,
        profileGENDER: selectedGender!.toString(),
      );
      final session = await SessionManager().getSession();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
        body: jsonEncode(profileDTO.toJson()),
      );

      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        DelightToastBar(
          builder: (context) {
            return const ToastCard(
              leading: Icon(Icons.check, size: 20),
              title: Text(
                'Create successful',
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        print('Update failed with status code: ${response.statusCode}');
        final errorMessage = response.body;
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
            'Create user',
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
              height: AppBar().preferredSize.height,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
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
              DropdownButton<String>(
                value: selectedGender,
                hint: const Text('Select Gender'),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : (imagePath != null
                          ? Image.network(
                              imagePath!,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            )
                          : const Text(
                              'No image selected',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text(
                      'Take your pet picture',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Fredoka',
                      ),
                    ),
                  ),
                ],
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
              _loading ? 'Creating...' : 'Create Profile',
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
