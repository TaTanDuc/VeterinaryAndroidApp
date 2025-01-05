import 'package:application/bodyToCallAPI/Service.dart';

import 'package:intl/intl.dart';

class Appointment {
  final int petID;
  final int departmentID;
  final String dateTime;
  final List<Service> services;

  Appointment({
    required this.petID,
    required this.departmentID,
    required this.dateTime,
    required this.services,
  });
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      petID: json['petID'] ?? 0,
      departmentID: json['departmentID'] ?? 0,
      dateTime: json['dateTime'].toString(),
      services: (json['services'] as List)
          .map((serviceJson) => Service.fromJson(serviceJson))
          .toList(),
    );
  }

  // Convert AppointmentDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'petID': petID,
      'departmentID': departmentID,
      'dateTime': dateTime,
      'servicesCODE': services.map((service) => service.serviceCode).toList()
    };
  }
}
