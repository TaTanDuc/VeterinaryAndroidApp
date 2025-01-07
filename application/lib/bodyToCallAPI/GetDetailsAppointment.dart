import 'dart:ffi';

import 'package:application/bodyToCallAPI/ServiceInvoice.dart';

class Details {
  final int appointmentID;
  final String petNAME;
  final String departmentAddress;
  final String appointmentDateTime;
  final String appointmentStatus;
  final int apmInvoiceID;
  final List<ServiceInvoice> services;

  Details({
    required this.appointmentID,
    required this.petNAME,
    required this.departmentAddress,
    required this.appointmentDateTime,
    required this.appointmentStatus,
    required this.apmInvoiceID,
    required this.services,
  });

  factory Details.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Details(
      appointmentID: json['appointmentID'] ?? 0,
      petNAME: (json['petNAME']).toString() ?? 'Unknown',
      departmentAddress: (json['departmentAddress']).toString() ?? 'Unknown',
      appointmentDateTime: json['appointmentDateTime'],
      appointmentStatus: (json['appointmentStatus']) ?? 'Unknown',
      apmInvoiceID: json['apmInvoiceID'] ?? 0,
      services: (json['services'] as List)
              .map((serviceJson) => ServiceInvoice.fromJson(serviceJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentID': appointmentID,
      'petNAME': petNAME,
      'appointmentDateTime': appointmentDateTime,
      'appointmentStatus': appointmentStatus,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Appointment(profileNAME: $appointmentID, petNAME: $petNAME, apmDATE: $appointmentDateTime, appointmentTIME: $appointmentStatus, AppointmentInvoice: $apmInvoiceID,sdfjfhdfhff:$services)';
  }
}
