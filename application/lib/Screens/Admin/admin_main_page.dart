import 'package:application/Screens/Admin/admin_item_management.dart';
import 'package:application/Screens/Admin/admin_purchase_management.dart';
import 'package:application/Screens/Admin/admin_storages_item_management.dart';
import 'package:flutter/material.dart';
import 'package:application/Screens/Admin/admin_dashboard.dart';
import 'package:application/Screens/Admin/admin_service_management.dart';
import 'package:application/Screens/Admin/admin_order_management.dart';
import 'package:application/Screens/Admin/admin_auth_guard.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _currentIndex = 0;
  bool _darkMode = false;

  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      AdminAuthGuard(child: AdminDashboard()),
      AdminAuthGuard(child: AdminItemsManagement()),
      AdminAuthGuard(child: AdminServiceManagement()),
      AdminAuthGuard(child: AdminOrderManagementScreen()),
      AdminAuthGuard(child: AdminPurchaseManagementScreen()),
    ];
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: _darkMode ? Colors.grey[800] : const Color(0xFF5CB15A),
      unselectedItemColor: _darkMode ? Colors.grey[400] : Colors.white70,
      selectedItemColor: _darkMode ? Colors.white : Colors.white,
      currentIndex: _currentIndex,
      onTap: onTappedBar,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Items',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Invoices',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
