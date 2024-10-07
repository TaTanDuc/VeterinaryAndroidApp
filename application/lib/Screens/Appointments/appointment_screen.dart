import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TextEditingController timePicker = TextEditingController();
  TextEditingController datePicker = TextEditingController();
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
        Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 450),
                    _info(),
                    const SizedBox(height: 30),
                    TextField(
                      controller: timePicker,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Pick a current time',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                      onTap: () async {
                        var time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) {
                          setState(() {
                            timePicker.text = time.format(context);
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                        controller: datePicker,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Pick today"s Date',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                        onTap: () async {
                          DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2050));
                          if (dateTime != null) {
                            String dateTimeFormated =
                                DateFormat('yyyy-MM-dd').format(dateTime);
                            setState(() {
                              datePicker.text = dateTimeFormated;
                            });
                          }
                        }),
                    const SizedBox(height: 30),
                    _buttonAppointment(),
                  ],
                ),
              ),
            )),
        CustomNavContent(
          navText: 'Appointment',
          onBackPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RegisterScreen()), // Điều hướng đến trang mới
            );
          },
          hideImage: true,
        ),
      ],
    );
  }

  Widget _time() {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 25,
          color: Colors.black,
        ),
        const SizedBox(width: 10),
        Text(
          'Monday-Friday at 8:00 am - 5:00 pm',
          style: TextStyle(color: Color(0xffA6A6A6), fontSize: 12),
        )
      ],
    );
  }

  Widget _location() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 20,
          color: Colors.black,
        ),
        const SizedBox(width: 10),
        Text(
          '2.5km',
          style: TextStyle(color: Color(0xff868889)),
        )
      ],
    );
  }

  Widget _info() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        color: Color(0xffFFFFFF),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 30, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Dr.Nambuvan',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 25,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                'Bachelor of Veterinary Science',
                style: TextStyle(color: Color(0xff064E57), fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '5.0',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 12,
                    ),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  _time(),
                  const SizedBox(
                    width: 30,
                  ),
                  _location(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonAppointment() {
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
            // Text ở giữa
            Text(
              'Book an appointment',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Fredoka',
              ),
            ),
            const SizedBox(width: 30),
            // Icon bên phải
            Icon(
              Icons.calendar_today, // Thay đổi icon theo ý muốn
              size: 24, // Kích thước icon
              // Màu icon
            ),
          ],
        ),
      ),
    );
  }
}
