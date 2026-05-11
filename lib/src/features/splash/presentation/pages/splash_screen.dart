import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/core/theme/app_color.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../routes/app_route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _topController;
  late AnimationController _bottomController;
  late AnimationController _fadeController;
  late AnimationController _zoomController;
  late AnimationController _zoomInController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _zoomAnimation;
  late Animation<Offset> _topAnimation;
  late Animation<Offset> _bottomAnimation;
  late Animation<double> _zoomInAnimation;

  // SignInState? _lastAuthState; // 👈 store auth state

  @override
  void initState() {
    super.initState();

    // Top slide-down
    _topController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _topAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _topController,
      curve: Curves.easeOutBack,
    ));

    // Bottom slide-up
    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bottomAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bottomController,
      curve: Curves.easeOutBack,
    ));

    // Fade in center
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));


    // Zoom-in animation (small pop effect)
    _zoomInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _zoomInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zoomInController,
      curve: Curves.easeOutBack,
    ));


    // Zoom out to full screen
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 10.0) // Scale to fill screen
        .animate(CurvedAnimation(parent: _zoomController, curve: Curves.easeIn));

    // Start slide animations
    _topController.forward();
    _bottomController.forward();

    // Start fade + zoom-in together
    _topController.addListener(() {
      if (_topController.value >= 0.9 && !_fadeController.isAnimating) {
        _fadeController.forward();
        _zoomInController.forward();      }
    });

    // After fade + zoom-in finish → wait 2 sec → then zoom-out
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!mounted) return;
      _zoomController.forward();
    });

    // Navigate after zoom completes
    _zoomController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.microtask(() async {

          final isLoggedIn = await SessionManager.isLoggedIn();

          if (!mounted) return;

          if (isLoggedIn == true) {
            // context.pushNamed(
            //   // AppRoute.landingContentScreen.name,
            // );
          } else {
            context.goNamed(
              AppRoute.nextScreen.name,
            );
          }
        });
      }
    });

  }

  @override
  void dispose() {
    _topController.dispose();
    _bottomController.dispose();
    _fadeController.dispose();
    _zoomController.dispose();
    _zoomInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return
      // MultiBlocProvider(
      // providers: [
      //   BlocProvider(
      //     create: (_) => getIt<SignInBloc>()..add(AuthCheckSignInStatusEvent()),
      //   ),
      //   BlocProvider(
      //     create: (_) => getIt<SplashBloc>(),
      //   ),
      // ],
      // child: BlocListener<SignInBloc, SignInState>(
      //     listenWhen: (_, current) =>
      //     current is AuthCheckSignInStatusSuccessState ||
      //         current is AuthCheckSignInStatusFailureState,
      //     listener: (_, state) {
      //       _lastAuthState = state; // 👈 store state for later navigation
      //     },
      //   child: BlocBuilder<SplashBloc,SplashState>(
      //       builder: (_,state){
      //         return
                SafeArea(
                child: Scaffold(
                  body: Stack(
                    children: [
                      // Bottom asset
                      SlideTransition(
                        position: _bottomAnimation,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            "assets/images/down.png",
                            height: size.height * 0.25,
                            width: size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                
                      // Top asset
                      SlideTransition(
                        position: _topAnimation,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            "assets/images/up.png",
                            height: size.height * 0.25,
                            width: size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                
                      // Center content with fade & zoom
                      Center(
                        child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _zoomInAnimation,        // first small pop
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Ellipse image zooms out
                                  ScaleTransition(
                                    scale: _zoomAnimation,
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 31),
                                      child: Image.asset(
                                        "assets/images/ellipse.png",
                                        height: size.height * 0.75,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                
                                  // Text stays static
                                  Text(
                                    "app_title".tr(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                      textStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                                        fontSize: size.width * 0.08,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? AppColor.black
                                            : AppColor.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              );
    //         }
    //     )
    //   ),
    // );
  }
}

