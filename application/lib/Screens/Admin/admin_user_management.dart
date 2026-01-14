import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:application/bodyToCallAPI/SessionManager.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({super.key});

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  bool _loading = true;
  List<Map<String, dynamic>> _users = [];
  String _searchQuery = '';
  String _selectedRole = 'All';
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/admin/users'),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data);
          _loading = false;
        });
      } else {
        // Mock data for development
        setState(() {
          _users = [
            {
              'profileID': 1,
              'profileNAME': 'Nguyễn Văn A',
              'profileEMAIL': 'nguyenvana@email.com',
              'PHONE': '0123456789',
              'role': {'roleNAME': 'CUSTOMER'},
              'createdDate': '2024-01-15',
            },
            {
              'profileID': 2,
              'profileNAME': 'Trần Thị B',
              'profileEMAIL': 'tranthib@email.com',
              'PHONE': '0987654321',
              'role': {'roleNAME': 'CUSTOMER'},
              'createdDate': '2024-01-20',
            },
            {
              'profileID': 3,
              'profileNAME': 'Admin User',
              'profileEMAIL': 'admin@vet.com',
              'PHONE': '0111222333',
              'role': {'roleNAME': 'ADMIN'},
              'createdDate': '2024-01-01',
            },
          ];
          _loading = false;
        });
      }
    } catch (e) {
      // Mock data for development
      setState(() {
        _users = [
          {
            'profileID': 1,
            'profileNAME': 'Nguyễn Văn A',
            'profileEMAIL': 'nguyenvana@email.com',
            'PHONE': '0123456789',
            'role': {'roleNAME': 'CUSTOMER'},
            'createdDate': '2024-01-15',
          },
          {
            'profileID': 2,
            'profileNAME': 'Trần Thị B',
            'profileEMAIL': 'tranthib@email.com',
            'PHONE': '0987654321',
            'role': {'roleNAME': 'CUSTOMER'},
            'createdDate': '2024-01-20',
          },
          {
            'profileID': 3,
            'profileNAME': 'Admin User',
            'profileEMAIL': 'admin@vet.com',
            'PHONE': '0111222333',
            'role': {'roleNAME': 'ADMIN'},
            'createdDate': '2024-01-01',
          },
        ];
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch = user['profileNAME']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['profileEMAIL']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesRole =
          _selectedRole == 'All' || user['role']['roleNAME'] == _selectedRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  Future<void> _deleteUser(int userId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa user này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final session = await SessionManager().getSession();
                final response = await http.delete(
                  Uri.parse('http://10.0.2.2:8080/api/admin/users/$userId'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Cookie': '$session'
                  },
                );

                if (response.statusCode == 200) {
                  _loadUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa user thành công')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi xóa user')),
                );
              }
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Quản lý Users',
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
                  : _buildUsersList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
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
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm user...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: _darkMode ? Colors.grey[700] : Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Lọc theo role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: _darkMode ? Colors.grey[700] : Colors.grey[100],
                  ),
                  items: ['All', 'CUSTOMER', 'ADMIN', 'EMPLOYEE', 'MANAGER']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: _loadUsers,
                icon: Icon(Icons.refresh),
                tooltip: 'Làm mới',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    final filteredUsers = _filteredUsers;

    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy user nào',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Fredoka',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: _darkMode ? Colors.grey[800] : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF5CB15A),
          child: Text(
            user['profileNAME'][0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user['profileNAME'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _darkMode ? Colors.white : Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['profileEMAIL'],
              style: TextStyle(
                color: _darkMode ? Colors.grey[300] : Colors.grey[600],
                fontFamily: 'Fredoka',
              ),
            ),
            Text(
              user['PHONE'],
              style: TextStyle(
                color: _darkMode ? Colors.grey[300] : Colors.grey[600],
                fontFamily: 'Fredoka',
              ),
            ),
            Chip(
              label: Text(
                user['role']['roleNAME'],
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              backgroundColor: _getRoleColor(user['role']['roleNAME']),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Chỉnh sửa'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditUserDialog(user);
            } else if (value == 'delete') {
              _deleteUser(user['profileID']);
            }
          },
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.red;
      case 'MANAGER':
        return Colors.orange;
      case 'EMPLOYEE':
        return Colors.blue;
      case 'CUSTOMER':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm User mới'),
        content: Text('Tính năng này đang được phát triển'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chỉnh sửa User'),
        content: Text('Tính năng này đang được phát triển'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
