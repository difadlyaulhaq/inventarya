import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat UI.
import 'package:go_router/go_router.dart'; // Mengimpor GoRouter untuk navigasi.

/// Halaman Splash yang ditampilkan saat aplikasi pertama kali dibuka.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Menunda selama 3 detik sebelum navigasi ke halaman login.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) { // Memastikan widget masih ada di widget tree.
        context.go("/login"); // Navigasi ke halaman login menggunakan GoRouter.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Menempatkan konten di tengah secara vertikal.
          children: const [
            Image(
              image: AssetImage("assets/logo.png"), // Menampilkan logo aplikasi.
            ),
            SizedBox(height: 20), // Memberikan jarak antara logo dan teks.
            Text(
              'INVENTARYA', // Nama aplikasi.
              style: TextStyle(
                fontSize: 40, // Ukuran font besar.
                fontWeight: FontWeight.bold, // Teks tebal.
                color: Colors.black, // Warna teks hitam.
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// /// Halaman berikutnya sebagai contoh (tidak digunakan dalam SplashPage).
// class NextPage extends StatelessWidget {
//   const NextPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Next Page')), // Judul halaman di AppBar.
//       body: const Center(child: Text('Welcome to the Next Page!')), // Konten halaman.
//     );
//   }
// }