import 'package:go_router/go_router.dart'; // Mengimpor paket GoRouter untuk mengelola navigasi.
import 'package:inventarya/page/home_page.dart'; // Mengimpor halaman HomePage.
import 'package:inventarya/page/login_page.dart'; // Mengimpor halaman LoginPage.
import 'package:inventarya/page/splash_page.dart'; // Mengimpor halaman SplashPage.
part 'router_name.dart'; // Mengimpor file `router_name.dart` yang berisi nama-nama rute.

/// Fungsi `getRouter` digunakan untuk mengembalikan instance GoRouter.
/// GoRouter adalah library untuk mengelola navigasi di aplikasi Flutter.
GoRouter getRouter() {
  return GoRouter(
    initialLocation: RoutesName.splash, // Lokasi awal aplikasi saat pertama kali dibuka.
    debugLogDiagnostics: true, // Mengaktifkan log debug untuk membantu pengembangan.
    routes: [ // Daftar rute yang tersedia di aplikasi.
      GoRoute(
        path: RoutesName.splash, // Path untuk halaman Splash.
        builder: (context, state) => const SplashPage(), // Menampilkan halaman SplashPage.
      ),
      GoRoute(
        path: RoutesName.login, // Path untuk halaman Login.
        builder: (context, state) => const LoginPage(), // Menampilkan halaman LoginPage.
      ),
      GoRoute(
        path: RoutesName.home, // Path untuk halaman Home.
        builder: (context, state) => const HomePage(), // Menampilkan halaman HomePage.
      ),
    ],
  );
}