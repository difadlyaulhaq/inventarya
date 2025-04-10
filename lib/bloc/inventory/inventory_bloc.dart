import 'package:flutter_bloc/flutter_bloc.dart'; // Mengimpor paket untuk menggunakan Flutter BLoC (Business Logic Component).
import 'package:cloud_firestore/cloud_firestore.dart'; // Mengimpor paket untuk berinteraksi dengan Firebase Firestore.
import 'inventory_event.dart'; // Mengimpor file yang mendefinisikan event untuk InventoryBloc.
import 'inventory_state.dart'; // Mengimpor file yang mendefinisikan state untuk InventoryBloc.
import 'inventory_model.dart'; // Mengimpor file yang mendefinisikan model data Inventory.

/// `InventoryBloc` adalah kelas yang mengatur logika bisnis untuk fitur inventory.
/// Kelas ini menggunakan Flutter BLoC untuk memproses event dan mengubah state.
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final FirebaseFirestore firestore; // Instance Firestore untuk berinteraksi dengan database.

  /// Constructor `InventoryBloc` menerima instance Firestore dan menginisialisasi state awal.
  InventoryBloc({required this.firestore}) : super(InventoryInitial()) {
    // Mendaftarkan handler untuk setiap jenis event.
    on<UploadInventory>(_onUploadInventory); // Handler untuk event upload inventory.
    on<FetchInventories>(_onFetchInventories); // Handler untuk event fetch inventories.
    on<UpdateInventory>(_onUpdateInventory); // Handler untuk event update inventory.
  }

  /// Handler untuk event `UploadInventory`.
  /// Event ini digunakan untuk mengunggah item inventory ke Firestore.
  Future<void> _onUploadInventory(
    UploadInventory event, // Event yang berisi data item yang akan diunggah.
    Emitter<InventoryState> emit, // Fungsi untuk mengubah state.
  ) async {
    emit(InventoryUploading()); // Mengubah state menjadi `InventoryUploading` (proses upload sedang berlangsung).
    try {
      // Menambahkan item ke koleksi 'inventories' di Firestore.
      await firestore.collection('inventories').add(event.item.toMap());
      emit(InventoryUploaded()); // Mengubah state menjadi `InventoryUploaded` (upload berhasil).
      add(FetchInventories()); // Memicu event `FetchInventories` untuk memperbarui daftar inventory.
    } catch (e) {
      emit(InventoryUploadError(e.toString())); // Mengubah state menjadi `InventoryUploadError` jika terjadi error.
    }
  }

  /// Handler untuk event `FetchInventories`.
  /// Event ini digunakan untuk mengambil semua item inventory dari Firestore.
  Future<void> _onFetchInventories(
    FetchInventories event, // Event untuk memicu pengambilan data.
    Emitter<InventoryState> emit, // Fungsi untuk mengubah state.
  ) async {
    emit(InventoryLoading()); // Mengubah state menjadi `InventoryLoading` (proses pengambilan data sedang berlangsung).
    try {
      // Mengambil semua dokumen dari koleksi 'inventories'.
      final snapshot = await firestore.collection('inventories').get();
      // Mengonversi dokumen menjadi daftar `InventoryItem`.
      final items = snapshot.docs.map((doc) {
        final data = doc.data(); // Data dari dokumen.
        return InventoryItem.fromMap(data); // Membuat objek `InventoryItem` dari data.
      }).toList();
      emit(InventoryLoaded(items)); // Mengubah state menjadi `InventoryLoaded` dengan daftar item.
    } catch (e) {
      emit(InventoryError(e.toString())); // Mengubah state menjadi `InventoryError` jika terjadi error.
    }
  }

  /// Handler untuk event `UpdateInventory`.
  /// Event ini digunakan untuk memperbarui item inventory di Firestore.
  Future<void> _onUpdateInventory(
    UpdateInventory event, // Event yang berisi ID dokumen dan data item yang diperbarui.
    Emitter<InventoryState> emit, // Fungsi untuk mengubah state.
  ) async {
    try {
      // Memperbarui dokumen di koleksi 'inventories' berdasarkan ID dokumen.
      await firestore
          .collection('inventories')
          .doc(event.docId)
          .update(event.item.toMap());
      add(FetchInventories()); // Memicu event `FetchInventories` untuk memperbarui daftar inventory.
    } catch (e) {
      emit(InventoryError(e.toString())); // Mengubah state menjadi `InventoryError` jika terjadi error.
    }
  }
}