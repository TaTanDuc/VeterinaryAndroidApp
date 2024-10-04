import 'package:application/components/customButton.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    _itemPet('assets/images/dog.png', 'Bella'),
                    const SizedBox(height: 50),
                    Text(
                      'Manually Add Pet',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontFamily: 'Fredoka'),
                    ),
                    const SizedBox(height: 20),
                    _textField('Name Pet'),
                    const SizedBox(height: 30),
                    _textField('Breed Name'),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Căn chỉnh khoảng cách giữa các TextField
                      children: [
                        Expanded(
                          child: _textField('Gender'),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa các TextField
                        Expanded(
                          child: _textField('Age'),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa các TextField
                        Expanded(
                          child: _textField('Color'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Căn chỉnh khoảng cách giữa các TextField
                      children: [
                        Expanded(
                          child: _textField('Height'),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa các TextField
                        Expanded(
                          child: _textField('Weight'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomButton(text: 'Add Pet', onPressed: () {})
                  ],
                ),
              )),
        ),
        CustomNavContent(navText: 'Add Pets', onBackPressed: () {})
      ],
    );
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

  Widget _textField(hintName) {
    return Container(
      constraints: BoxConstraints(
        minWidth:
            200, // Chiều rộng tối thiểu // Chiều rộng tối đa theo kích thước màn hình
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintName, // Nội dung placeholder (hint text)
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontFamily: 'Fredoka',
        ),
      ),
    );
  }
}
