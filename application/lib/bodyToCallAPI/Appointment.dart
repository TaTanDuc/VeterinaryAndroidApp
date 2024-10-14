import 'package:application/bodyToCallAPI/Service.dart';

import 'package:intl/intl.dart';

class Appointment {
  final int userID;
  final int petID;
  final DateTime appointmentDATE;
  final String
      appointmentTIME; // Use String if the time is sent in a specific format
  final List<Service> services;

  Appointment({
    required this.userID,
    required this.petID,
    required this.appointmentDATE,
    required this.appointmentTIME,
    required this.services,
  });
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      userID: json['userID'],
      petID: json['petID'],
      appointmentDATE: DateTime.parse(json['appointmentDATE']),
      appointmentTIME: json['appointmentTIME'],
      services: (json['services'] as List)
          .map((serviceJson) => Service.fromJson(serviceJson))
          .toList(),
    );
  }

  // Convert AppointmentDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'petID': petID,
      // Format appointmentDATE to only include the date (yyyy-MM-dd)
      'appointmentDATE': DateFormat('yyyy-MM-dd').format(appointmentDATE),
      'appointmentTIME': appointmentTIME,
      'services': services
          .map((service) => {'serviceCODE': service.serviceCODE})
          .toList()
    };
  }
}
