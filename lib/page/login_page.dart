import 'package:flutter/material.dart'; // Mengimpor paket Flutter untuk membuat UI.
import 'package:flutter_bloc/flutter_bloc.dart'; // Mengimpor paket Flutter BLoC untuk state management.
import 'package:go_router/go_router.dart'; // Mengimpor GoRouter untuk navigasi.
import 'package:inventarya/bloc/auth/auth_bloc.dart'; // Mengimpor AuthBloc untuk logika autentikasi.
import 'package:inventarya/bloc/auth/auth_event.dart'; // Mengimpor event untuk AuthBloc.
import 'package:inventarya/bloc/auth/auth_state.dart'; // Mengimpor state untuk AuthBloc.
import 'package:inventarya/widget/button_widget.dart'; // Mengimpor widget kustom untuk tombol.

/// Halaman login aplikasi.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true; // Menentukan apakah password disembunyikan.
  final TextEditingController _usernameController = TextEditingController(); // Controller untuk input email.
  final TextEditingController _passwordController = TextEditingController(); // Controller untuk input password.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0), // Padding horizontal untuk halaman.
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Menempatkan konten di tengah secara vertikal.
              crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat konten memenuhi lebar layar.
              children: [
                const Image(
                  image: AssetImage("assets/logo.png"), // Menampilkan logo aplikasi.
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'INVENTARYA', // Nama aplikasi.
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Login', // Judul halaman login.
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController, // Input untuk email.
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController, // Input untuk password.
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off, // Ikon untuk menyembunyikan/menampilkan password.
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // Mengubah status penyembunyian password.
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText, // Menentukan apakah teks password disembunyikan.
                ),
                const SizedBox(height: 30),

                // BlocConsumer untuk tombol login.
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is Authenticated) {
                      // Jika login berhasil, tampilkan pesan dan navigasi ke halaman home.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login successful!')),
                      );
                      context.go('/home'); // Navigasi ke halaman home.
                    } else if (state is AuthError) {
                      // Jika login gagal, tampilkan pesan error.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: state is AuthLoading ? null : "Login", // Tampilkan teks "Login" jika tidak sedang loading.
                      onPressed: state is AuthLoading
                          ? null // Nonaktifkan tombol jika sedang loading.
                          : () {
                              if (_usernameController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                // Validasi input kosong.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                  ),
                                );
                              } else {
                                // Memicu event login dengan email dan password.
                                context.read<AuthBloc>().add(
                                      LoginRequested(
                                        _usernameController.text.trim(),
                                        _passwordController.text.trim(),
                                      ),
                                    );
                              }
                            },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white, // Tampilkan indikator loading di tombol.
                            )
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}