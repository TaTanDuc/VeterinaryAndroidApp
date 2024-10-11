import 'package:application/bodyToCallAPI/Service.dart';

class Appointment {
  final int profileID;
  final int petID;
  final DateTime appointmentDATE;
  final String
      appointmentTIME; // Use String if the time is sent in a specific format
  final List<Service> services;

  Appointment({
    required this.profileID,
    required this.petID,
    required this.appointmentDATE,
    required this.appointmentTIME,
    required this.services,
  });

  // Convert JSON to AppointmentDTO
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      profileID: json['profileID'],
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
      'profileID': profileID,
      'petID': petID,
      'appointmentDATE': appointmentDATE.toIso8601String(),
      'appointmentTIME': appointmentTIME,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}
