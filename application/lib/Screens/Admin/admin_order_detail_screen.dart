import 'dart:convert';

import 'package:application/bodyToCallAPI/AdminOrderManagement.dart' as detail;
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminOrderDetailScreen extends StatefulWidget {
  final int orderId;
  final bool initialDarkMode;

  const AdminOrderDetailScreen({
    super.key,
    required this.orderId,
    this.initialDarkMode = false,
  });

  @override
  State<AdminOrderDetailScreen> createState() => _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState extends State<AdminOrderDetailScreen> {
  bool _darkMode = false;
  bool _loading = true;
  String? _errorMessage;
  detail.AdminOrderManagement? _response;
  List<detail.OrderDetail> _orderDetails = [];

  @override
  void initState() {
    super.initState();
    _darkMode = widget.initialDarkMode;
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final session = await SessionManager().getSession();
      final uri = Uri.parse(
          'http://10.0.2.2:8080/api/admin/order/details?orderID=${widget.orderId}');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '$session',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final parsed = detail.AdminOrderManagement.fromJson(data);

        setState(() {
          _response = parsed;
          _orderDetails = parsed.returned;
          if (_orderDetails.isEmpty) {
            _errorMessage = 'There is no items in this order.';
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Cannot fetch data (error ${response.statusCode}).';
          _response = null;
          _orderDetails = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong: ${e.toString()}';
        _response = null;
        _orderDetails = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  int get _totalQuantity => _orderDetails.fold(
      0, (previousValue, element) => previousValue + element.itemQuantity);

  @override
  Widget build(BuildContext context) {
    final themeBackground = _darkMode ? Colors.grey[900] : Colors.grey[100];
    final cardBackground = _darkMode ? Colors.grey[800] : Colors.white;
    final primaryTextColor = _darkMode ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: Text(
          'Order #${widget.orderId}',
          style: const TextStyle(
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
            if (_response != null) _buildSummarySection(cardBackground),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(primaryTextColor, cardBackground),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5CB15A),
        onPressed: _fetchOrderDetails,
        child: const Icon(Icons.refresh, color: Colors.white),
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
              value: _orderDetails.length.toString(),
              icon: Icons.inventory_2,
              color: Colors.blue,
              backgroundColor: cardBackground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Total items',
              value: _totalQuantity.toString(),
              icon: Icons.format_list_numbered,
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

  Widget _buildContent(Color primaryTextColor, Color? cardBackground) {
    if (_response == null && _errorMessage == null) {
      return const Center(
        child: Text(
          'Not found any data.',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Fredoka',
          ),
        ),
      );
    }

    if (_orderDetails.isEmpty) {
      return Center(
        child: Text(
          _errorMessage ?? 'Not found.',
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Fredoka',
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchOrderDetails,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _orderDetails.length,
        itemBuilder: (context, index) {
          final detail = _orderDetails[index];
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
                  detail.itemQuantity.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Fredoka',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                detail.itemName,
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  _buildSubtitleRow(
                    icon: Icons.apartment,
                    label: 'Department',
                    value: detail.departmentName,
                  ),
                  const SizedBox(height: 2),
                  _buildSubtitleRow(
                    icon: Icons.store,
                    label: 'Storage ID',
                    value: 'ID: ${detail.storageId}',
                  ),
                  const SizedBox(height: 2),
                  _buildSubtitleRow(
                    icon: Icons.tag,
                    label: 'Item ID',
                    value: detail.itemId.toString(),
                  ),
                ],
              ),
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
