class Department {
  final int departmentID;
  final String departmentNAME;
  final String departmentADDRESS;

  Department({
    required this.departmentID,
    required this.departmentNAME,
    required this.departmentADDRESS,
  });
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
        departmentID: json['departmentID'],
        departmentNAME: json['departmentNAME'],
        departmentADDRESS: json['departmentADDRESS']);
  }

  // Convert AppointmentDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'departmentID': departmentID,
      'departmentNAME': departmentNAME,
      'departmentADDRESS': departmentADDRESS
    };
  }
}
