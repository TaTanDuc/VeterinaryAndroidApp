class ListAppoint {
  final int appointmentID;
  final String petNAME;
  final String petIMG;
  final String appointmentDateTime;

  final String appointmentStatus;

  ListAppoint({
    required this.appointmentID,
    required this.petNAME,
    required this.petIMG,
    required this.appointmentDateTime,
    required this.appointmentStatus,
  });

  factory ListAppoint.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return ListAppoint(
      appointmentID: json['appointmentID'] ?? 0,
      petNAME: (json['petNAME']).toString() ?? 'Unknown',
      petIMG: json['petIMG'] ?? 'assets/icons/anonymus.webp',
      appointmentDateTime: json['appointmentDateTime'],
      appointmentStatus: (json['appointmentStatus']) ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentID': appointmentID,
      'petNAME': petNAME,
      'appointmentDateTime': appointmentDateTime,
      'appointmentStatus': appointmentStatus,
    };
  }

  @override
  String toString() {
    return 'Appointment(profileNAME: $appointmentID, petNAME: $petNAME, apmDATE: $appointmentDateTime, appointmentTIME: $appointmentStatus)';
  }
}
