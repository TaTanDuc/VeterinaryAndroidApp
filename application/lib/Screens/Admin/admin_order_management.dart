import 'dart:convert';

import 'package:application/Screens/Admin/admin_order_detail_screen.dart';
import 'package:application/bodyToCallAPI/AdminOrderList.dart' as list_model;
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminOrderManagementScreen extends StatefulWidget {
  const AdminOrderManagementScreen({super.key});

  @override
  State<AdminOrderManagementScreen> createState() =>
      _AdminOrderManagementScreenState();
}

class _AdminOrderManagementScreenState
    extends State<AdminOrderManagementScreen> {
  bool _darkMode = false;
  bool _loading = true;
  String _searchQuery = '';
  String? _errorMessage;
  List<list_model.OrderSummary> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/admin/order'),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final parsed = list_model.AdminOrderList.fromJson(data);

        setState(() {
          _orders = parsed.returned;
          if (_orders.isEmpty) {
            _errorMessage = 'No orders found.';
          }
        });
      } else {
        _useMockData(
          errorMessage: 'Can not fetch data (error ${response.statusCode}).',
        );
      }
    } catch (e) {
      _useMockData(errorMessage: 'Something went wrong: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _useMockData({String? errorMessage}) {
    setState(() {
      _orders = [
        list_model.OrderSummary(
          orderId: 15,
          username: 'Dang fgfgg',
          status: 'PROCESSING',
          orderedDATE: '2024-11-12',
          totalQuantity: 62,
          departmentCount: 2,
        ),
      ];
      _errorMessage = errorMessage;
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  List<list_model.OrderSummary> get _filteredOrders {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) {
      return _orders;
    }

    return _orders.where((order) {
      final orderIdMatch = order.orderId.toString().contains(query);
      final customerMatch =
          (order.username ?? '').toLowerCase().contains(query);
      final statusMatch = (order.status ?? '').toLowerCase().contains(query);
      return orderIdMatch || customerMatch || statusMatch;
    }).toList();
  }

  int get _totalOrders => _orders.length;
  int get _totalItems =>
      _orders.fold(0, (sum, order) => sum + (order.totalQuantity ?? 0));
  int get _totalDepartments =>
      _orders.fold(0, (sum, order) => sum + (order.departmentCount ?? 0));

  @override
  Widget build(BuildContext context) {
    final themeBackground = _darkMode ? Colors.grey[900] : Colors.grey[100];
    final cardBackground = _darkMode ? Colors.grey[800] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Order Management',
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
            color: Colors.white,
            onPressed: () => _toggleDarkMode(!_darkMode),
          ),
        ],
      ),
      body: Container(
        color: themeBackground,
        child: Column(
          children: [
            _buildSearchSection(cardBackground),
            _buildSummarySection(cardBackground),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildOrdersList(cardBackground),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5CB15A),
        onPressed: _loadOrders,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchSection(Color? cardBackground) {
    return Container(
      color: cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order List',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Find order by ID, status...',
              prefixIcon: const Icon(Icons.search),
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
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontFamily: 'Fredoka',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummarySection(Color? cardBackground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total orders',
              value: _totalOrders.toString(),
              icon: Icons.shopping_bag,
              color: Colors.blue,
              backgroundColor: cardBackground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Total items',
              value: _totalItems.toString(),
              icon: Icons.inventory_2,
              color: Colors.orange,
              backgroundColor: cardBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _darkMode ? Colors.white : Colors.black,
              fontFamily: 'Fredoka',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: _darkMode ? Colors.grey[300] : Colors.grey[600],
              fontFamily: 'Fredoka',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(Color? cardBackground) {
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return Center(
        child: Text(
          _orders.isEmpty
              ? 'No orders to show.'
              : 'Cound not find any suitable orders.',
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Fredoka',
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF5CB15A),
                child: Text(
                  order.orderId.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                'OrderID #${order.orderId}',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                  color: _darkMode ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.username != null) ...[
                    const SizedBox(height: 4),
                    _buildSubtitleRow(
                      icon: Icons.person,
                      label: 'Account',
                      value: order.username!,
                    ),
                  ],
                  if (order.orderedDATE != null) ...[
                    const SizedBox(height: 4),
                    _buildSubtitleRow(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: DateFormat('yyyy-MM-dd HH:mm')
                          .format(DateTime.parse(order.orderedDATE!)),
                    ),
                  ],
                ],
              ),
              trailing: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 6,
                children: [
                  if (order.status != null)
                    Chip(
                      label: Text(
                        _formatStatus(order.status!),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: _getStatusColor(order.status),
                    ),
                  // const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AdminOrderDetailScreen(
                      orderId: order.orderId,
                      initialDarkMode: _darkMode,
                    ),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }

  Widget _buildSubtitleRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w600,
            color: _darkMode ? Colors.grey[200] : Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Fredoka',
              color: _darkMode ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  String _formatStatus(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return 'Completed';
      case 'PROCESSING':
        return 'Processing';
      case 'PENDING':
        return 'Pending';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _getStatusColor(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'COMPLETED':
        return Colors.green;
      case 'PROCESSING':
        return Colors.orange;
      case 'PENDING':
        return Colors.blueGrey;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
