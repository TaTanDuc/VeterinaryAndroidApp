import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:application/bodyToCallAPI/DetailsItemInvoice.dart';
import 'package:application/bodyToCallAPI/ListInvoiceItem.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';

class DetailsInvoiceItem extends StatefulWidget {
  final ListInvoice details;

  const DetailsInvoiceItem({required this.details, super.key});

  @override
  _DetailsInvoiceItemState createState() => _DetailsInvoiceItemState();
}

class _DetailsInvoiceItemState extends State<DetailsInvoiceItem> {
  List<DetailsItemInvoice> _appointmentsInvoice = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchUpdateUser();
  }

  Future<void> fetchUpdateUser() async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/customer/shop/purchase-details?invoiceID=${widget.details.purchaseInvoiceID}');
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> shopData = jsonDecode(response.body)['returned'];
        DetailsItemInvoice details =
            DetailsItemInvoice.fromJson({'c': shopData});

        setState(() {
          _appointmentsInvoice.add(details);
          _loading = false;
        });
      } else {
        throw Exception('Failed to load appointments');
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
            'Details Item Invoice',
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : page(_appointmentsInvoice),
    );
  }

  Widget page(List<DetailsItemInvoice> details) {
    final screenWidth = MediaQuery.of(context).size.width;

    return details.isEmpty
        ? Center(
            child: Text(
              'No Invoice Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: details.map((appointment) {
                double total = appointment.items.fold(
                  0,
                  (sum, item) => sum + (item.price * item.itemQUANTITY),
                );

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Invoice Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice #${widget.details.purchaseInvoiceID}',
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF5CB15A),
                              ),
                            ),
                            Text(
                              'Date: ${DateTime.now().toLocal().toString().split(" ")[0]}',
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 12 : 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Items Table
                        Text(
                          'Items',
                          style: TextStyle(
                            fontSize: screenWidth < 400 ? 14 : 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 10),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFF5CB15A).withOpacity(0.1),
                            ),
                            columns: const [
                              DataColumn(label: Text('Item')),
                              DataColumn(label: Text('Qty')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Total')),
                            ],
                            rows: appointment.items.map((service) {
                              final itemTotal =
                                  service.price * service.itemQUANTITY;
                              return DataRow(cells: [
                                DataCell(Text(service.itemNAME)),
                                DataCell(Text(service.itemQUANTITY.toString())),
                                DataCell(Text(
                                    '\$${service.price.toStringAsFixed(2)}')),
                                DataCell(
                                    Text('\$${itemTotal.toStringAsFixed(2)}')),
                              ]);
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Totals Section
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Divider(),
                              Text(
                                'Total: \$${(total).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: screenWidth < 400 ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5CB15A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}
