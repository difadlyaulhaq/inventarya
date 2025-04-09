  import 'package:flutter/material.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    // Daftar barang inventaris
    final List<InventoryItem> _items = [];
    
    // Controller untuk input text
    final TextEditingController _idController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _typeIdController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();
    
    // Jenis barang yang tersedia (untuk dropdown)
    final List<ItemType> _itemTypes = [
      ItemType(id: '1', name: 'Furniture'),
      ItemType(id: '2', name: 'Elektronik'),
      ItemType(id: '3', name: 'Alat Tulis'),
      ItemType(id: '4', name: 'Alat Olahraga'),
      ItemType(id: '5', name: 'Lainnya'),
    ];
    
    String _selectedTypeId = '1';

    @override
    void dispose() {
      _idController.dispose();
      _nameController.dispose();
      _typeIdController.dispose();
      _quantityController.dispose();
      super.dispose();
    }

    // Fungsi untuk menambah barang baru
    void _addItem() {
      if (_idController.text.isEmpty || 
          _nameController.text.isEmpty || 
          _quantityController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua field harus diisi!')),
        );
        return;
      }
      
      setState(() {
        _items.add(
          InventoryItem(
            id: _idController.text,
            name: _nameController.text,
            typeId: _selectedTypeId,
            typeName: _itemTypes.firstWhere((type) => type.id == _selectedTypeId).name,
            quantity: int.parse(_quantityController.text),
          ),
        );
        
        // Reset form setelah menambah item
        _idController.clear();
        _nameController.clear();
        _quantityController.clear();
      });
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang berhasil ditambahkan!')),
      );
    }

    // Fungsi untuk menampilkan dialog form tambah barang
    void _showAddItemDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tambah Barang Inventaris'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'ID Barang',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Jenis Barang',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedTypeId,
                  items: _itemTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type.id,
                      child: Text('${type.id} - ${type.name}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTypeId = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E24AA),
              ),
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Inventaris Sekolah', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF8E24AA),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort, color: Colors.white),
              onPressed: () {
                setState(() {
                  _items.sort((a, b) => a.id.compareTo(b.id));
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diurutkan berdasarkan ID')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Implementasi pencarian
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur pencarian akan datang')),
                );
              },
            ),
          ],
        ),
        body: _items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: Colors.purple[200],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada data inventaris',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showAddItemDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Barang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E24AA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Inventaris',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${_items.length} barang',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple[100],
                                child: Text(
                                  item.id,
                                  style: const TextStyle(
                                    color: Color(0xFF8E24AA),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Jenis: ${item.typeName}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(
                                      '${item.quantity} unit',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: const Color(0xFFAB47BC),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF8E24AA)),
                                    onPressed: () {
                                      // Implementasi edit
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Fitur edit akan datang')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddItemDialog,
          backgroundColor: const Color(0xFF8E24AA),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }
  }

  // Model untuk item inventaris
  class InventoryItem {
    final String id;
    final String name;
    final String typeId;
    final String typeName;
    final int quantity;

    InventoryItem({
      required this.id,
      required this.name,
      required this.typeId,
      required this.typeName,
      required this.quantity,
    });
  }

  // Model untuk jenis barang
  class ItemType {
    final String id;
    final String name;

    ItemType({
      required this.id,
      required this.name,
    });
  }