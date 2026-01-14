import 'package:application/bodyToCallAPI/Item.dart';
import 'package:application/bodyToCallAPI/ItemInStock.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class AdminItemManagement extends StatefulWidget {
  final int storageID;
  const AdminItemManagement({
    Key? key,
    required this.storageID,
  }) : super(key: key);

  @override
  State<AdminItemManagement> createState() => _AdminItemManagementState();
}

class _AdminItemManagementState extends State<AdminItemManagement> {
  bool _loading = true;
  List<ItemInStock> _items = [];
  List<Item> _storages = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _darkMode = false;

  // Image picker variables
  String? _testImagePath;

  final List<String> _categories = [
    'All',
    'MEDICINE',
    'TOY',
    'FURNITURE',
    'ACCESSORY',
    'FOOD',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllItems();
    _loadAllStorages();
  }

  Future<void> _loadAllStorages() async {
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/admin/item?categoryCode=&searchString='),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> returnedData = data['returned'] ?? [];

        setState(() {
          _storages = returnedData
              .map((json) => Item.fromJson(json as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading all items: $e');
    }
  }

  Future<void> _loadAllItems() async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/api/admin/storage/details?storageID=${widget.storageID}');

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
          _items = returnedData
              .map((json) => ItemInStock.fromJson(json as Map<String, dynamic>))
              .toList();
          _loading = false;
        });
      } else {
        // Mock data for development
        setState(() {
          _items = [
            ItemInStock(
              itemID: 1,
              itemName: 'Dog Food Premium',
              categoryName: 'FOOD',
              quantity: 50,
              price: 100000,
            ),
          ];
          _loading = false;
        });
      }
    } catch (e) {
      print('Error loading items: $e');
      setState(() {
        _items = [
          ItemInStock(
            itemID: 1,
            itemName: 'Dog Food Premium',
            categoryName: 'FOOD',
            quantity: 50,
            price: 100000,
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

  List<ItemInStock> get _filteredItems {
    var filtered = _items;

    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item.categoryName == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.itemName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  String _getCategoryText(String category) {
    switch (category) {
      case 'MEDICINE':
        return 'Medicine';
      case 'TOY':
        return 'Toy';
      case 'FURNITURE':
        return 'Furniture';
      case 'ACCESSORY':
        return 'Accessory';
      case 'FOOD':
        return 'Food';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'MEDICINE':
        return Colors.red;
      case 'TOY':
        return Colors.purple;
      case 'FURNITURE':
        return Colors.brown;
      case 'ACCESSORY':
        return Colors.blue;
      case 'FOOD':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5CB15A),
        title: const Text(
          'Manage Items',
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
                  : _filteredItems.isEmpty
                      ? Center(child: Text('No items found.'))
                      : _buildItemList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category == 'All'
                          ? 'All Categories'
                          : _getCategoryText(category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: _loadAllItems,
                icon: Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(ItemInStock item) {
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
                    item.itemName,
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
                        _getCategoryText(item.categoryName),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: _getCategoryColor(item.categoryName),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  '${item.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontFamily: 'Fredoka',
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.inventory, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  'Stock: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Fredoka',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showAddQuantityDialog(item),
                  icon: Icon(Icons.add_box, size: 20),
                  label: Text('Add Quantity'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    int? selectedItemId;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Existing Item to Storage'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    value: selectedItemId,
                    hint: const Text('Select Item'),
                    isExpanded: true,
                    items: _storages.map((item) {
                      return DropdownMenuItem<int>(
                        value: item.itemID,
                        child: Text('${item.itemName}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedItemId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Quantity input
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Note: This will add the selected quantity of the item into the chosen storage.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedItemId == null ||
                      quantityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Quantity must be greater than 0')),
                    );
                    return;
                  }

                  try {
                    final session = await SessionManager().getSession();
                    final dueDate = DateTime.now().toIso8601String();

                    final body = {
                      'dueDATE': dueDate,
                      'list': [
                        {
                          'storageID': widget.storageID,
                          'itemID': selectedItemId,
                          'itemQUANTITY': quantity,
                        }
                      ]
                    };

                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:8080/api/admin/order/create'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Cookie': '$session'
                      },
                      body: jsonEncode(body),
                    );

                    Navigator.of(context).pop();

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Item added successfully')),
                      );
                      _loadAllItems();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed: ${response.body}')),
                      );
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddQuantityDialog(ItemInStock item) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Item Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Item: ${item.itemName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 8),
              Text(
                'Note: Quantity will be added to all storage locations.',
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (quantityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final quantity = int.tryParse(quantityController.text) ?? 0;
                if (quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Quantity must be greater than 0')),
                  );
                  return;
                }

                try {
                  final session = await SessionManager().getSession();
                  final dueDate = DateTime.now().toIso8601String();
                  final body = {
                    'dueDATE': dueDate,
                    'list': [
                      {
                        'storageID': widget.storageID,
                        'itemID': item.itemID,
                        'itemQUANTITY': quantity,
                      }
                    ],
                  };

                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:8080/api/admin/order/create'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Cookie': '$session',
                    },
                    body: jsonEncode(body),
                  );

                  Navigator.of(context).pop();

                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Quantity added successfully')),
                    );
                    _loadAllItems();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to add quantity: ${response.body}')),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
