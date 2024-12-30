import 'dart:convert';
import 'dart:io';
import 'package:application/Screens/Profile/camera_screen.dart';
import 'package:application/Screens/Profile/profile_screen.dart';
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
  String _dataMessage = '';
  TextEditingController petNameController = TextEditingController();
  TextEditingController petBreedController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController petHeightController = TextEditingController();

  String path = "";

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

      // Gọi API để cập nhật số lượng mới
      final url = Uri.parse("http://192.168.137.1:8080/api/pet/getUserPets");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userID": 1}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

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
      final url = Uri.parse("http://10.0.2.2:8080/api/pet/addPet");

      print('data insert $path');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userID": ID,
          "petIMAGE": path,
          "petNAME": petNameController.text,
          "petSPECIE": petBreedController.text,
          "petAGE": int.parse(petAgeController.text)
        }),
      );
      if (response.statusCode == 200) {
        final data = response.body; // No jsonDecode, treat as plain text

        setState(() {
          _dataMessage = data;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(), // Pass serviceCODE
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
        // setState(() {
        //   _dataMessage = data;
        // });
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
      setState(() {
        this._imageFile = imageTempolary; // Save the picked image
      });
      path = await _getAssetsImagePath(imageTempolary.path);
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
    final customPath = 'assets/images/$fileName';

    // Log or return the simulated "assets/images/image.jpg" path
    print('Simulated asset path: $customPath');
    return customPath;
  }

  Widget _page() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    Text(
                      'Added Pets',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Fredoka',
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    _UserPets.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap:
                                true, // Đảm bảo không cuộn trong SingleChildScrollView
                            physics:
                                NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn của ListView
                            itemCount: _UserPets.length,
                            itemBuilder: (context, index) {
                              var pet = _UserPets[index];
                              // Giả sử rằng dữ liệu API có namePet và imagePath
                              return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: _itemPet(
                                      pet['imageLink'] == null
                                          ? 'assets/images/dog.png'
                                          : pet['imageLink'],
                                      pet['petNAME']));
                            },
                          )
                        : Center(
                            child: Text(
                              "No pets added yet.",
                              style: TextStyle(
                                  fontFamily: 'Fredoka', fontSize: 16),
                            ),
                          ),
                    const SizedBox(height: 50),
                    Text(
                      'Manually Add Pet',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontFamily: 'Fredoka'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Căn chỉnh khoảng cách giữa các TextField
                      children: [
                        SizedBox(width: 10),
                        _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/dog.png"),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _pickImage(ImageSource.camera),
                            child: const Text(
                              'Take your pet picture', // Nhãn
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Fredoka',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _textField('Name Pet', petNameController),
                    const SizedBox(height: 30),
                    _textField('Breed Name', petBreedController),
                    const SizedBox(height: 30),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Căn chỉnh khoảng cách giữa các TextField
                      children: [
                        Expanded(
                          child: _textField('Height', petHeightController),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa các TextField
                        Expanded(
                          child: _textField('Age', petAgeController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                        text: 'Add Pet',
                        onPressed: () {
                          handleAddPet();
                        })
                  ],
                ),
              )),
        ),
        CustomNavContent(
            navText: 'Add Pets',
            onBackPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            })
      ],
    );
  }

  // Widget _imagePicker() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Select Image',
  //         style: TextStyle(
  //           fontFamily: 'Fredoka',
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       _imageFile != null
  //           ? Image.file(
  //               _imageFile!,
  //               width: 100,
  //               height: 100,
  //             )
  //           : IconButton(
  //               icon: Icon(Icons.add_a_photo),
  //               onPressed: _pickImage,
  //             ),
  //       if (_imageFile != null)
  //         TextButton(
  //           onPressed: () {
  //             setState(() {
  //               _imageFile = null; // Clear the selected image
  //             });
  //           },
  //           child: Text('Remove Image'),
  //         ),
  //     ],
  //   );
  // }

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
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
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
