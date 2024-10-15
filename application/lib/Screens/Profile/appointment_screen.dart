import 'package:application/Screens/Services/detailService_screen.dart';
import 'package:application/bodyToCallAPI/ListAppoint.dart';
import 'package:application/bodyToCallAPI/Service.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListApointment extends StatefulWidget {
  const ListApointment({super.key});
  @override
  _ListApointmentState createState() => _ListApointmentState();
}

class _ListApointmentState extends State<ListApointment> {
  bool _loading = true;
  List<ListAppoint> _appointments = [];
  dynamic ID;
  @override
  void initState() {
    super.initState();
    fetchAppointment(); // Call fetchAppointment when the widget is initialized
  }

  // Method to fetch services from API
  Future<void> fetchAppointment() async {
    final userManager = UserManager(); // Ensure singleton access
    User? currentUser = userManager.user;
    setState(() {
      _loading = false;
    });
    if (currentUser != null) {
      print("User ID in appontments: ${currentUser.userID}");
      ID = currentUser.userID;
    } else {
      print("No user is logged in here.");
    }
    final url = Uri.parse(
        'http://localhost:8080/api/appointment/getUserAppointment?userID=$ID');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'}, // Optional for GET
      );
// Log the response body for debugging

      if (response.statusCode == 200) {
        final List<dynamic> appointmentData = jsonDecode(response.body);
        setState(() {
          _appointments = appointmentData
              .map((json) => ListAppoint.fromJson(json))
              .toList(); // Populate the services list
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
              child: Image.asset(
                "assets/icons/anonymus.webp",
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
                        'Name:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.profileNAME?.isNotEmpty == true)
                            ? appoint.profileNAME
                            : 'Unknown your name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Aligns the items at the start
                    children: [
                      const Text(
                        'Your apponitment date:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.apmDATE?.isNotEmpty == true)
                            ? appoint.apmDATE
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
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Aligns the items at the start
                    children: [
                      const Text(
                        'Your appointment time:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.appointmentTIME?.isNotEmpty == true)
                            ? appoint.appointmentTIME
                            : 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
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
