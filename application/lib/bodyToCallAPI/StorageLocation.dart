class StorageLocation {
  final int storageid;
  final int departmentid;

  StorageLocation({
    required this.storageid,
    required this.departmentid,
  });

  factory StorageLocation.fromJson(Map<String, dynamic> json) {
    return StorageLocation(
      storageid: json['storageid'],
      departmentid: json['departmentid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storageid': storageid,
      'departmentid': departmentid,
    };
  }
}

