import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/login/bloc/auth_login_bloc/login_bloc.dart';
import 'package:service_app/src/routes/app_route_path.dart';

class ProfileLogoutDialog extends StatelessWidget {
  const ProfileLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthLoginBloc>(),
      child: BlocListener<AuthLoginBloc, AuthLoginState>(
        listener: (context, state) {
          if (state is AuthLogoutSuccessState) {
            // Close the dialog then go to login, clearing the back stack
            Navigator.of(context, rootNavigator: true).pop();
            context.goNamed(AppRoute.loginScreen.name);
          }
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: Color(0xFFF8F9FB), shape: BoxShape.circle),
                  child: const Icon(Icons.logout, size: 32, color: Color(0xFF1565C0)),
                ),
                const SizedBox(height: 24),
                Text(
                  'logout_dialog_title'.tr(),
                  style: AppFont.style(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                ),
                const SizedBox(height: 12),
                Text(
                  'logout_dialog_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7), letterSpacing: 0.5),
                ),
                const SizedBox(height: 40),
                BlocBuilder<AuthLoginBloc, AuthLoginState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLogoutLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthLoginBloc>().add(AuthLogoutEvent()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'logout_dialog_btn_confirm'.tr(),
                                style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F9FB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'logout_dialog_btn_cancel'.tr(),
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF8E9BAE)),
                    ),
                  ),
                ),
              ],
            ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(color: Color(0xFFFFF1F0), shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, size: 32, color: Color(0xFFF44336)),
            ),
            const SizedBox(height: 24),
            Text(
              'delete_dialog_title'.tr(),
              style: AppFont.style(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFFF44336)),
            ),
            const SizedBox(height: 12),
            Text(
              'delete_dialog_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7), letterSpacing: 0.5),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle deletion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'delete_dialog_btn_confirm'.tr(),
                  style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F9FB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'delete_dialog_btn_cancel'.tr(),
                  style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF8E9BAE)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
