import 'dart:convert';

import 'package:application/Screens/Admin/admin_order_detail_screen.dart';
import 'package:application/Screens/Admin/admin_purchase_detail_screen.dart';
import 'package:application/bodyToCallAPI/AdminOrderList.dart' as list_model;
import 'package:application/bodyToCallAPI/Purchase.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminPurchaseManagementScreen extends StatefulWidget {
  const AdminPurchaseManagementScreen({super.key});

  @override
  State<AdminPurchaseManagementScreen> createState() =>
      _AdminPurchaseManagementScreenState();
}

class _AdminPurchaseManagementScreenState
    extends State<AdminPurchaseManagementScreen> {
  bool _darkMode = false;
  bool _loading = true;
  String _searchQuery = '';
  String? _errorMessage;
  List<Purchase> _purchases = [];

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
        Uri.parse('http://10.0.2.2:8080/api/admin/invoices/purchase'),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> returnedData = data['returned'] ?? [];

        setState(() {
          _purchases = returnedData
              .map((json) => Purchase.fromJson(json as Map<String, dynamic>))
              .toList();
          _loading = false;
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
      _purchases = [
        Purchase(
          purchaseInvoiceID: 15,
          userName: 'Dang fgfgg',
          createdDate: '2024-11-12',
          paymentMethod: 'VISA',
          total: 2,
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

  List<Purchase> get _filteredOrders {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) {
      return _purchases;
    }

    return _purchases.where((order) {
      final orderIdMatch = order.purchaseInvoiceID.toString().contains(query);
      final customerMatch =
          (order.userName ?? '').toLowerCase().contains(query);
      return orderIdMatch || customerMatch;
    }).toList();
  }

  int get _totalOrders => _purchases.length;

  @override
  Widget build(BuildContext context) {
    final themeBackground = _darkMode ? Colors.grey[900] : Colors.grey[100];
    final cardBackground = _darkMode ? Colors.grey[800] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Purchase Management',
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
            'Purchase List',
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
          _purchases.isEmpty
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
                  order.purchaseInvoiceID.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                'PurchaseID #${order.purchaseInvoiceID}',
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                  color: _darkMode ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.userName != null) ...[
                    const SizedBox(height: 4),
                    _buildSubtitleRow(
                      icon: Icons.person,
                      label: 'User',
                      value: order.userName!,
                    ),
                  ],
                  if (order.createdDate != null) ...[
                    const SizedBox(height: 4),
                    _buildSubtitleRow(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: DateFormat('yyyy-MM-dd HH:mm')
                          .format(DateTime.parse(order.createdDate!)),
                    ),
                  ],
                  if (order.paymentMethod != null) ...[
                    const SizedBox(height: 4),
                    _buildSubtitleRow(
                      icon: Icons.payment,
                      label: 'Payment',
                      value: order.paymentMethod!,
                    ),
                  ],
                ],
              ),
              trailing: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 6,
                children: [
                  if (order.total != null)
                    Chip(
                      label: Text(
                        order.total.toString() + ' USD',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 10, 10, 10),
                            fontSize: 12),
                      ),
                    ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AdminPurchaseDetailScreen(
                      orderId: order.purchaseInvoiceID,
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
}
