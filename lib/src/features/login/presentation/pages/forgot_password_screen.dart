import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/login/widgets/forgot_password_input.dart';
import 'package:service_app/src/routes/app_route_path.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),

                // ── Heading ───────────────────────────────────────────────
                Text(
                  'forgot_title'.tr(),
                  style: AppFont.style(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColor.colorFF1A1A1A,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'forgot_subtitle'.tr(),
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColor.colorFF6B6B6B,
                    height: 1.55,
                  ),
                ),

                const SizedBox(height: 40),

                // ── USERNAME label ────────────────────────────────────────
                Text(
                  'forgot_username_label'.tr(),
                  style: AppFont.style(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColor.colorFF1A1A1A,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Username field ────────────────────────────────────────
                // ForgotPasswordInputWidget(usernameController: _usernameController),
                const SizedBox(height: 28),

                // ── Send Reset Link button ────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: handle send reset link logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.colorFF1A1A1A,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'forgot_send_link'.tr(),
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Back to Login ─────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => context.pushNamed(AppRoute.loginScreen.name),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chevron_left,
                          size: 18,
                          color: AppColor.colorFF6B6B6B,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'forgot_back_to_login'.tr(),
                          style: AppFont.style(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.colorFF1A1A1A,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // ── Copyright footer ──────────────────────────────────────
                Center(
                  child: Text(
                    'login_copyright'.tr(),
                    style: AppFont.style(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: AppColor.colorFFBDBDBD,
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
    );
  }
}
