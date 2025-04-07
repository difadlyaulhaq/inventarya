import 'package:go_router/go_router.dart';
import 'package:inventarya/page/home_page.dart';
import 'package:inventarya/page/login_page.dart';
import 'package:inventarya/page/splash_page.dart';
part "router_name.dart";

GoRouter getRouter (){
  return GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  ]
  );
}