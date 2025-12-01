import 'package:application/Screens/Profile/DetailsInvoiceItem.dart';
import 'package:application/bodyToCallAPI/DetailsItemInvoice.dart';
import 'package:application/bodyToCallAPI/ListInvoiceItem.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ListInvoiceItem extends StatefulWidget {
  const ListInvoiceItem({super.key});
  @override
  _ListInvoiceItemState createState() => _ListInvoiceItemState();
}

class _ListInvoiceItemState extends State<ListInvoiceItem> {
  bool _loading = true;
  List<ListInvoice> _items = [];
  List<DetailsItemInvoice> _itemsInvoice = [];
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
    final url =
        Uri.parse('http://10.0.2.2:8080/api/customer/shop/purchase-history');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> appointmentData =
            jsonDecode(response.body)['returned'];
        setState(() {
          _items = (appointmentData as List)
              .map((json) => ListInvoice.fromJson(json as Map<String, dynamic>))
              .toList();
          print('_items: $_items');
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
            'Your invoice item',
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
                  : _items.isEmpty
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
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final appoint = _items[index];
        return _buildAppointmetnCard(appoint);
      },
    );
  }

  Widget _buildAppointmetnCard(ListInvoice appoint) {
    DateTime parsedDateTime;
    try {
      parsedDateTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(appoint.createdDate);
    } catch (e) {
      parsedDateTime =
          DateTime.now(); // Fallback to current time if parsing fails
    }

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
                        (appoint.userName?.isNotEmpty == true)
                            ? appoint.userName
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
                      const SizedBox(width: 8), // Space between label and value
                      Text(
                        formattedTime,
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
                        'Payment method:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.paymentMethod?.isNotEmpty == true)
                            ? appoint.paymentMethod
                            : 'unknown',
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
                        'Total:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (appoint.total != 0)
                            ? appoint.total.toString() + 'USD'
                            : '0 USD',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsInvoiceItem(
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
