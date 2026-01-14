import 'package:application/bodyToCallAPI/Item.dart';
import 'package:application/bodyToCallAPI/ItemInStock.dart';
import 'package:application/bodyToCallAPI/Storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class AdminItemsManagement extends StatefulWidget {
  const AdminItemsManagement({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminItemsManagement> createState() => _AdminItemsManagementState();
}

class _AdminItemsManagementState extends State<AdminItemsManagement> {
  bool _loading = true;
  List<Item> _items = [];
  List<Storage> _storages = [];
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

  Future<File> _save(String originalPath) async {
    // Save to a writable directory
    final directory = await getApplicationDocumentsDirectory();
    final fileName = Path.basename(originalPath);
    final newPath = '${directory.path}/$fileName';
    return File(originalPath).copy(newPath);
  }

  Future<String> _getAssetsImagePath(String savedPath) async {
    final fileName = Path.basename(savedPath);
    var uri = Uri.parse('http://10.0.2.2:8080/api/image/uploadItem');
    var request = http.MultipartRequest('POST', uri);
    var multipartFile = await http.MultipartFile.fromPath(
      'file',
      _testImagePath!,
      filename: fileName,
    );
    request.files.add(multipartFile);
    var response = await request.send();

    if (response.statusCode == 200) {
      final customPath = '$fileName';
      return customPath;
    } else {
      return 'Error uploading image';
    }
  }

  void _resetImagePicker() {
    setState(() {
      _testImagePath = null;
    });
  }

  Future<void> _loadAllStorages() async {
    try {
      final session = await SessionManager().getSession();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/admin/storage'),
        headers: {'Content-Type': 'application/json', 'Cookie': '$session'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> returnedData = data['returned'] ?? [];

        setState(() {
          _storages = returnedData
              .map((json) => Storage.fromJson(json as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading all items: $e');
    }
  }

  Future<void> _loadAllItems() async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/api/admin/item?categoryCode=&searchString=');

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
              .map((json) => Item.fromJson(json as Map<String, dynamic>))
              .toList();
          _loading = false;
        });
      } else {
        // Mock data for development
        setState(() {
          _items = [
            Item(
              itemID: 1,
              itemIMAGE:
                  'http://10.0.2.2:8080/api/image/getItem?name=defaultItemIMG.png',
              itemName: 'Dog Food Premium',
              categoryName: 'FOOD',
              itemRating: 4.5,
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
          Item(
            itemID: 1,
            itemIMAGE:
                'http://10.0.2.2:8080/api/image/getItem?name=defaultItemIMG.png',
            itemName: 'Dog Food Premium',
            categoryName: 'FOOD',
            itemRating: 4.5,
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

  List<Item> get _filteredItems {
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

  final List<String> categories = [
    'MEDICINE',
    'TOY',
    'FURNITURE',
    'ACCESSORY',
    'FOOD',
  ];
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

  Widget _buildItemCard(Item item) {
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
                  child: Row(
                    children: [
                      Image.network(
                        item.itemIMAGE,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.itemName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _darkMode ? Colors.white : Colors.black,
                            fontFamily: 'Fredoka',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                Icon(Icons.rate_review_rounded, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  'Rating: ${item.itemRating.toStringAsFixed(1)}',
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
                  label: Text('Add Item Into Storage'),
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
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    String? selectedCategory;
    File? dialogImageFile;
    String? dialogImagePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Add New Item'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Item Image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  dialogImageFile != null
                      ? Image.file(
                          dialogImageFile!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[200],
                          child:
                              Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            final imageTemporary = await _save(pickedFile.path);
                            _testImagePath = pickedFile.path;
                            setDialogState(() {
                              dialogImageFile = imageTemporary;
                            });
                            final uploadedPath =
                                await _getAssetsImagePath(imageTemporary.path);
                            setDialogState(() {
                              dialogImagePath = uploadedPath;
                            });
                          }
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            final imageTemporary = await _save(pickedFile.path);
                            final testPath = pickedFile.path;
                            _testImagePath = testPath;
                            setDialogState(() {
                              dialogImageFile = imageTemporary;
                            });
                            final uploadedPath =
                                await _getAssetsImagePath(imageTemporary.path);
                            setDialogState(() {
                              dialogImagePath = uploadedPath;
                            });
                          }
                        },
                        icon: Icon(Icons.photo_library),
                        label: Text('Gallery'),
                      ),
                    ],
                  ),
                  if (dialogImageFile != null)
                    TextButton(
                      onPressed: () {
                        setDialogState(() {
                          dialogImageFile = null;
                          dialogImagePath = null;
                        });
                      },
                      child: Text('Remove Image',
                          style: TextStyle(color: Colors.red)),
                    ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Item Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(_getCategoryText(category)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
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
                    maxLines: 2,
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
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _resetImagePicker();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  try {
                    final session = await SessionManager().getSession();
                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:8080/api/admin/item/add'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Cookie': '$session'
                      },
                      body: jsonEncode({
                        'itemNAME': nameController.text,
                        'itemDESCRIPTION': descriptionController.text,
                        'itemPRICE': int.tryParse(priceController.text) ?? 0,
                        'itemIMAGE': dialogImagePath ?? '',
                        'categoryCODE': selectedCategory,
                      }),
                    );

                    _resetImagePicker();
                    Navigator.of(context).pop();
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Item added successfully')),
                      );
                      _loadAllItems();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add item')),
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
          );
        },
      ),
    );
  }

  void _showAddQuantityDialog(Item item) {
    int? selectedStorageId;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Add Item to Storage'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Item: ${item.itemName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<int>(
                    value: selectedStorageId,
                    hint: Text('Select Storage Location'),
                    isExpanded: true,
                    items: _storages.map((storage) {
                      return DropdownMenuItem<int>(
                        value: storage.storageID,
                        child: Text(
                            'Storage ID: ${storage.storageID} (Dept: ${storage.departmentNAME})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStorageId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Note: Quantity will be added to the selected storage location.',
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
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedStorageId == null ||
                      quantityController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  if (quantity <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
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
                          'storageID': selectedStorageId,
                          'itemID': item.itemID,
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
                        SnackBar(content: Text('Item added successfully')),
                      );
                      _loadAllItems();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add item')),
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
          );
        },
      ),
    );
  }
}
