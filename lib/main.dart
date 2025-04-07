import 'package:flutter/material.dart';
import 'package:inventarya/routes/router.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: getRouter(), // Menggunakan GoRouter sebagai konfigurasi routing
    );
  }
}