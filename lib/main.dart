import 'package:cloud_firestore/cloud_firestore.dart'; // Mengimpor paket untuk berinteraksi dengan Firebase Firestore.
import 'package:firebase_core/firebase_core.dart'; // Mengimpor paket untuk inisialisasi Firebase.
import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat UI.
import 'package:flutter_bloc/flutter_bloc.dart'; // Mengimpor paket Flutter BLoC untuk state management.
import 'package:inventarya/bloc/inventory/inventory_bloc.dart'; // Mengimpor InventoryBloc untuk mengelola logika inventory.
import 'package:inventarya/routes/router.dart'; // Mengimpor konfigurasi router untuk navigasi.
import 'package:inventarya/bloc/auth/auth_bloc.dart'; // Mengimpor AuthBloc untuk mengelola logika autentikasi.

/// Fungsi utama aplikasi.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan binding Flutter diinisialisasi sebelum menjalankan kode asinkron.
  await Firebase.initializeApp(); // Inisialisasi Firebase. Pastikan Firebase sudah diatur di proyek Anda.
  runApp(const MyApp()); // Menjalankan aplikasi utama.
}

/// `MyApp` adalah widget utama aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor untuk widget utama.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [ // Menyediakan beberapa BLoC untuk seluruh aplikasi.
        BlocProvider(create: (_) => AuthBloc()), // Menyediakan AuthBloc untuk autentikasi.
        BlocProvider(
          create: (_) => InventoryBloc(firestore: FirebaseFirestore.instance), // Menyediakan InventoryBloc dengan Firestore sebagai dependensi.
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false, // Menyembunyikan banner debug di pojok kanan atas.
        routerConfig: getRouter(), // Menggunakan konfigurasi router dari fungsi `getRouter`.
      ),
    );
  }
}