import 'dart:ffi';

import 'package:application/bodyToCallAPI/ServiceInvoice.dart';

class InvoiceDetails {
  final int apmInvoiceID;
  final int appointmentID;
  final String petNAME;
  final String departmentAddress;
  final String appointmentDateTime;
  final String appointmentStatus;
  final String method;
  final String paidDate;
  final int total;
  final List<ServiceInvoice> services;

  InvoiceDetails({
    required this.apmInvoiceID,
    required this.appointmentID,
    required this.petNAME,
    required this.departmentAddress,
    required this.appointmentDateTime,
    required this.appointmentStatus,
    required this.method,
    required this.paidDate,
    required this.total,
    required this.services,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return InvoiceDetails(
      apmInvoiceID: json['apmInvoiceID'] ?? 0,
      appointmentID: json['appointmentID'] ?? 0,
      petNAME: (json['petNAME']).toString() ?? 'Unknown',
      departmentAddress: (json['departmentAddress']).toString() ?? 'Unknown',
      appointmentDateTime: json['appointmentDateTime'] ?? '',
      appointmentStatus: (json['appointmentStatus']) ?? 'Unknown',
      method: (json['method']).toString() ?? 'Unknown',
      paidDate: json['paidDate'] ?? '',
      total: json['total'] ?? 0,
      services: (json['services'] as List?)
              ?.map((serviceJson) => ServiceInvoice.fromJson(serviceJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apmInvoiceID': apmInvoiceID,
      'appointmentID': appointmentID,
      'petNAME': petNAME,
      'departmentAddress': departmentAddress,
      'appointmentDateTime': appointmentDateTime,
      'appointmentStatus': appointmentStatus,
      'method': method,
      'paidDate': paidDate,
      'total': total,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'InvoiceDetails(apmInvoiceID: $apmInvoiceID, appointmentID: $appointmentID, petNAME: $petNAME, appointmentDateTime: $appointmentDateTime, appointmentStatus: $appointmentStatus, method: $method, paidDate: $paidDate, total: $total, services: $services)';
  }
}



