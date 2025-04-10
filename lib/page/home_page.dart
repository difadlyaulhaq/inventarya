import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat UI.
import 'package:flutter_bloc/flutter_bloc.dart'; // Mengimpor paket Flutter BLoC untuk state management.
import 'package:inventarya/bloc/inventory/inventory_bloc.dart'; // Mengimpor InventoryBloc untuk logika inventory.
import 'package:inventarya/bloc/inventory/inventory_event.dart'; // Mengimpor event untuk InventoryBloc.
import 'package:inventarya/bloc/inventory/inventory_state.dart'; // Mengimpor state untuk InventoryBloc.
import 'package:inventarya/bloc/inventory/inventory_model.dart'; // Mengimpor model data InventoryItem.

/// Halaman utama aplikasi untuk menampilkan dan mengelola data inventaris.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller untuk input teks pada dialog tambah barang.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Memicu event untuk mengambil data inventaris saat halaman dimuat.
    context.read<InventoryBloc>().add(FetchInventories());
  }

  @override
  void dispose() {
    // Membersihkan controller untuk menghindari kebocoran memori.
    _nameController.dispose();
    _typeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  /// Menampilkan dialog untuk menambahkan barang baru ke inventaris.
  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Barang'), // Judul dialog.
        content: Column(
          mainAxisSize: MainAxisSize.min, // Mengatur ukuran dialog agar sesuai konten.
          children: [
            TextField(
              controller: _nameController, // Input untuk nama barang.
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            TextField(
              controller: _typeController, // Input untuk jenis barang.
              decoration: const InputDecoration(labelText: 'Jenis Barang'),
            ),
            TextField(
              controller: _quantityController, // Input untuk jumlah barang.
              keyboardType: TextInputType.number, // Hanya menerima angka.
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Menutup dialog.
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Mengambil data dari input.
              final name = _nameController.text.trim();
              final type = _typeController.text.trim();
              final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

              // Validasi input.
              if (name.isNotEmpty && type.isNotEmpty && quantity > 0) {
                // Membuat objek InventoryItem baru.
                final newItem = InventoryItem(
                  id: '', // ID akan dihasilkan oleh Firestore.
                  name: name,
                  typeId: type.toLowerCase().replaceAll(' ', '_'), // ID jenis barang.
                  typeName: type,
                  quantity: quantity,
                );
                // Memicu event untuk mengunggah barang baru.
                context.read<InventoryBloc>().add(UploadInventory(newItem));
                Navigator.pop(context); // Menutup dialog.
                _nameController.clear(); // Membersihkan input.
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
        title: const Text('Inventaris Barang'), // Judul halaman.
        backgroundColor: const Color(0xFF8E24AA), // Warna latar belakang AppBar.
        foregroundColor: Colors.white, // Warna teks AppBar.
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            // Menampilkan indikator loading saat data sedang dimuat.
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            final items = state.items; // Data inventaris yang dimuat.

            if (items.isEmpty) {
              // Menampilkan pesan jika tidak ada data inventaris.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 80, color: Colors.purple[200]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada data inventaris',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showAddItemDialog, // Membuka dialog tambah barang.
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

            // Menampilkan daftar barang dalam bentuk ListView.
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item.name), // Nama barang.
                    subtitle: Text('Jenis: ${item.typeName} | Jumlah: ${item.quantity}'), // Detail barang.
                  ),
                );
              },
            );
          } else if (state is InventoryError) {
            // Menampilkan pesan error jika terjadi kesalahan.
            return Center(child: Text('Terjadi kesalahan: ${state.error}'));
          }
          return const SizedBox(); // Placeholder jika state tidak dikenali.
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog, // Membuka dialog tambah barang.
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF8E24AA),
      ),
    );
  }
}