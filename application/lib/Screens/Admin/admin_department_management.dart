import 'package:application/bodyToCallAPI/Department.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:application/bodyToCallAPI/SessionManager.dart';

class AdminDepartmentManagement extends StatefulWidget {
  const AdminDepartmentManagement({super.key});

  @override
  State<AdminDepartmentManagement> createState() =>
      _AdminDepartmentManagementState();
}

class _AdminDepartmentManagementState extends State<AdminDepartmentManagement> {
  bool _loading = true;
  List<Department> _departments = [];
  String _searchQuery = '';
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadAllDepartments();
  }

  Future<void> _loadAllDepartments() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/customer/department');

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
          _departments = returnedData
              .map((json) => Department.fromJson(json as Map<String, dynamic>))
              .toList();
          _loading = false;
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
          _loading = false;
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
        _loading = false;
      });
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  List<Department> get _filteredDepartments {
    if (_searchQuery.isEmpty) {
      return _departments;
    }
    return _departments
        .where((dept) =>
            dept.departmentName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            dept.address.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Manage Departments',
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
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredDepartments.isEmpty
                      ? Center(child: Text('No departments found.'))
                      : _buildDepartmentList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDepartmentDialog,
        backgroundColor: Color(0xFF5CB15A),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDepartmentList() {
    return ListView.builder(
      itemCount: _filteredDepartments.length,
      itemBuilder: (context, index) {
        final department = _filteredDepartments[index];
        return _buildDepartmentCard(department);
      },
    );
  }

  Widget _buildDepartmentCard(Department department) {
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
                  child: Text(
                    department.departmentName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _darkMode ? Colors.white : Colors.black,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    department.address,
                    style: TextStyle(
                      color: _darkMode ? Colors.grey[300] : Colors.grey[600],
                      fontFamily: 'Fredoka',
                    ),
                  ),
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
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDepartmentDialog(department);
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

  void _showAddDepartmentDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Department'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
              if (nameController.text.isEmpty ||
                  addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              try {
                final session = await SessionManager().getSession();
                final response = await http.post(
                  Uri.parse('http://10.0.2.2:8080/api/admin/department/add'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Cookie': '$session'
                  },
                  body: jsonEncode({
                    'departmentName': nameController.text,
                    'address': addressController.text,
                  }),
                );

                Navigator.of(context).pop();
                if (response.statusCode == 200 || response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Department and storage location created successfully'),
                    ),
                  );
                  await _loadAllDepartments();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add department')),
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
    );
  }

  void _showEditDepartmentDialog(Department department) {
    final nameController =
        TextEditingController(text: department.departmentName);
    final addressController = TextEditingController(text: department.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Department'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
              if (nameController.text.isEmpty ||
                  addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              try {
                final session = await SessionManager().getSession();
                final response = await http.patch(
                  Uri.parse('http://10.0.2.2:8080/api/admin/department/update'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Cookie': '$session'
                  },
                  body: jsonEncode({
                    'departmentID': department.departmentID,
                    'departmentName': nameController.text,
                    'address': addressController.text,
                  }),
                );

                Navigator.of(context).pop();
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Department updated successfully')),
                  );
                  _loadAllDepartments();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update department')),
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
    );
  }
}
