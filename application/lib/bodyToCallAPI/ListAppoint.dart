class ListAppoint {
  final String profileNAME;
  final String petNAME;
  final String apmDATE;
  final String appointmentTIME;

  ListAppoint({
    required this.profileNAME,
    required this.petNAME,
    required this.apmDATE,
    required this.appointmentTIME,
  });

  factory ListAppoint.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("JSON data cannot be null");
    }

    return ListAppoint(
      profileNAME: (json['profileNAME']).toString() ??
          'Unknown', // Provide default values if necessary
      petNAME: (json['petNAME']).toString() ?? 'Unknown',
      apmDATE: (json['apmDATE']).toString() ?? '0000-00-00',
      appointmentTIME: (json['appointmentTIME']) ?? '00:00:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileNAME': profileNAME ?? 'Unknown',
      'petNAME': petNAME,
      'apmDATE': apmDATE,
      'appointmentTIME': appointmentTIME,
    };
  }

  @override
  String toString() {
    return 'Appointment(profileNAME: $profileNAME, petNAME: $petNAME, apmDATE: $apmDATE, appointmentTIME: $appointmentTIME)';
  }
}
