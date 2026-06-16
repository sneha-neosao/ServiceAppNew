import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/login/bloc/auth_login_form/login_form_bloc.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'login_text_field.dart';

class LoginInputWidget extends StatefulWidget {
  const LoginInputWidget({super.key});

  @override
  State<LoginInputWidget> createState() => _LoginInputWidgetState();
}

class _LoginInputWidgetState extends State<LoginInputWidget> {
  late AuthLoginFormBloc formBloc;
  bool _isLoading = true;
  String _savedUsername = '';
  String _savedPassword = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formBloc = context.read<AuthLoginFormBloc>();
    });
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final creds = await SessionManager.getSavedCredentials();
    if (creds != null && mounted) {
      _savedUsername = creds['username'] ?? '';
      _savedPassword = creds['password'] ?? '';
      // Update form bloc so it has these values without needing onChange
      context.read<AuthLoginFormBloc>().add(LoginFormEmailChangedEvent(_savedUsername));
      context.read<AuthLoginFormBloc>().add(LoginFormPasswordChangedEvent(_savedPassword));
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Column(
      children: [
        LoginTextField<AuthLoginFormBloc>(
          label: 'login_username_label',
          hintKey: 'login_username_hint',
          prefixIcon: Icons.person_outline,
          initialValue: _savedUsername.isNotEmpty ? _savedUsername : null,
          onChanged: (val) {
            formBloc.add(LoginFormEmailChangedEvent(val.trim()));
          },
          keyboardType: TextInputType.number,
          inputFormat: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 24),
        LoginTextField<AuthLoginFormBloc>(
          label: 'login_password_label',
          hintKey: 'login_password_hint',
          prefixIcon: Icons.lock_outline,
          initialValue: _savedPassword.isNotEmpty ? _savedPassword : null,
          isSecure: true,
          onChanged: (val) {
            formBloc.add(LoginFormPasswordChangedEvent(val));
          },
        ),
      ],
    );
  }
}

