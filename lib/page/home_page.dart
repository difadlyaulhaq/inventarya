import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventarya/bloc/inventory/inventory_bloc.dart';
import 'package:inventarya/bloc/inventory/inventory_event.dart';
import 'package:inventarya/bloc/inventory/inventory_state.dart';
import 'package:inventarya/bloc/inventory/inventory_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(FetchInventories());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Barang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Jenis Barang'),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final type = _typeController.text.trim();
              final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

              if (name.isNotEmpty && type.isNotEmpty && quantity > 0) {
                final newItem = InventoryItem(
                  id: '',
                  name: name,
                  typeId: type.toLowerCase().replaceAll(' ', '_'),
                  typeName: type,
                  quantity: quantity,
                );
                context.read<InventoryBloc>().add(UploadInventory(newItem));
                Navigator.pop(context);
                _nameController.clear();
                _typeController.clear();
                _quantityController.clear();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Barang'),
        backgroundColor: const Color(0xFF8E24AA),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            final items = state.items;

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 80, color: Colors.purple[200]),
                    const SizedBox(height: 16),
                    Text('Belum ada data inventaris', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showAddItemDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Barang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E24AA),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('Jenis: ${item.typeName} | Jumlah: ${item.quantity}'),
                  ),
                );
              },
            );
          } else if (state is InventoryError) {
            return Center(child: Text('Terjadi kesalahan: ${state.error}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8E24AA),
      ),
    );
  }
}
