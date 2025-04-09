import 'package:go_router/go_router.dart';
import 'package:inventarya/page/home_page.dart';
import 'package:inventarya/page/login_page.dart';
import 'package:inventarya/page/splash_page.dart';
part 'router_name.dart';

GoRouter getRouter() {
  return GoRouter(
    initialLocation: RoutesName.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutesName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutesName.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutesName.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
