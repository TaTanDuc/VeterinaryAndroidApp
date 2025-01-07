import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:application/Screens/Profile/appointment_screen.dart';
import 'package:application/bodyToCallAPI/ApointmentInvoice.dart';
import 'package:application/bodyToCallAPI/GetDetailsAppointment.dart';
import 'package:application/bodyToCallAPI/ListAppoint.dart';
import 'package:application/bodyToCallAPI/Profile.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/main.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:application/Screens/Profile/profile_screen.dart';
import 'package:application/bodyToCallAPI/UserDTO.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/components/customNavContent.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;

class DetailsAppointment extends StatefulWidget {
  final ListAppoint details;

  const DetailsAppointment({required this.details, super.key});

  @override
  _DetailsAppointmentState createState() => _DetailsAppointmentState();
}

class _DetailsAppointmentState extends State<DetailsAppointment> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  List<Details> _appointmentsInvoice = [];
  dynamic ID;
  bool _loading = false;
  bool success = false;
  bool isInvoice = false;
  int totalPrice = 0;
  double amount = 0;
  Map<String, dynamic>? intentPaymentData;
  final String _secretKey =
      "sk_test_51QXwiTC5mILZpjuwQ5ktL2zo91QyzUB275GKmR9vaXC8myKL7LCRO6Fs2CKYbtEwQgztaGe7FsOZ8hsEXaiTlGtX00LjtvEEdt";

  makeIntentForPayment(amountChanged, currency) async {
    try {
      Map<String, dynamic>? paymentInfo = {
        "amount": (int.parse(amountChanged)).toString(),
        "currency": currency,
        "payment_method_types[]": "card"
      };
      print('amount ${(int.parse(amountChanged)).toString()}');
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

  showPaymentSheet() async {
    try {
      await Stripe.Stripe.instance.presentPaymentSheet().then((val) {
        intentPaymentData = null;
        const ToastCard(
          leading: Icon(Icons.check, size: 20),
          title: const Text(
            'Payment successful',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                fontFamily: 'Fredoka',
                color: Color(0xff5CB15A)),
          ),
        );
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
          final urlInvoicePayment = Uri.parse(
            'http://192.168.137.1:8080/api/customer/appointment/pay',
          );

          // Create Appointment Invoice DTO
          final Apointmentinvoice profileDTO = Apointmentinvoice(
            appointmentID: widget.details.appointmentID,
            method: "VISA",
            total: totalPrice,
          );
          final session = await SessionManager().getSession();
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

  paymentSheetInitialization(amountChanged, currency) async {
    try {
      int? amountToSend = (double.tryParse(amountChanged) ?? 0 * 100).toInt();

      if (amountToSend == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid amount format')),
        );
        return;
      }
      intentPaymentData =
          await makeIntentForPayment(amountToSend.toString(), currency);
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
      showPaymentSheet();
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
    fetchUpdateUser();
  }

  Future<void> fetchUpdateUser() async {
    setState(() {
      _loading = true;
    });

    final url = Uri.parse(
        'http://192.168.137.1:8080/api/customer/appointment/getDetail?appointmentID=${widget.details.appointmentID}');
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
      if (response.statusCode == 200) {
        final Map<String, dynamic> shopData =
            jsonDecode(response.body)['returned'];
        Details details = Details.fromJson(shopData);
        if (details.apmInvoiceID != 0) {
          isInvoice = true;
        }
        // Calculate total price and print service details
        for (var service in details.services) {
          totalPrice += service.servicePRICE;
          print(
              'Service Name: ${service.serviceNAME}, Price: ${service.servicePRICE}');
        }

        setState(() {
          _appointmentsInvoice.add(details);
          _loading = false;
          print('Invoice: $_appointmentsInvoice');
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
            'Update user',
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
      body: page(_appointmentsInvoice),
    );
  }

  Widget page(List<Details> details) {
    return details.isEmpty
        ? Center(child: Text('No Appointments Available'))
        : ListView.builder(
            itemCount: details.length,
            itemBuilder: (context, index) {
              final appointment = details[index];
              double totalPrice = appointment.services
                  .fold(0, (sum, service) => sum + service.servicePRICE);
              DateTime parsedDateTime;
              try {
                parsedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                    .parse(appointment.appointmentDateTime);
              } catch (e) {
                parsedDateTime =
                    DateTime.now(); // Fallback to current time if parsing fails
              }

              // Format date and time
              String formattedDate =
                  DateFormat('MMMM dd, yyyy').format(parsedDateTime);
              String formattedTime =
                  DateFormat('hh:mm a').format(parsedDateTime);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Name: ${appointment.petNAME}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10), // Add spacing between elements
                      Text(
                        'Department Address: ${appointment.departmentAddress}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Date & Time: ${formattedDate} - ${formattedTime}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Status: ${appointment.appointmentStatus}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: appointment.appointmentStatus == "Pending"
                                ? Colors.orange
                                : Colors.green),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Services:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(height: 10),
                      ...appointment.services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                service.serviceNAME,
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '\$${service.servicePRICE.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.2,
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: \$${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Checkout Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: isInvoice
                            ? ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Already checked out',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    amount = totalPrice * 100.roundToDouble();
                                  });
                                  paymentSheetInitialization(
                                      amount.toString(), "USD");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Button color
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Rounded corners
                                  ),
                                ),
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
