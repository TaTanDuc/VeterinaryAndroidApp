// import 'package:application/Screens/Cart/cart_screen.dart';
// import 'package:application/Screens/Services/services_screen.dart';
// import 'package:application/components/customNavContent.dart';
// import 'package:flutter/material.dart';

// class DetailServiceScreen extends StatefulWidget {
//   const DetailServiceScreen({super.key});

//   @override
//   State<DetailServiceScreen> createState() => _DetailServiceScreenState();
// }

// class _DetailServiceScreenState extends State<DetailServiceScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
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
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 350,
//                 ),
//                 _infoItem(),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 _descItem(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 _countItem(),
//                 const SizedBox(height: 50),
//                 _buttonAddToCart(),
//               ],
//             ),
//           ),
//         ),
//         CustomNavContent(
//           navText: 'Josi Dog Master Mix',
//           onBackPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       ServicesScreen()), // Điều hướng đến trang mới
//             );
//           },
//           iconNav: Icons.shopping_cart,
//           onNextPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       CartViewScreen()), // Điều hướng đến trang mới
//             );
//           },
//           hideImage: true,
//           pathImage: 'assets/images/avatar01.jpg',
//         )
//       ],
//     );
//   }

//   Widget _infoItem() {
//     return ConstrainedBox(
//       constraints: BoxConstraints(minHeight: 128),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Color(0xffFFFFFF),
//           borderRadius: BorderRadius.circular(15), // Đặt border-radius
//         ),
//         // color: Color(0xffFFFFFF),
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Josi Dog Master Mix - 900g',
//                 style: TextStyle(
//                     color: Color(0xff000000),
//                     fontWeight: FontWeight.w700,
//                     fontSize: 30,
//                     fontFamily: 'Fredoka'),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Brand: Josera',
//                     style: TextStyle(
//                         color: Color(0xff064E57),
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Fredoka'),
//                   ),
//                   Text(
//                     'Rs 1500.00',
//                     style: TextStyle(
//                         color: Color(0xff5CB15A),
//                         fontSize: 14,
//                         fontFamily: 'Fredoka'),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Text(
//                     '5.0',
//                     style: TextStyle(
//                         color: Color(0xff000000),
//                         fontSize: 12,
//                         fontFamily: 'Fredoka'),
//                   ),
//                   const SizedBox(width: 5),
//                   Image.asset(
//                     'assets/icons/star_yellow.png',
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     'assets/icons/star_yellow.png',
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     'assets/icons/star_yellow.png',
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     'assets/icons/star_yellow.png',
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     'assets/icons/star_yellow.png',
//                     width: 20,
//                     height: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     '(100 reviews)',
//                     style: TextStyle(color: Color(0xffA6A6A6)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _descItem() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'Brighten up your pet"s bowl with the colourful corn and beetroot kibble in JosiDog MasterMix! Crunchy and flavourful variety for adult dogs of all sizes, plus a wide range of important nutrients included. No added soya, sugar or milk products. Free from artificial colourings, flavourings and preservatives. Contains animal protein, vitamins & minerals more',
//           style: TextStyle(
//               color: Color(0xff191919), fontSize: 16, fontFamily: 'Fredoka'),
//         ),
//         Row(
//           children: [
//             Text(
//               'Recommended for:',
//               style: TextStyle(
//                   color: Color(0xff191919),
//                   fontSize: 16,
//                   fontFamily: 'Fredoka',
//                   fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(width: 20),
//             Container(
//               width: 55,
//               // height: 16,
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 borderRadius:
//                     BorderRadius.circular(8), // Điều chỉnh độ bo tròn tại đây
//                 border: Border.all(
//                   color: Color(0xff7A86AE),
//                   width: 2,
//                 ),
//                 // Màu nền cho container
//               ),
//               child: Center(
//                 child: Text(
//                   'Roudy',
//                   style: TextStyle(color: Color(0xff5F5F63), fontSize: 12),
//                 ),
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }

//   Widget _countItem() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Quantity',
//           style: TextStyle(color: Color(0xff868889), fontSize: 16),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Icon(
//               Icons.remove,
//               color: Color(0xff6CC51D),
//             ),
//             const SizedBox(width: 10),
//             Text('3', style: TextStyle(fontSize: 16, color: Color(0xff000000))),
//             const SizedBox(width: 10),
//             Icon(
//               Icons.add,
//               color: Color(0xff6CC51D),
//             )
//           ],
//         )
//       ],
//     );
//   }

//   Widget _buttonAddToCart() {
//     return ElevatedButton(
//       onPressed: () {},
//       child: SizedBox(
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center, // Đẩy icon về bên phải
//           children: [
//             Center(
//               child: Row(
//                 children: [
//                   Text(
//                     'Add to Cart',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 30,
//                       fontFamily: 'Fredoka',
//                     ),
//                   ),
//                   const SizedBox(width: 30),
//                   // Icon bên phải
//                   Icon(
//                     Icons.shopping_cart_outlined, // Thay đổi icon theo ý muốn
//                     size: 24, // Kích thước icon
//                     // Màu icon
//                   ),
//                 ],
//               ),
//             )
//             // Text ở giữa
//           ],
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Color(0xffffffff), // Màu chữ
//         backgroundColor: Color(0xff5CB15A), // Màu nền
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//     );
//   }
// }
import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/Screens/Services/services_screen.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailServiceScreen extends StatefulWidget {
  final String serviceCODE;

  const DetailServiceScreen({Key? key, required this.serviceCODE})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailServiceScreen> {
  bool _loading = true;
  dynamic serviceDetails; // Change the type based on your response

  @override
  void initState() {
    super.initState();
    fetchServiceDetails(); // Fetch details when the page initializes
  }

  Future<void> fetchServiceDetails() async {
    final url = Uri.parse(
        'http://localhost:8080/api/service/detail?serviceCODE=${widget.serviceCODE}');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        setState(() {
          serviceDetails =
              jsonDecode(response.body); // Update with your response structure
          _loading = false; // Stop loading when data is fetched
        });
      } else {
        throw Exception('Failed to load service details');
      }
    } catch (e) {
      print('Error fetching service details: $e');
      setState(() {
        _loading = false; // Stop loading on error
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
              'Detail',
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
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Center(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : serviceDetails != null
                      ? _buildServiceDetailView()
                      : Center(child: Text('No details available')),
            )
          ],
        )));
  }

  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(
        Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
        ),
      );
    }
    return Row(
      children: stars,
    );
  }

  Widget _buildServiceDetailView() {
    // Build your detail view using the serviceDetails
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        //   Text(
        //     serviceDetails[
        //         'serviceNAME'], // Adjust according to your data structure
        //     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //   ),
        //   const SizedBox(height: 8),
        //   Text('Price: ${serviceDetails['servicePRICE']}'),
        //   const SizedBox(height: 8),
        //   Text('Rating: ${serviceDetails['serviceRATING']}'),
        //   // Add more details as necessary
        // ],
        children: [
          const SizedBox(
            height: 350,
          ),
          _infoItem(),
          const SizedBox(
            height: 15,
          ),
          _descItem(serviceDetails['serviceDATE']),
          const SizedBox(
            height: 20,
          ),
          _buttonAddToCart(),
        ],
      ),
    );
  }

  Widget _infoItem() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 128),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(15), // Đặt border-radius
        ),
        // color: Color(0xffFFFFFF),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Josi Dog Master Mix - 900g',
                style: TextStyle(
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    fontFamily: 'Fredoka'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Brand: Josera',
                    style: TextStyle(
                        color: Color(0xff064E57),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Fredoka'),
                  ),
                  Text(
                    'Rs 1500.00',
                    style: TextStyle(
                        color: Color(0xff5CB15A),
                        fontSize: 14,
                        fontFamily: 'Fredoka'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '5.0',
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontFamily: 'Fredoka'),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    'assets/icons/star_yellow.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/icons/star_yellow.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/icons/star_yellow.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/icons/star_yellow.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/icons/star_yellow.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '(100 reviews)',
                    style: TextStyle(color: Color(0xffA6A6A6)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _descItem(String des) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          des,
          style: TextStyle(
              color: Color(0xff191919), fontSize: 16, fontFamily: 'Fredoka'),
        ),
      ],
    );
  }

  Widget _countItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quantity',
          style: TextStyle(color: Color(0xff868889), fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.remove,
              color: Color(0xff6CC51D),
            ),
            const SizedBox(width: 10),
            Text('3', style: TextStyle(fontSize: 16, color: Color(0xff000000))),
            const SizedBox(width: 10),
            Icon(
              Icons.add,
              color: Color(0xff6CC51D),
            )
          ],
        )
      ],
    );
  }

  Widget _buttonAddToCart() {
    return ElevatedButton(
      onPressed: () {},
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Đẩy icon về bên phải
          children: [
            Center(
              child: Row(
                children: [
                  Text(
                    'Book appointment',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  const SizedBox(width: 30),
                  // Icon bên phải
                  Icon(
                    Icons.book_online, // Thay đổi icon theo ý muốn
                    size: 24, // Kích thước icon
                    // Màu icon
                  ),
                ],
              ),
            )
            // Text ở giữa
          ],
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xffffffff), // Màu chữ
        backgroundColor: Color(0xff5CB15A), // Màu nền
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
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
