import 'dart:convert';
import 'package:application/bodyToCallAPI/GetDetailsInvoice.dart';
import 'package:application/bodyToCallAPI/Invoice.dart';
import 'package:application/bodyToCallAPI/ServiceInvoice.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DetailsInvoice extends StatefulWidget {
  final Invoice invoice;

  const DetailsInvoice({required this.invoice, super.key});

  @override
  _DetailsInvoiceState createState() => _DetailsInvoiceState();
}

class _DetailsInvoiceState extends State<DetailsInvoice> {
  final List<InvoiceDetails> _invoicesDetails = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchInvoiceDetails();
  }

  Future<void> fetchInvoiceDetails() async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse(
        'http://10.0.2.2:8080/api/customer/appointment/getInvoiceDetail?apmInvoiceID=${widget.invoice.apmInvoiceID}');
    try {
      final session = await SessionManager().getSession();
      print('Session: $session');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session',
        },
      );
      print('Response Body: ${response.body}');
      if (response.statusCode == 200 && mounted) {
        final Map<String, dynamic> invoiceData =
            jsonDecode(response.body)['returned'];
        final InvoiceDetails invoiceDetails =
            InvoiceDetails.fromJson(invoiceData);

        for (var service in invoiceDetails.services) {
          print(
              'Service Name: ${service.serviceNAME}, Price: ${service.servicePRICE}');
        }

        setState(() {
          _invoicesDetails
            ..clear()
            ..add(invoiceDetails);
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        throw Exception('Failed to load invoice details');
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Center(
          child: Text(
            'Invoice Details',
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
          : page(_invoicesDetails),
    );
  }

  Widget page(List<InvoiceDetails> details) {
    if (details.isEmpty) {
      return const Center(child: Text('No Invoice Details Available'));
    }

    final InvoiceDetails invoice = details.first;
    final double totalPrice = invoice.services.fold<double>(
      0,
      (sum, service) => sum + service.servicePRICE,
    );
    final DateTime parsedAppointmentDate =
        _tryParseDate(invoice.appointmentDateTime);
    final DateTime parsedPaidDate = _tryParseDate(invoice.paidDate);

    final String formattedAppointmentDate =
        DateFormat('MMMM dd, yyyy').format(parsedAppointmentDate);
    final String formattedAppointmentTime =
        DateFormat('hh:mm a').format(parsedAppointmentDate);
    final String formattedPaidDate =
        DateFormat('MMMM dd, yyyy').format(parsedPaidDate);
    final String formattedPaidTime =
        DateFormat('hh:mm a').format(parsedPaidDate);

    return RefreshIndicator(
      onRefresh: fetchInvoiceDetails,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          _InvoiceHeaderCard(
            invoice: invoice,
            formattedAppointmentDate: formattedAppointmentDate,
            formattedAppointmentTime: formattedAppointmentTime,
            formattedPaidDate: formattedPaidDate,
            formattedPaidTime: formattedPaidTime,
            totalPrice: totalPrice,
          ),
          const SizedBox(height: 16),
          _ServiceListCard(
            services: invoice.services,
            totalPrice: totalPrice,
          ),
        ],
      ),
    );
  }

  DateTime _tryParseDate(String raw) {
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(raw);
    } catch (_) {
      return DateTime.now();
    }
  }
}

class _InvoiceHeaderCard extends StatelessWidget {
  const _InvoiceHeaderCard({
    required this.invoice,
    required this.formattedAppointmentDate,
    required this.formattedAppointmentTime,
    required this.formattedPaidDate,
    required this.formattedPaidTime,
    required this.totalPrice,
  });

  final InvoiceDetails invoice;
  final String formattedAppointmentDate;
  final String formattedAppointmentTime;
  final String formattedPaidDate;
  final String formattedPaidTime;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice #${invoice.apmInvoiceID}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Pet Name', invoice.petNAME),
            _buildInfoRow('Department Address', invoice.departmentAddress),
            _buildInfoRow(
              'Appointment',
              '$formattedAppointmentDate · $formattedAppointmentTime',
            ),
            _buildInfoRow(
              'Paid On',
              '$formattedPaidDate · $formattedPaidTime',
            ),
            _buildInfoRow('Payment Method', invoice.method),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  invoice.appointmentStatus,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: invoice.appointmentStatus == "Pending"
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 24,
              thickness: 1.1,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total Paid: ${currencyFormatter.format(totalPrice)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
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
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceListCard extends StatelessWidget {
  const _ServiceListCard({
    required this.services,
    required this.totalPrice,
  });

  final List<ServiceInvoice> services;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 12),
            if (services.isEmpty)
              const Text(
                'No services recorded for this invoice.',
                style: TextStyle(fontSize: 14),
              )
            else
              ...services.map(
                (service) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.serviceNAME,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        currencyFormatter.format(service.servicePRICE),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(
              color: Colors.grey,
              thickness: 1.1,
              height: 32,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: ${currencyFormatter.format(totalPrice)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.receipt_long),
                label: const Text(
                  'Payment completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



