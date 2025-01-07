import 'package:application/bodyToCallAPI/Invoice.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

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
    setState(() {
      _loading = false;
    });

    final url = Uri.parse(
        'http://192.168.137.1:8080/api/customer/appointment/getApmInvoices');
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> invoiceData = jsonDecode(response.body)['returned'];
        setState(() {
          _invoices =
              invoiceData.map((json) => Invoice.fromJson(json)).toList();
          _loading = false;
        });
        print('invoiceData: $_invoices');
      } else {
        throw Exception('Failed to load invoicements');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
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
            'Your invoices appointment',
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
              height: AppBar().preferredSize.height,
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
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _invoices.length,
      itemBuilder: (context, index) {
        final invoice = _invoices[index];
        return _buildInvoiceCard(invoice);
      },
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    DateTime parsedDateTime;
    try {
      parsedDateTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(invoice.paidDate);
    } catch (e) {
      parsedDateTime = DateTime.now();
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Method:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        (invoice.method.isNotEmpty)
                            ? invoice.method
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        (invoice.paidDate?.isNotEmpty == true)
                            ? formattedDate
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Time:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        (invoice.paidDate?.isNotEmpty == true)
                            ? formattedTime
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Your total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        (invoice.total != 0)
                            ? invoice.total.toString() + ' USD'
                            : '0 USD',
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
