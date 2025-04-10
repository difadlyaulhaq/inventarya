import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat UI.

/// `CustomButton` adalah widget kustom yang membungkus `ElevatedButton`.
/// Widget ini dapat digunakan untuk membuat tombol dengan teks atau widget anak.
class CustomButton extends StatelessWidget {
  final String? text; // Teks yang akan ditampilkan pada tombol (opsional).
  final Widget? child; // Widget kustom yang akan ditampilkan pada tombol (opsional).
  final VoidCallback? onPressed; // Fungsi callback yang akan dipanggil saat tombol ditekan.

  /// Constructor untuk `CustomButton`.
  /// Parameter `text`, `child`, dan `onPressed` bersifat opsional.
  const CustomButton({
    super.key, // Kunci unik untuk widget ini.
    this.text, // Teks tombol.
    this.child, // Widget anak tombol.
    this.onPressed, // Fungsi yang dipanggil saat tombol ditekan.
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Menentukan fungsi yang dipanggil saat tombol ditekan.
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertikal tombol.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Membuat sudut tombol melengkung.
        ),
      ),
      // Menampilkan widget anak jika ada, atau teks jika widget anak tidak disediakan.
      child: child ?? Text(
        text ?? '', // Jika teks tidak disediakan, tampilkan string kosong.
        style: const TextStyle(fontSize: 16), // Gaya teks dengan ukuran font 16.
      ),
    );
  }
}