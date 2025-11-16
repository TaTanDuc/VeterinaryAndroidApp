import 'package:application/bodyToCallAPI/Service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:application/bodyToCallAPI/SessionManager.dart';

class AdminServiceManagement extends StatefulWidget {
  const AdminServiceManagement({super.key});

  @override
  State<AdminServiceManagement> createState() => _AdminServiceManagementState();
}

class _AdminServiceManagementState extends State<AdminServiceManagement> {
  bool _loading = true;
  List<Service> _services = [];
  String _selectedCategory = 'All';
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadAllServices();
  }

  Future<void> _loadAllServices() async {
    final url = Uri.parse(
      'http://10.0.2.2:8080/api/customer/service?serviceCode=&searchString=',
    );

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
          _services = returnedData
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();
          _loading = false;
        });
      } else {
        throw Exception('Failed to load all services');
      }
    } catch (e) {
      print('Error loading all services: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadServiceByCode(String serviceCode) async {
    final url = Uri.parse(
      'http://10.0.2.2:8080/api/customer/service/getServiceDetails?serviceCODE=$serviceCode',
    );

    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final returnedData = data['returned'];

        List<Service> parsedServices = [];

        if (returnedData is List) {
          parsedServices = returnedData
              .map((json) => Service.fromJson(json as Map<String, dynamic>))
              .toList();
        } else if (returnedData is Map<String, dynamic>) {
          parsedServices = [Service.fromJson(returnedData)];
        }

        setState(() {
          _services = parsedServices;
          _loading = false;
        });
      } else {
        throw Exception('Failed to load service by code');
      }
    } catch (e) {
      print('Error loading service by code: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Manage Services',
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
                  : _services.isEmpty
                      ? Center(child: Text('No services found.'))
                      : _buildServiceList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddServiceDialog,
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
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  items: [
                    const DropdownMenuItem(
                      value: 'All',
                      child: Text('All'),
                    ),
                    ..._services.map((service) => DropdownMenuItem(
                          value: service.serviceCode,
                          child: Text(_getCategoryText(service.serviceCode)),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });

                    if (value == 'All') {
                      _loadAllServices();
                    } else {
                      _loadServiceByCode(value!);
                    }
                  },
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: _loadAllServices,
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryText(String serviceCode) {
    switch (serviceCode) {
      case 'EXAMINATION':
        return 'Examination';
      case 'VACCINATION':
        return 'Vaccination';
      case 'SURGERY':
        return 'Surgery';
      case 'GROOMING':
        return 'Grooming';
      case 'EMERGENCY':
        return 'Emergency';
      default:
        return serviceCode; // fallback to raw code if not matched
    }
  }

  Widget _buildServiceList() {
    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(Service service) {
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
                    service.serviceName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _darkMode ? Colors.white : Colors.black,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        _getCategoryText(service.serviceCode),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: _getCategoryColor(service.serviceCode),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              service.description,
              style: TextStyle(
                color: _darkMode ? Colors.grey[300] : Colors.grey[600],
                fontFamily: 'Fredoka',
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  '${service.servicePrice}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontFamily: 'Fredoka',
                  ),
                ),
                SizedBox(width: 16),
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
                      _showEditServiceDialog(service);
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'EXAMINATION':
        return Colors.blue;
      case 'VACCINATION':
        return Colors.green;
      case 'SURGERY':
        return Colors.red;
      case 'GROOMING':
        return Colors.purple;
      case 'EMERGENCY':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final codeController = TextEditingController();
    final dateController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add New Service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Service Code',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., EXAMINATION, VACCINATION',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Working Date',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Monday - Friday',
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    codeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all required fields')),
                  );
                  return;
                }

                try {
                  final session = await SessionManager().getSession();
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:8080/api/admin/service/add'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Cookie': '$session'
                    },
                    body: jsonEncode({
                      'serviceCode': codeController.text,
                      'serviceName': nameController.text,
                      'workingDate': dateController.text,
                      'servicePrice': int.tryParse(priceController.text) ?? 0,
                      'description': descriptionController.text,
                    }),
                  );

                  Navigator.of(context).pop();
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Service added successfully')),
                    );
                    _loadAllServices();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add service')),
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

  void _showEditServiceDialog(Service service) {
    final codeController = TextEditingController(text: service.serviceCode);
    final nameController = TextEditingController(text: service.serviceName);
    final descriptionController =
        TextEditingController(text: service.description);
    final priceController =
        TextEditingController(text: service.servicePrice.toString());
    final dateController = TextEditingController(text: service.workingDate);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Service Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Working Date',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Monday - Friday',
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (codeController.text.isEmpty ||
                    nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all required fields')),
                  );
                  return;
                }

                try {
                  final session = await SessionManager().getSession();
                  final response = await http.patch(
                    Uri.parse('http://10.0.2.2:8080/api/admin/service/update'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Cookie': '$session'
                    },
                    body: jsonEncode({
                      'serviceCode': codeController.text,
                      'serviceName': nameController.text,
                      'workingDate': dateController.text,
                      'servicePrice': int.tryParse(priceController.text) ?? 0,
                      'description': descriptionController.text,
                    }),
                  );

                  Navigator.of(context).pop();
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Service updated successfully')),
                    );
                    _loadAllServices();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update service')),
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
}
