import 'package:application/Screens/Login/register_screen.dart';
import 'package:application/bodyToCallAPI/Appointment.dart';
import 'package:application/bodyToCallAPI/Pet.dart';
import 'package:application/bodyToCallAPI/Service.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:application/main.dart';
import 'package:application/pages/Homepage/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TextEditingController timePicker = TextEditingController();
  TextEditingController datePicker = TextEditingController();
  bool _loading = true; // Change the type based on your response
  List<Service> _services = [];
  List<Service> _selectedServices = [];
  dynamic _selectedPets;
  dynamic _selectedPetID;
  List<Pet> _pets = [];
  dynamic ID;
  bool _isValidTime(TimeOfDay selectedTime) {
    final int selectedHour = selectedTime.hour;
    final int selectedMinute = selectedTime.minute;

    // Service times: 7:00 AM to 11:00 AM and 1:00 PM to 5:00 PM
    if ((selectedHour >= 8 && selectedHour < 11) ||
        (selectedHour >= 13 && selectedHour < 17)) {
      return true;
    }
    return false;
  }

  // Function to check if the day is Saturday or Sunday
  bool _isValidDay(DateTime selectedDate) {
    // 6 is Saturday, 7 is Sunday
    return !(selectedDate.weekday == 6 || selectedDate.weekday == 7);
  }

  @override
  void initState() {
    super.initState();
    fetchPets();
    fetchServices();
    submitAppointment(); // Call fetchPets when the widget is initialized
  }

  Future<void> fetchPets() async {
    final url = Uri.parse(
        'http://localhost:8080/api/pet/getUserPets'); // Replace with your actual API URL
    try {
      final userManager = UserManager(); // Ensure singleton access
      User? currentUser = userManager.user;

      if (currentUser != null) {
        print("User ID in HomePage: ${currentUser.userID}");
        ID = currentUser.userID;
      } else {
        print("No user is logged in in HomePage.");
      }
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userID": ID}), // Replace with your actual userID
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> petData = jsonDecode(response.body);
        print(
            'Fetched Pet Data: $petData'); // This should show the fetched data

        setState(() {
          _pets = petData.map((json) => Pet.fromJson(json)).toList();
          _loading = false;
          print('Mapped Pets: $_pets'); // Check the mapped pets
        });
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

  Future<void> fetchServices() async {
    final url =
        'http://localhost:8080/api/service/all'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> serviceData = jsonDecode(response.body);
        setState(() {
          _services = serviceData
              .map((json) => Service.fromJson(json))
              .toList(); // Populate the services list
          _loading = false;
        });
      } else {
        throw Exception('Failed to load services');
      }
    } catch (e) {
      print('Error: $e'); // Print error message
      setState(() {
        _loading = false; // Stop loading in case of error
      });
    }
  }

  Future<void> submitAppointment() async {
    DateTime appointmentDATE = DateFormat('yyyy-MM-dd').parse(datePicker.text);

    // Split the timePicker text to get hours and minutes
    List<String> timeParts = timePicker.text.split(':');

    // Ensure we have at least 2 parts (hour and minute)
    if (timeParts.length < 2) {
      throw FormatException('Time format is invalid');
    }

    // Parse hour and minute safely
    int selectedHour =
        int.tryParse(timeParts[0]) ?? 0; // Default to 0 if parsing fails
    int selectedMinute =
        int.tryParse(timeParts[1].split(' ')[0]) ?? 0; // Split to handle AM/PM

    // Get AM/PM part for correct hour conversion
    String amPm =
        timeParts[1].split(' ').last.toUpperCase(); // Ensure it's uppercase
    if (amPm == 'PM' && selectedHour != 12) {
      selectedHour += 12; // Convert PM hours to 24-hour format
    } else if (amPm == 'AM' && selectedHour == 12) {
      selectedHour = 0; // Convert 12 AM to 0 hours
    }

    // Create a DateTime object using the selected date and time
    // DateTime appointmentTIME = DateTime(
    //   appointmentDATE.year,
    //   appointmentDATE.month,
    //   appointmentDATE.day,
    //   selectedHour,
    //   selectedMinute,
    // );
    int selectedSecond = 0; // Set to 0 or your desired value

    // Create a formatted string for appointmentTIME with seconds
    String appointmentTIME =
        '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}:${selectedSecond.toString().padLeft(2, '0')}'; // Format as HH:mm:ss

    Appointment appointment = Appointment(
      userID: ID,
      petID: _selectedPetID,
      appointmentDATE: appointmentDATE,
      appointmentTIME:
          appointmentTIME, // Use the DateTime string representation
      services: _selectedServices,
    );

    final url =
        'http://localhost:8080/api/appointment/add'; // Replace with your API endpoint
    final body = jsonEncode(appointment.toJson());
    print('Body: $body');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print('Appointment saved successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              userID: ID,
            ), // Pass serviceCODE
          ),
        );
      } else {
        throw Exception('Failed to save appointment');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

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
                    _loading
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final results =
                                        await showDialog<List<Service>>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MultiSelectDialog<Service>(
                                          items: _services
                                              .map((service) =>
                                                  MultiSelectItem<Service>(
                                                      service,
                                                      service.serviceNAME))
                                              .toList(),
                                          title: Text("Select Services"),
                                          selectedColor: Colors.green,
                                          initialValue:
                                              _selectedServices, // Pass the selected services here
                                          onConfirm: (selected) {
                                            setState(() {
                                              _selectedServices =
                                                  selected; // Update the state with selected services
                                            });
                                          },
                                        );
                                      },
                                    );

                                    // Update the selected services if the dialog was confirmed
                                    if (results != null) {
                                      setState(() {
                                        _selectedServices = results;
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedServices.isNotEmpty
                                              ? _selectedServices
                                                  .map((service) => service
                                                      .serviceCODE) // Use serviceCode instead of serviceNAME
                                                  .join(', ')
                                              : 'Select Services',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedServices.isNotEmpty
                                                ? Colors.black
                                                : Color(0xff868889),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // To get a list of service codes later
                              ],
                            ),
                          ),

                    const SizedBox(height: 20),
                    _loading
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // Show dialog to select a single pet
                                    final result = await showDialog<Pet>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Select a Pet"),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: _pets.map((pet) {
                                                return RadioListTile<Pet>(
                                                  title: Text(pet
                                                      .petNAME), // Assuming petName is a property of Pet
                                                  value: pet,
                                                  groupValue:
                                                      _selectedPets, // Keep this for UI purpose
                                                  onChanged: (Pet? value) {
                                                    setState(() {
                                                      _selectedPets =
                                                          value; // Update selected pet for display
                                                      _selectedPetID = value
                                                          ?.petID; // Store petID separately
                                                    });
                                                    Navigator.of(context).pop(
                                                        value); // Close the dialog with the selected pet
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close dialog without selecting
                                              },
                                              child: Text("Cancel"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // Update the selected pet if the dialog returned a result
                                    if (result != null) {
                                      setState(() {
                                        _selectedPets =
                                            result; // Update the state with selected pet
                                        _selectedPetID = result
                                            .petID; // Ensure the ID is updated
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _selectedPets != null
                                              ? _selectedPets
                                                  .petNAME // Display selected pet name
                                              : 'Select a Pet',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedPets != null
                                                ? Colors.black
                                                : Color(0xff868889),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 20),
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
                          if (_isValidTime(time)) {
                            setState(() {
                              timePicker.text = time.format(context);
                            });
                          } else {
                            // Show alert if the time is outside working hours
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Invalid Time'),
                                content: Text(
                                    'The spa serves between 8:00 AM - 11:00 AM and 1:00 PM - 5:00 PM.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date picker with validation
                    TextField(
                      controller: datePicker,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Pick today\'s Date',
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
                          lastDate: DateTime(2050),
                        );

                        if (dateTime != null) {
                          if (_isValidDay(dateTime)) {
                            String dateTimeFormatted =
                                DateFormat('yyyy-MM-dd').format(dateTime);
                            setState(() {
                              datePicker.text = dateTimeFormatted;
                            });
                          } else {
                            // Show alert if the day is Saturday or Sunday
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Invalid Day'),
                                content: Text(
                                    'The spa does not operate on Saturday and Sunday.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
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
                      HomePage(userID: ID)), // Điều hướng đến trang mới
            );
          },
          hideImage: true,
          pathImage: 'assets/images/avatar01.jpg',
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
                'Booking our services',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 25,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Row(
                children: [
                  _time(),
                  const SizedBox(
                    width: 30,
                  ),
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
      onPressed: _loading
          ? null
          : () async {
              setState(() {
                _loading = true; // Start loading
              });

              try {
                await submitAppointment(); // Call submitAppointment asynchronously
                // Optionally show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Appointment booked successfully!')),
                );
              } catch (error) {
                // Handle the error, show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to book appointment: $error')),
                );
              } finally {
                setState(() {
                  _loading = false; // Stop loading
                });
              }
            },
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xffffffff), // Text color
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
            // Text in the middle
            Text(
              _loading
                  ? 'Booking...'
                  : 'Book an appointment', // Change text when loading
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Fredoka',
              ),
            ),
            const SizedBox(width: 30),
            // Icon on the right
            _loading // Show loading indicator instead of icon when loading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2, // Adjust size
                  )
                : Icon(
                    Icons.calendar_today, // Icon to change as desired
                    size: 24, // Icon size
                  ),
          ],
        ),
      ),
    );
  }
  // Widget _buttonAppointment() {
  //   return ElevatedButton(
  //     onPressed: () {
  //       submitAppointment();
  //     },
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: Color(0xffffffff), // Màu chữ
  //       backgroundColor: Color(0xff5CB15A), // Màu nền
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       padding: const EdgeInsets.symmetric(vertical: 16),
  //     ),
  //     child: SizedBox(
  //       width: double.infinity,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center, // Đẩy icon về bên phải
  //         children: [
  //           // Text ở giữa
  //           Text(
  //             'Book an appointment',
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 30,
  //               fontFamily: 'Fredoka',
  //             ),
  //           ),
  //           const SizedBox(width: 30),
  //           // Icon bên phải
  //           Icon(
  //             Icons.calendar_today, // Thay đổi icon theo ý muốn
  //             size: 24, // Kích thước icon
  //             // Màu icon
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
