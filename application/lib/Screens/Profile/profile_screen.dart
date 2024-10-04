import 'package:application/components/customNavContent.dart';
// import 'package:first_flutter/components/customNavContent.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page(),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 400,
                  ),
                  _infoUser(),
                  const SizedBox(height: 50),
                  _optionUser(),
                ],
              ),
            ),
          ),
          CustomNavContent(
            navText: 'Profile Name',
            onBackPressed: () {},
            hideImage: true,
            pathImage: 'assets/images/avatar02.jpg',
          )
        ],
      ),
    );
  }

  Widget _infoUser() {
    return Container(
      width: double.infinity,
      height: 200,
      // color: Color(0xffFFFFFF),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 15, 15, 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pixel Posse',
                  style: TextStyle(
                      fontSize: 26,
                      color: Color(0xff141415),
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.w700),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Hành động khi nhấn vào nút
                    print('Sign out button pressed');
                  },
                  icon: Icon(
                    Icons.arrow_back, // Biểu tượng mũi tên quay về
                    color: Colors.red, // Màu của biểu tượng
                  ),
                  label: Text(
                    'Sign out', // Văn bản nút
                    style: TextStyle(
                      color: Colors.red, // Màu của văn bản
                      fontWeight: FontWeight.bold, // Đậm văn bản
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.white, // Màu nền của nút
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Định dạng bo góc
                    ),
                    side: BorderSide(color: Colors.red), // Viền màu đỏ
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.email),
                const SizedBox(width: 30),
                Text(
                  'nguyenboo2018@gmail.com',
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 16,
                      fontFamily: 'Fredoka'),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.call),
                const SizedBox(width: 30),
                Text(
                  '0348859428',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontFamily: 'Fredoka'),
                )
              ],
            )
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
              _optionItem(Icons.person, 'About me'),
              const SizedBox(height: 30),
              _optionItem(Icons.list_alt, 'My Orders'),
              const SizedBox(height: 30),
              _optionItem(Icons.location_on, 'My Address'),
              const SizedBox(height: 30),
              _optionItem(Icons.pets, 'Add Pet'),
            ],
          )),
    );
  }

  Widget _optionItem(icon, nameItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 30),
            Text(
              nameItem,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                  fontFamily: 'Fredoka'),
            )
          ],
        ),
        Icon(
          Icons.chevron_right,
          size: 30,
        ),
      ],
    );
  }
}
