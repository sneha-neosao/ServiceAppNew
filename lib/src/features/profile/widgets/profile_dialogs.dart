import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/login/bloc/auth_login_bloc/login_bloc.dart';
import 'package:service_app/src/features/profile/bloc/delete_account_bloc/delete_account_bloc.dart';
import 'package:service_app/src/features/profile/bloc/delete_account_bloc/delete_account_event.dart';
import 'package:service_app/src/features/profile/bloc/delete_account_bloc/delete_account_state.dart';
import 'package:service_app/src/routes/app_route_path.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class ProfileLogoutDialog extends StatelessWidget {
  const ProfileLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthLoginBloc>(),
      child: BlocListener<AuthLoginBloc, AuthLoginState>(
        listener: (context, state) {
          if (state is AuthLogoutSuccessState) {
            final nav = Navigator.of(context, rootNavigator: true);
            final router = GoRouter.of(context);
            
            // Pop the dialog
            nav.pop();
            // Pop the ProfileScreen
            nav.pop();
            
            // Replace declarative route with LoginScreen
            router.goNamed(AppRoute.loginScreen.name);
          }
        },
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Icon ───────────────────────────────────────────────────────
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE9F5FF), // Light blue background
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Color(0xFF1565C0), // Darker blue icon
                        size: 32,
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    // ── Title ───────────────────────────────────────────────────────
                    Text(
                      'logout_dialog_title'.tr(),
                      style: AppFont.style(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Subtitle ────────────────────────────────────────────────────
                    Text(
                      'logout_dialog_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: AppFont.style(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5C616E),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Buttons ─────────────────────────────────────────────────────
                    Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF6F6F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'cancel'.tr(),
                                  maxLines: 1,
                                  style: AppFont.style(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0D121F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Logout Now Button
                        Expanded(
                          child: BlocBuilder<AuthLoginBloc, AuthLoginState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLogoutLoadingState;
                              return SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.read<AuthLoginBloc>().add(
                                          AuthLogoutEvent(),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D47A1), // Blue for logout
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'logout_dialog_btn_confirm'.tr(),
                                            maxLines: 1,
                                            style: AppFont.style(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // ── Close (X) Icon ────────────────────────────────────────────────
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFFB0B8C8),
                    ),
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

class ProfileDeleteDialog extends StatelessWidget {
  const ProfileDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon ───────────────────────────────────────────────────────
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F0), // Light red background
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFF44336), // Red icon
                    size: 32,
                  ),
                ),
                
                const SizedBox(height: 20),

                // ── Title ───────────────────────────────────────────────────────
                Text(
                  'delete_dialog_title'.tr(),
                  style: AppFont.style(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Subtitle ────────────────────────────────────────────────────
                Text(
                  'delete_dialog_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5C616E),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Buttons ─────────────────────────────────────────────────────
                BlocProvider(
                  create: (_) => getIt<DeleteAccountBloc>(),
                  child: BlocListener<DeleteAccountBloc, DeleteAccountState>(
                    listener: (context, state) {
                      if (state is DeleteAccountSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.data.message),
                            backgroundColor: AppColor.green,
                          ),
                        );
                        final nav = Navigator.of(context, rootNavigator: true);
                        final router = GoRouter.of(context);
                        nav.pop();
                        nav.pop();
                        router.goNamed(AppRoute.loginScreen.name);
                      } else if (state is DeleteAccountFailureState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: AppColor.bright_red,
                          ),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF6F6F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'cancel'.tr(),
                                  maxLines: 1,
                                  style: AppFont.style(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0D121F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Delete Now Button
                        Expanded(
                          child: BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                            builder: (context, state) {
                              final isLoading = state is DeleteAccountLoadingState;
                              return SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context.read<DeleteAccountBloc>().add(
                                                const DeleteAccountSubmittedEvent(),
                                              );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE30000), // Red for delete
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'delete_dialog_btn_confirm'.tr(),
                                            maxLines: 1,
                                            style: AppFont.style(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // ── Close (X) Icon ────────────────────────────────────────────────
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFFB0B8C8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
