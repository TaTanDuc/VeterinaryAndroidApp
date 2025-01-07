import 'package:application/Screens/Profile/DetailsApointment.dart';
import 'package:application/Screens/Services/detailService_screen.dart';
import 'package:application/bodyToCallAPI/GetDetailsAppointment.dart';
import 'package:application/bodyToCallAPI/ListAppoint.dart';
import 'package:application/bodyToCallAPI/Apointmentinvoice.dart';
import 'package:application/bodyToCallAPI/Service.dart';
import 'package:application/bodyToCallAPI/ServiceInvoice.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/main.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ListApointment extends StatefulWidget {
  const ListApointment({super.key});
  @override
  _ListApointmentState createState() => _ListApointmentState();
}

class _ListApointmentState extends State<ListApointment> {
  bool _loading = true;
  List<ListAppoint> _appointments = [];
  List<Details> _appointmentsInvoice = [];
  dynamic ID;
  bool success = false;
  int totalPrice = 0;
  int amount = 0;
  Map<String, dynamic>? intentPaymentData;

  @override
  void initState() {
    super.initState();
    fetchAppointment(); // Call fetchAppointment when the widget is initialized
  }

  // Method to fetch services from API
  Future<void> fetchAppointment() async {
    setState(() {
      _loading = false;
    });
    final session = await SessionManager().getSession();
    final url = Uri.parse('http://192.168.137.1:8080/api/customer/appointment');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> appointmentData =
            jsonDecode(response.body)['returned'];
        setState(() {
          _appointments = appointmentData
              .map((json) => ListAppoint.fromJson(json))
              .toList();
          _loading = false;
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Error: $e'); // Print error message
      setState(() {
        _loading = false; // Stop loading in case of error
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
            'Your appointment',
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
              height: AppBar().preferredSize.height, // Match the AppBar height
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _appointments.isEmpty
                      ? Center(child: Text('No appointments found.'))
                      : _buildAppointmetnList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmetnList() {
    return ListView.builder(
      physics:
          NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
      shrinkWrap: true, // Use available space
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final appoint = _appointments[index];
        return _buildAppointmetnCard(appoint);
      },
    );
  }

  Widget _buildAppointmetnCard(ListAppoint appoint) {
    DateTime parsedDateTime;
    try {
      parsedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss")
          .parse(appoint.appointmentDateTime);
    } catch (e) {
      parsedDateTime =
          DateTime.now(); // Fallback to current time if parsing fails
    }

    // Format date and time
    String formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDateTime);
    String formattedTime = DateFormat('hh:mm a').format(parsedDateTime);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(2, 2, 20, 0),
              child: Image.network(
                appoint.petIMG,
                fit: BoxFit.contain,
                width: 100,
                height: 100,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Aligns the items at the start
                    children: [
                      const Text(
                        'Your pet:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.petNAME?.isNotEmpty == true)
                            ? appoint.petNAME
                            : 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align items to the start
                    children: [
                      const Text(
                        'Date:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and value
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align items to the start
                    children: [
                      const Text(
                        'Time:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align items to the start
                    children: [
                      const Text(
                        'Status:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.appointmentStatus?.isNotEmpty == true)
                            ? appoint.appointmentStatus
                            : 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Add Check Out button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsAppointment(
                                    details: appoint,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
