import 'package:application/Screens/Services/detailService_screen.dart';
import 'package:application/bodyToCallAPI/Service.dart';
import 'package:application/bodyToCallAPI/User.dart';
import 'package:application/pages/Homepage/explore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServicePage extends StatefulWidget {
  final int userID;

  const ServicePage({super.key, required this.userID});
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  bool _loading = true;
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    fetchServices(); // Call fetchServices when the widget is initialized
  }

  // Method to fetch services from API
  Future<void> fetchServices() async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/api/service/all'); // Replace with your actual API URL
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'}, // Optional for GET
      );
// Log the response body for debugging

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to ShopPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ExplorePage(
                    userID: widget.userID,
                  )), // Replace ShopPage with the actual widget for your shop page
        );
        return false; // Prevent the default pop action
      },
      child: Scaffold(
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
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Our Service",
                  style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Center(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : _services.isEmpty
                        ? Center(child: Text('No services found.'))
                        : _buildServiceList(),
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: const Color(0xFF5CB15A),
    //     title: const Center(
    //       child: Text(
    //         'Service',
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 16,
    //           fontFamily: 'Fredoka',
    //         ),
    //       ),
    //     ),
    //     actions: [
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: SizedBox(
    //           height: AppBar().preferredSize.height, // Match the AppBar height
    //           child: Image.asset(
    //             'assets/icons/logo.png',
    //             fit: BoxFit.contain,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Padding(
    //           padding: EdgeInsets.all(16.0),
    //           child: Text(
    //             "Our Service",
    //             style: TextStyle(
    //                 fontFamily: 'Fredoka',
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 20),
    //           ),
    //         ),
    //         Center(
    //           child: _loading
    //               ? Center(child: CircularProgressIndicator())
    //               : _services.isEmpty
    //                   ? Center(child: Text('No services found.'))
    //                   : _buildServiceList(),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      physics:
          NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
      shrinkWrap: true, // Use available space
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(
              service.imageService,
              fit: BoxFit.contain,
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceNAME,
                    style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'Fredoka',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.serviceDATE,
                    style: const TextStyle(fontSize: 16, fontFamily: 'Fredoka'),
                  ),
                  const SizedBox(height: 8),
                  _buildStarRating(service.serviceRATING.toInt()),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (service != null && service.serviceCODE != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailServiceScreen(
                              serviceCODE: service.serviceCODE,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Service or service code is not available')),
                        );
                      }
                    },
                    child: const Text(
                      'Show more',
                      style: TextStyle(
                        color: Color.fromARGB(255, 206, 51, 234),
                        fontSize: 16,
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
}
