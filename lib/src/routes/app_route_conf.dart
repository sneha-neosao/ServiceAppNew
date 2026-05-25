import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'app_route_path.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> globalNavigator = GlobalKey<NavigatorState>();

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    navigatorKey: globalNavigator,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        pageBuilder: (context, state) => _fadePage(const SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.nextScreen.path,
        name: AppRoute.nextScreen.name,
        pageBuilder: (context, state) => _fadePage(const NextScreen()),
      ),
      GoRoute(
        path: AppRoute.loginScreen.path,
        name: AppRoute.loginScreen.name,
        pageBuilder: (context, state) => _fadePage(const LoginScreen()),
      ),
      GoRoute(
        path: AppRoute.forgotPasswordScreen.path,
        name: AppRoute.forgotPasswordScreen.name,
        pageBuilder: (context, state) => _fadePage(const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: AppRoute.homeScreen.path,
        name: AppRoute.homeScreen.name,
        pageBuilder: (context, state) => _fadePage(const HomeScreen()),
      ),
    ],
  );
}

/// Fade transition page helper

CustomTransitionPage _fadePage(Widget child) => CustomTransitionPage(
  transitionDuration: const Duration(
    milliseconds: 800,
  ), // Duration of the animation
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut, // Smooth in-out fade
    );

    return FadeTransition(opacity: curvedAnimation, child: child);
  },
);

