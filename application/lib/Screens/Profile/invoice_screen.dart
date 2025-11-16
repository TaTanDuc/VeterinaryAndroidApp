import 'dart:convert';
import 'package:application/bodyToCallAPI/Invoice.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'DetailsInvoice.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  bool _loading = true;
  List<Invoice> _invoices = [];

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    setState(() {
      _loading = true;
    });

    final url =
        Uri.parse('http://10.0.2.2:8080/api/customer/appointment/invoices');
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
        final List<dynamic> invoiceData =
            jsonDecode(response.body)['returned'];
        setState(() {
          _invoices =
              invoiceData.map((json) => Invoice.fromJson(json)).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        throw Exception('Failed to load invoices');
      }
    } catch (e) {
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _invoices.isEmpty
              ? const Center(child: Text('No invoices found.'))
              : RefreshIndicator(
                  onRefresh: _fetchInvoices,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    itemCount: _invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = _invoices[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsInvoice(invoice: invoice),
                            ),
                          );
                        },
                        child: _InvoiceSummaryCard(invoice: invoice),
                      );
                    },
                  ),
                ),
    );
  }
}

class _InvoiceSummaryCard extends StatelessWidget {
  const _InvoiceSummaryCard({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final DateTime paidDate = _parseDate(invoice.paidDate);
    final String formattedDate = DateFormat('MMMM dd, yyyy').format(paidDate);
    final String formattedTime = DateFormat('hh:mm a').format(paidDate);
    final NumberFormat currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice #${invoice.apmInvoiceID}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    label: 'Method',
                    value: invoice.paymentMethod.isNotEmpty
                        ? invoice.paymentMethod
                        : 'Unknown',
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    label: 'Paid',
                    value: '${formattedDate} · ${formattedTime}',
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    label: 'Total',
                    value: currencyFormatter.format(invoice.total),
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 14,
                ),
          ),
        ),
      ],
    );
  }

  static DateTime _parseDate(String raw) {
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(raw);
    } catch (_) {
      return DateTime.now();
    }
  }
}
