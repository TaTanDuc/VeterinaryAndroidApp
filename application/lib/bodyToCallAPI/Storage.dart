class Storage {
  final int storageID;
  final String departmentNAME;

  Storage({
    required this.storageID,
    required this.departmentNAME,
  });

  factory Storage.fromJson(Map<String, dynamic> json) {
    return Storage(
      storageID: json['storageID'],
      departmentNAME: json['departmentNAME'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storageID': storageID,
      'departmentNAME': departmentNAME,
    };
  }
}
