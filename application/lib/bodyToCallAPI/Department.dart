class Department {
  final int departmentID;
  final String departmentName;
  final String address;

  Department({
    required this.departmentID,
    required this.departmentName,
    required this.address,
  });
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
        departmentID: json['departmentID'],
        departmentName: json['departmentNAME'],
        address: json['departmentADDRESS']);
  }

  // Convert AppointmentDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'departmentID': departmentID,
      'departmentName': departmentName,
      'address': address
    };
  }
}
