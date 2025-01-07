import 'package:application/bodyToCallAPI/Service.dart';

class Apointmentinvoice {
  final int appointmentID;
  final String method;
  final int total;

  Apointmentinvoice({
    required this.appointmentID,
    required this.method,
    required this.total,
  });

  factory Apointmentinvoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Apointmentinvoice(
      appointmentID: json['appointmentID'] ?? 0,
      method: (json['method']).toString() ?? 'Unknown',
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentID': appointmentID,
      'method': method,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'Appointment(profileNAME: $appointmentID, petNAME: $method, apmDATE: $total)';
  }
}
