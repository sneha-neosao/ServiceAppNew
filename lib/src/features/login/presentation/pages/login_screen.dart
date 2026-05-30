import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_color.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/login/bloc/auth_login_bloc/login_bloc.dart';
import 'package:service_app/src/features/login/bloc/auth_login_form/login_form_bloc.dart';
import 'package:service_app/src/features/login/widgets/login_input_widget.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:service_app/src/routes/app_route_path.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  /// Handles the login action by dispatching an event to the AuthLoginBloc.
  void _login(BuildContext context) {
    primaryFocus?.unfocus();
    final authForm = context.read<AuthLoginFormBloc>().state;

    context.read<AuthLoginBloc>().add(
          AuthLoginEvent(
            authForm.email.trim(),
            authForm.password.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthLoginFormBloc>()),
        BlocProvider(create: (_) => getIt<AuthLoginBloc>()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/login_bg_image.jpg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ── Decorative wing shapes ───────────────────────────────
                      Positioned(
                        left: -30,
                        child: _WingShape(isLeft: true),
                      ),
                      Positioned(
                        right: -30,
                        child: _WingShape(isLeft: false),
                      ),

                      // ── Blue login card ──────────────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 36.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82C4),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82C4).withOpacity(0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ── Title ──────────────────────────────────────────
                            Text(
                              'Login',
                              style: AppFont.style(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── INPUT FIELDS ───────────────────────────────────
                            const LoginInputWidget(),

                            const SizedBox(height: 28),

                            // ── Login button ───────────────────────────────────
                            BlocConsumer<AuthLoginBloc, AuthLoginState>(
                              listener: (context, state) {
                                if (state is AuthLoginFailureState) {
                                  appSnackBar(context, AppColor.bright_red, state.message);
                                } else if (state is AuthLoginSuccessState) {
                                  // Show success snackbar
                                  appSnackBar(context, AppColor.green, state.data.message);

                                  // Delay navigation slightly so user can see the message
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    if (context.mounted) {
                                      context.goNamed(AppRoute.homeScreen.name);
                                    }
                                  });
                                }
                              },
                              builder: (context, state) {
                                final isLoading = state is AuthLoginLoadingState;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: /*(){
                                      context.pushNamed(AppRoute.homeScreen.name);
                                    }*/isLoading ? null : () => _login(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF3B82C4),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF3B82C4),
                                        strokeWidth: 2,
                                      ),
                                    )
                                        : Text(
                                      'Login',
                                      style: AppFont.style(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF3B82C4),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

/// Decorative wing/chevron shape painted beside the card
class _WingShape extends StatelessWidget {
  final bool isLeft;
  const _WingShape({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: isLeft ? -1 : 1,
      child: CustomPaint(
        size: const Size(90, 200),
        painter: _WingPainter(),
      ),
    );
  }
}

class _WingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82C4).withOpacity(0.18)
      ..style = PaintingStyle.fill;

    // Outer wing
    final outerPath = Path()
      ..moveTo(size.width, size.height * 0.2)
      ..quadraticBezierTo(0, size.height * 0.5, size.width, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.5, size.width, size.height * 0.2)
      ..close();

    canvas.drawPath(outerPath, paint);

    // Inner wing (slightly darker)
    final innerPaint = Paint()
      ..color = const Color(0xFF3B82C4).withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final innerPath = Path()
      ..moveTo(size.width, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.5, size.width, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.5, size.width, size.height * 0.3)
      ..close();

    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
