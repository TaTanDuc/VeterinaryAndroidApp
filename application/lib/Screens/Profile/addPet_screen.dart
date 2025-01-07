import 'dart:convert';
import 'dart:io';
import 'package:application/Screens/Profile/camera_screen.dart';
import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:application/main.dart';
import 'package:camera/camera.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  List<dynamic> _UserPets = [];

  dynamic ID;
  bool _loading = true;
  File? _imageFile;
  String? imagePath;
  String _dataMessage = '';
  TextEditingController petNameController = TextEditingController();
  TextEditingController petBreedController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController petHeightController = TextEditingController();
  String? test;
  String path = "";
  String? selectedGender;
  String? selectedAnimal;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: _page(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPetUser();
  }

  Future<void> fetchPetUser() async {
    try {
      setState(() {
        _loading:
        false;
      });
      final session = await SessionManager().getSession();
      final url = Uri.parse('http://192.168.137.1:8080/api/customer/pet');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['returned'];

        setState(() {
          _UserPets = data;
          _loading = false;
        });
      }
    } catch (err) {
      print(err);
      setState(() {
        _loading:
        false;
      });
    }
  }

  Future<void> handleAddPet() async {
    try {
      final url =
          Uri.parse("http://192.168.137.1:8080/api/customer/pet/create");
      final session = await SessionManager().getSession();
      print('data insert $imagePath');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session',
        },
        body: jsonEncode({
          "petIMAGE": imagePath,
          "petNAME": petNameController.text,
          "petGENDER": selectedGender!,
          "petAGE": int.parse(petAgeController.text),
          "animal": selectedAnimal!,
          "petSPECIE": petBreedController.text,
        }),
      );
      if (response.statusCode == 200) {
        final data = response.body;

        setState(() {
          _dataMessage = 'Add pet successfuly';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        });

        DelightToastBar(
          builder: (context) {
            return ToastCard(
              leading: Icon(Icons.check, size: 20),
              title: Text(
                _dataMessage,
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
      } else {
        DelightToastBar(
          builder: (context) {
            return ToastCard(
              leading: Icon(Icons.check, size: 20),
              title: Text(
                _dataMessage,
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
      }
    } catch (err) {
      print(err);
    }
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
      print('Simulated path: $imagePath');
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
      print('Image uploaded successfully. Access the image at: $customPath');
      return customPath;
    } else {
      print('Failed to upload the image. Status code: ${response.statusCode}');
      return 'Error uploading image';
    }
  }

  Widget _page() {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),
                Text(
                  'Added Pets',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Fredoka',
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _UserPets.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap:
                            true, // Ensures the ListView uses only the necessary space
                        physics:
                            NeverScrollableScrollPhysics(), // Disable ListView scrolling
                        itemCount: _UserPets.length,
                        itemBuilder: (context, index) {
                          var pet = _UserPets[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _itemPet(
                              pet['petIMAGE'] == null
                                  ? 'assets/images/dog.png'
                                  : pet['petIMAGE'],
                              pet['petNAME'],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No pets added yet.",
                          style: TextStyle(fontFamily: 'Fredoka', fontSize: 16),
                        ),
                      ),
                const SizedBox(height: 50),
                Text(
                  'Manually Add Pet',
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontFamily: 'Fredoka',
                  ),
                ),
                const SizedBox(height: 20),
                // Directly place the Image and Button here, avoid using Expanded
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/images/dog.png"),
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
                const SizedBox(height: 20),
                _textField('Name Pet', petNameController),
                const SizedBox(height: 30),
                _textField('Breed Name', petBreedController),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _textField('Age', petAgeController),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    DropdownButton<String>(
                      value: selectedAnimal,
                      hint: const Text('Select Type'),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Dog',
                          child: Text('Dog'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Cat',
                          child: Text('Cat'),
                        ),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedAnimal = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Add Pet',
                  onPressed: () {
                    handleAddPet();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      CustomNavContent(
        navText: 'Add Pets',
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        },
      ),
    ]);
  }

  Widget _itemPet(imagePath, namePet) {
    return Container(
      width: double.infinity,
      height: 81,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffD9D9D9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath,
              ),
            ),
            Text(
              namePet,
              style: TextStyle(
                  fontFamily: 'Fredoka',
                  color: Color(0xff000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Icon(
              Icons.link,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(hintName, controller) {
    return Container(
      constraints: BoxConstraints(
        minWidth:
            200, // Chiều rộng tối thiểu // Chiều rộng tối đa theo kích thước màn hình
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintName,
          // Nội dung placeholder (hint text)
          border: OutlineInputBorder(),
        ),
        controller: controller,
        style: TextStyle(
          fontFamily: 'Fredoka',
        ),
      ),
    );
  }
}
