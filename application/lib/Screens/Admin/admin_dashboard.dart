import 'package:application/Screens/Admin/admin_purchase_management.dart';
import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:application/Screens/Admin/admin_service_management.dart';
import 'package:application/Screens/Admin/admin_department_management.dart';
import 'package:application/Screens/Admin/admin_storage_management.dart';
import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _loading = true;
  Map<String, dynamic> _stats = {};
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load statistics from backend
      final session = await SessionManager().getSession();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/admin/dashboard/stats'),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _stats = jsonDecode(response.body);
          _loading = false;
        });
      } else {
        // Mock data for development
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
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

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await SessionManager().clearSession();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _switchToClient() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Back to Client'),
          content:
              Text('Are you sure you want to switch back to the client view?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Clear admin session but keep user session
                await SessionManager().clearAdminSession();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Switch'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5CB15A),
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.switch_account),
              onPressed: _switchToClient,
              tooltip: 'Back to Client',
            ),
            IconButton(
              icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => _toggleDarkMode(!_darkMode),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: _darkMode ? Colors.grey[900] : Colors.grey[100],
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeCard(),
                      SizedBox(height: 20),
                      _buildQuickActions(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5CB15A), Color(0xFF4A9A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Admin!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your veterinary services efficiently.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'Fredoka',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _darkMode ? Colors.white : Colors.black,
            fontFamily: 'Fredoka',
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildActionCard(
              'Services',
              Icons.medical_services,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminServiceManagement()),
              ),
            ),
            _buildActionCard(
              'Invoice',
              Icons.receipt,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminPurchaseManagementScreen()),
              ),
            ),
            _buildActionCard(
              'Department',
              Icons.business,
              Colors.indigo,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminDepartmentManagement()),
              ),
            ),
            _buildActionCard(
              'Storage Management',
              Icons.warehouse,
              Colors.brown,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminStorageManagement()),
              ),
            ),
            // _buildActionCard(
            //   'Item Management',
            //   Icons.shopping_bag,
            //   Colors.cyan,
            //   () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => AdminItemManagement()),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _darkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _darkMode ? Colors.white : Colors.black,
                  fontFamily: 'Fredoka',
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
