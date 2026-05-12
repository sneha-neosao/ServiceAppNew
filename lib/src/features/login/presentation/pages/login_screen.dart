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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // ── Welcome heading ───────────────────────────────────────
                  Text(
                    'login_welcome_title'.tr(),
                    style: AppFont.style(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'login_welcome_subtitle'.tr(),
                    style: AppFont.style(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B6B6B),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── INPUT FIELDS ──────────────────────────────────────────
                  const LoginInputWidget(),

                  const SizedBox(height: 32),

                  // ── Sign In button ────────────────────────────────────────
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
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A1A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'login_sign_in'.tr(),
                                      style: AppFont.style(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 18),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // ── Don't have an account ─────────────────────────────────
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: AppFont.style(
                          fontSize: 14,
                          color: const Color(0xFF6B6B6B),
                        ),
                        children: [
                          TextSpan(text: '${'login_no_account'.tr()} '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () {
                                // TODO: handle contact admin action
                              },
                              child: Text(
                                'login_contact_admin'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Copyright footer ──────────────────────────────────────
                  Center(
                    child: Text(
                      'login_copyright'.tr(),
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFBDBDBD),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
