import 'package:application/Screens/Admin/admin_storages_item_management.dart';
import 'package:application/bodyToCallAPI/StorageLocation.dart';
import 'package:application/bodyToCallAPI/Department.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:application/bodyToCallAPI/SessionManager.dart';

class AdminStorageManagement extends StatefulWidget {
  const AdminStorageManagement({super.key});

  @override
  State<AdminStorageManagement> createState() => _AdminStorageManagementState();
}

class _AdminStorageManagementState extends State<AdminStorageManagement> {
  bool _loading = true;
  List<StorageLocation> _storages = [];
  List<Department> _departments = [];
  int? _selectedDepartmentFilter;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadAllStorages();
    _loadAllDepartments();
  }

  Future<void> _loadAllDepartments() async {
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/admin/department'),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> returnedData = data['returned'] ?? [];

        setState(() {
          _departments = returnedData
              .map((json) => Department.fromJson(json as Map<String, dynamic>))
              .toList();
        });
      } else {
        // Mock data for development
        setState(() {
          _departments = [
            Department(
              departmentID: 1,
              departmentName: 'Khoa Phẫu thuật',
              address: '123 Đường ABC, Quận 1',
            ),
            Department(
              departmentID: 2,
              departmentName: 'Khoa Nội khoa',
              address: '456 Đường XYZ, Quận 2',
            ),
          ];
        });
      }
    } catch (e) {
      print('Error loading departments: $e');
      // Mock data for development
      setState(() {
        _departments = [
          Department(
            departmentID: 1,
            departmentName: 'Khoa Phẫu thuật',
            address: '123 Đường ABC, Quận 1',
          ),
          Department(
            departmentID: 2,
            departmentName: 'Khoa Nội khoa',
            address: '456 Đường XYZ, Quận 2',
          ),
        ];
      });
    }
  }

  Future<void> _loadAllStorages() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/admin/storage');

    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> returnedData = data['returned'] ?? [];

        setState(() {
          _storages = returnedData
              .map((json) =>
                  StorageLocation.fromJson(json as Map<String, dynamic>))
              .toList();
          _loading = false;
        });
      } else {
        // Mock data for development
        setState(() {
          _storages = [
            StorageLocation(storageid: 1, departmentid: 1),
            StorageLocation(storageid: 2, departmentid: 1),
            StorageLocation(storageid: 3, departmentid: 2),
          ];
          _loading = false;
        });
      }
    } catch (e) {
      print('Error loading storages: $e');
      // Mock data for development
      setState(() {
        _storages = [
          StorageLocation(storageid: 1, departmentid: 1),
          StorageLocation(storageid: 2, departmentid: 1),
          StorageLocation(storageid: 3, departmentid: 2),
        ];
        _loading = false;
      });
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  List<StorageLocation> get _filteredStorages {
    var filtered = _storages;

    if (_selectedDepartmentFilter != null) {
      filtered = filtered
          .where((storage) => storage.departmentid == _selectedDepartmentFilter)
          .toList();
    }

    return filtered;
  }

  String _getdepartmentName(int departmentid) {
    final dept = _departments.firstWhere(
      (d) => d.departmentID == departmentid,
      orElse: () => Department(
        departmentID: departmentid,
        departmentName: 'Unknown',
        address: '',
      ),
    );
    return dept.departmentName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Manage Storage Locations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => _toggleDarkMode(!_darkMode),
          ),
        ],
      ),
      body: Container(
        color: _darkMode ? Colors.grey[900] : Colors.grey[100],
        child: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredStorages.isEmpty
                      ? Center(child: Text('No storage locations found.'))
                      : _buildStorageList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStorageDialog,
        backgroundColor: Color(0xFF5CB15A),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(16),
      color: _darkMode ? Colors.grey[800] : Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: _selectedDepartmentFilter,
                  hint: Text('Filter by Department'),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text('All Departments'),
                    ),
                    ..._departments.map((dept) => DropdownMenuItem<int>(
                          value: dept.departmentID,
                          child: Text(dept.departmentName),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartmentFilter = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: _loadAllStorages,
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredStorages.length,
      itemBuilder: (context, index) {
        final storage = _filteredStorages[index];
        return _buildStorageCard(storage);
      },
    );
  }

  Widget _buildStorageCard(StorageLocation storage) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: _darkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage ID: ${storage.storageid}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _darkMode ? Colors.white : Colors.black,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.business, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            _getdepartmentName(storage.departmentid),
                            style: TextStyle(
                              color: _darkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                              fontFamily: 'Fredoka',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    'Dept ID: ${storage.departmentid}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    // PopupMenuItem(
                    //   value: 'elete',
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.delete, size: 20, color: Colors.red),
                    //       SizedBox(width: 8),
                    //       Text('Delete', style: TextStyle(color: Colors.red)),
                    //     ],
                    //   ),
                    // ),
                    PopupMenuItem(
                      value: 'details',
                      child: Row(
                        children: [
                          Icon(Icons.details_sharp,
                              size: 20,
                              color: const Color.fromARGB(255, 148, 147, 147)),
                          SizedBox(width: 8),
                          Text('Detail',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 10, 10, 10))),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditStorageDialog(storage);
                    } else if (value == 'delete') {
                      _showDeleteStorageDialog(storage);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminItemManagement(
                            storageID: storage.storageid,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStorageDialog() {
    int? selectedDepartmentId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add New Storage Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedDepartmentId,
                hint: Text('Select Department'),
                isExpanded: true,
                items: _departments.map((dept) {
                  return DropdownMenuItem<int>(
                    value: dept.departmentID,
                    child: Text(
                        '${dept.departmentName} (ID: ${dept.departmentID})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedDepartmentId = value;
                  });
                },
              ),
              SizedBox(height: 12),
              Text(
                'Note: Storage ID will be automatically generated',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedDepartmentId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a department')),
                  );
                  return;
                }

                try {
                  final session = await SessionManager().getSession();
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:8080/api/admin/storages'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Cookie': '$session'
                    },
                    body: jsonEncode({
                      'departmentid': selectedDepartmentId,
                    }),
                  );

                  Navigator.of(context).pop();
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Storage location added successfully')),
                    );
                    _loadAllStorages();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add storage location')),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditStorageDialog(StorageLocation storage) {
    int? selectedDepartmentId = storage.departmentid;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Storage Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Storage ID: ${storage.storageid}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              DropdownButton<int>(
                value: selectedDepartmentId,
                hint: Text('Select Department'),
                isExpanded: true,
                items: _departments.map((dept) {
                  return DropdownMenuItem<int>(
                    value: dept.departmentID,
                    child: Text(
                        '${dept.departmentName} (ID: ${dept.departmentID})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedDepartmentId = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedDepartmentId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a department')),
                  );
                  return;
                }

                try {
                  final session = await SessionManager().getSession();
                  final response = await http.put(
                    Uri.parse(
                        'http://10.0.2.2:8080/api/admin/storages/${storage.storageid}'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Cookie': '$session'
                    },
                    body: jsonEncode({
                      'storageid': storage.storageid,
                      'departmentid': selectedDepartmentId,
                    }),
                  );

                  Navigator.of(context).pop();
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Storage location updated successfully')),
                    );
                    _loadAllStorages();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to update storage location')),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteStorageDialog(StorageLocation storage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete storage location ID: ${storage.storageid}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final session = await SessionManager().getSession();
                final response = await http.delete(
                  Uri.parse(
                      'http://10.0.2.2:8080/api/admin/storages/${storage.storageid}'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Cookie': '$session'
                  },
                );

                Navigator.of(context).pop();
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Storage location deleted successfully')),
                  );
                  _loadAllStorages();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to delete storage location')),
                  );
                }
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
