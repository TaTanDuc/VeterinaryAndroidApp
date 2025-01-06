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
  final String _secretKey =
      "sk_test_51QXwiTC5mILZpjuwQ5ktL2zo91QyzUB275GKmR9vaXC8myKL7LCRO6Fs2CKYbtEwQgztaGe7FsOZ8hsEXaiTlGtX00LjtvEEdt";

  makeIntentForPayment(id, amountChanged, currency) async {
    try {
      Map<String, dynamic>? paymentInfo = {
        "amount": (int.parse(amountChanged)).toString(),
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var responseFromScripeAPI = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: paymentInfo,
          headers: {
            "Authorization": "Bearer $_secretKey",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      print("This is your key" + _secretKey);
      print("response  from API: " + responseFromScripeAPI.body);
      return jsonDecode(responseFromScripeAPI.body);
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg);
      }
      print(errorMsg.toString());
    }
  }

  showPaymentSheet(id) async {
    try {
      await Stripe.Stripe.instance.presentPaymentSheet().then((val) {
        intentPaymentData = null;
        setState(() {
          success = true;
        });
      }).onError((errorMsg, sTrace) {
        if (kDebugMode) {
          print(errorMsg.toString() + sTrace.toString());
        }
      });
      if (success == true) {
        try {
          final urlInvoiceDetails = Uri.parse(
            'http://192.168.137.1:8080/api/customer/appointment/getDetail?appointmentID=$id',
          );
          final session = await SessionManager().getSession();
          print('Session: $session');
          final responseDetails = await http.get(
            urlInvoiceDetails,
            headers: {
              'Content-Type': 'application/json',
              'Cookie': '$session',
            },
          );

          print('Response Body: ${responseDetails.body}');

          if (responseDetails.statusCode == 200) {
            final Map<String, dynamic> shopData =
                jsonDecode(responseDetails.body)['returned'];

// Parse the response
            Details details = Details.fromJson(shopData['services']);

// Print out the services to verify
            for (var service in details.services) {
              totalPrice += service.servicePRICE;
              print(totalPrice);
              print(
                  'Service Name: ${service.serviceName}, Price: ${service.servicePRICE}');
            }
            setState(() {
              _appointmentsInvoice.add(details);
              _loading = false;
              print('Invoice: $_appointmentsInvoice');
            });
          } else {
            throw Exception('Failed to load appointments');
          }

          // Proceed to Payment
          final urlInvoicePayment = Uri.parse(
            'http://192.168.137.1:8080/api/customer/appointment/pay',
          );

          // Create Appointment Invoice DTO
          final Apointmentinvoice profileDTO = Apointmentinvoice(
            appointmentID: id,
            method: "VISA",
            total: totalPrice,
          );

          final responsePayment = await http.post(
            urlInvoicePayment,
            headers: {
              'Content-Type': 'application/json',
              'Cookie': '$session',
            },
            body: jsonEncode(profileDTO.toJson()),
          );

          print('Raw response: ${responsePayment.body}');

          if (responsePayment.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
          } else {
            print(
                'Payment failed with status code: ${responsePayment.statusCode}');
            final errorMessage = responsePayment.body;
            print('Error during payment: $errorMessage');
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            _loading = false;
          });
        }
      }
    } on Stripe.StripeException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showDialog(
          context: context,
          builder: (c) => const AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print(s);
      }
      print(errorMsg.toString());
    }
  }

  paymentSheetInitialization(id, amountChanged, currency) async {
    try {
      int? amountToSend = (double.tryParse(amountChanged) ?? 0 * 100).toInt();

      if (amountToSend == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid amount format')),
        );
        return;
      }
      intentPaymentData =
          await makeIntentForPayment(id, amountToSend.toString(), currency);
      await Stripe.Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: Stripe.SetupPaymentSheetParameters(
                  allowsDelayedPaymentMethods: true,
                  paymentIntentClientSecret:
                      intentPaymentData!["client_secret"],
                  style: ThemeMode.dark,
                  merchantDisplayName: "Spa Pet"))
          .then((val) {
        print(val);
      });
      showPaymentSheet(id);
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print(s);
      }
      print(errorMsg.toString());
    }
  }

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
                        setState(() {
                          amount = 2000000;
                        });
                        paymentSheetInitialization(
                            appoint.appointmentID, amount.toString(), "USD");
                        print(
                            'Check Out for appointment ID: ${appoint.appointmentID}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Check Out',
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
