import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/routes/app_route_path.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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

                // ── USERNAME field ────────────────────────────────────────
                Text(
                  'login_username_label'.tr(),
                  style: AppFont.style(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _usernameController,
                  hintKey: 'login_username_hint',
                  prefixIcon: Icons.person_outline,
                  obscure: false,
                ),

                const SizedBox(height: 24),

                // ── PASSWORD field row (label + forgot link) ──────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'login_password_label'.tr(),
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pushNamed(
                        AppRoute.forgotPasswordScreen.name,
                      ),
                      child: Text(
                        'login_forgot_password'.tr(),
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1565C0),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintKey: 'login_password_hint',
                  prefixIcon: Icons.lock_outline,
                  obscure: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Sign In button ────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed(AppRoute.homeScreen.name);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
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
    );
  }

  // ── Shared text field builder ─────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintKey,
    required IconData prefixIcon,
    required bool obscure,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: AppFont.style(
          fontSize: 15,
          color: const Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: hintKey.tr(),
          hintStyle: AppFont.style(
            fontSize: 15,
            color: const Color(0xFFBDBDBD),
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 20,
            color: const Color(0xFFBDBDBD),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        ),
      ),
    );
  }
}
