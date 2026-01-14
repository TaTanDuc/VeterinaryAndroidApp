import 'package:application/bodyToCallAPI/Service.dart';

class Apointmentinvoice {
  final int appointmentID;
  final String paymentMethod;
  final int total;

  Apointmentinvoice({
    required this.appointmentID,
    required this.paymentMethod,
    required this.total,
  });

  factory Apointmentinvoice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return Apointmentinvoice(
      appointmentID: json['appointmentID'] ?? 0,
      paymentMethod: (json['paymentMethod']).toString() ?? 'Unknown',
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentID': appointmentID,
      'paymentMethod': paymentMethod,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'Appointment(profileNAME: $appointmentID, petNAME: $paymentMethod, apmDATE: $total)';
  }
}
