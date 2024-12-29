import 'package:application/bodyToCallAPI/Invoice.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListOrder extends StatefulWidget {
  const ListOrder({super.key});
  @override
  _ListOrderState createState() => _ListOrderState();
}

class _ListOrderState extends State<ListOrder> {
  bool _loading = true;
  List<Invoice> _invoices = [];
  dynamic ID;
  @override
  void initState() {
    super.initState();
    fetchInvoice(); // Call fetchInvoice when the widget is initialized
  }

  // Method to fetch services from API
  Future<void> fetchInvoice() async {
    final userManager = UserManager(); // Ensure singleton access
    UserDTO? currentUser = userManager.user;
    setState(() {
      _loading = false;
    });
    if (currentUser != null) {
      print("User ID in appontments: ${currentUser.userID}");
      ID = currentUser.userID;
    } else {
      print("No user is logged in here.");
    }
    final url =
        Uri.parse('http://10.0.0.2/api/invoice/getUserInvoices?userID=$ID');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'}, // Optional for GET
      );
// Log the response body for debugging

      if (response.statusCode == 200) {
        final List<dynamic> invoiceData = jsonDecode(response.body);
        setState(() {
          _invoices = invoiceData
              .map((json) => Invoice.fromJson(json))
              .toList(); // Populate the services list
          _loading = false;
        });
        print('invoiceData: $_invoices');
      } else {
        throw Exception('Failed to load invoicements');
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
            'Your invoicess',
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
                  : _invoices.isEmpty
                      ? Center(child: Text('No invoicess found.'))
                      : _buildInvoiceList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList() {
    return ListView.builder(
      physics:
          NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
      shrinkWrap: true, // Use available space
      itemCount: _invoices.length,
      itemBuilder: (context, index) {
        final invoice = _invoices[index];
        return _buildInvoiceCard(invoice);
      },
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Aligns the items at the start
                    children: [
                      const Text(
                        'Invoice code (A is apponitment and B is buy):', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (invoice.invoiceCODE?.isNotEmpty == true)
                            ? invoice.invoiceCODE
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
                        'ID invoice:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (invoice.invoiceID.isNotEmpty)
                            ? invoice.invoiceID.toString()
                            : '0',
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
                        'Date:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (invoice.invoiceDATE?.isNotEmpty == true)
                            ? invoice.invoiceDATE
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
                        'Your total:', // Label text
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Space between label and name
                      Text(
                        (invoice.total.isNotEmpty)
                            ? invoice.total.toString()
                            : 'error',
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
