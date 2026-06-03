import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../routes/app_route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();
  }

  /// Requests camera and photo-library permissions.
  /// Navigation continues regardless of the user's choice.
  Future<void> _requestPermissions() async {
    List<Permission> permissionsToRequest = [];

    if ((await Permission.camera.status).isDenied) {
      permissionsToRequest.add(Permission.camera);
    }

    if (permissionsToRequest.isNotEmpty) {
      await permissionsToRequest.request();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          getIt<AuthLoginBloc>()..add(AuthCheckSignInStatusEvent()),
        ),
        BlocProvider(
          create: (_) => SplashBloc(),
        ),
      ],
      child: BlocListener<SplashBloc, SplashState>(
        listenWhen: (_, state) => state is SplashDataState,
        listener: (_, state) async {
          if (!mounted) return;

          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.edgeToEdge,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
          );

          // Request camera / photos permissions before navigating
          await _requestPermissions();

          if (!mounted) return;

          final isLoggedIn = await SessionManager.isLoggedIn();

          if (!mounted) return;

          if (isLoggedIn == true) {
            context.goNamed(AppRoute.homeScreen.name);
          } else {
            context.goNamed(AppRoute.loginScreen.name);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Image.asset(
                'assets/images/splash_bg_image.jpg',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

