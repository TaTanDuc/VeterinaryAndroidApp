import 'package:application/Screens/Cart/cart_screen.dart';
import 'package:application/Screens/Services/services_screen.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';

class DetailServiceScreen extends StatefulWidget {
  const DetailServiceScreen({super.key});

  @override
  State<DetailServiceScreen> createState() => _DetailServiceScreenState();
}

class _DetailServiceScreenState extends State<DetailServiceScreen> {
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
            child: Column(
              children: [
                const SizedBox(
                  height: 350,
                ),
                _infoItem(),
                const SizedBox(
                  height: 15,
                ),
                _descItem(),
                const SizedBox(
                  height: 20,
                ),
                _countItem(),
                const SizedBox(height: 50),
                _buttonAddToCart(),
              ],
            ),
          ),
        ),
        CustomNavContent(
          navText: 'Josi Dog Master Mix',
          onBackPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ServicesScreen()), // Điều hướng đến trang mới
            );
          },
          iconNav: Icons.shopping_cart,
          onNextPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CartViewScreen()), // Điều hướng đến trang mới
            );
          },
          hideImage: true,
          pathImage: 'assets/images/avatar01.jpg',
        )
      ],
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

  Widget _descItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Brighten up your pet"s bowl with the colourful corn and beetroot kibble in JosiDog MasterMix! Crunchy and flavourful variety for adult dogs of all sizes, plus a wide range of important nutrients included. No added soya, sugar or milk products. Free from artificial colourings, flavourings and preservatives. Contains animal protein, vitamins & minerals more',
          style: TextStyle(
              color: Color(0xff191919), fontSize: 16, fontFamily: 'Fredoka'),
        ),
        Row(
          children: [
            Text(
              'Recommended for:',
              style: TextStyle(
                  color: Color(0xff191919),
                  fontSize: 16,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 20),
            Container(
              width: 55,
              // height: 16,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(8), // Điều chỉnh độ bo tròn tại đây
                border: Border.all(
                  color: Color(0xff7A86AE),
                  width: 2,
                ),
                // Màu nền cho container
              ),
              child: Center(
                child: Text(
                  'Roudy',
                  style: TextStyle(color: Color(0xff5F5F63), fontSize: 12),
                ),
              ),
            ),
          ],
        )
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
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xffffffff), // Màu chữ
        backgroundColor: Color(0xff5CB15A), // Màu nền
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Đẩy icon về bên phải
          children: [
            Center(
              child: Row(
                children: [
                  Text(
                    'Add to Cart',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                  const SizedBox(width: 30),
                  // Icon bên phải
                  Icon(
                    Icons.shopping_cart_outlined, // Thay đổi icon theo ý muốn
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
    );
  }
}
