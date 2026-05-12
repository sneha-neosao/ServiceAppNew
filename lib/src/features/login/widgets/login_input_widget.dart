import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/features/login/bloc/auth_login_form/login_form_bloc.dart';
import 'login_text_field.dart';

class LoginInputWidget extends StatefulWidget {
  const LoginInputWidget({super.key});

  @override
  State<LoginInputWidget> createState() => _LoginInputWidgetState();
}

class _LoginInputWidgetState extends State<LoginInputWidget> {
  late AuthLoginFormBloc formBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formBloc = context.read<AuthLoginFormBloc>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginTextField<AuthLoginFormBloc>(
          label: 'login_username_label',
          hintKey: 'login_username_hint',
          prefixIcon: Icons.person_outline,
          onChanged: (val) {
            formBloc.add(LoginFormEmailChangedEvent(val.trim()));
          },
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        LoginTextField<AuthLoginFormBloc>(
          label: 'login_password_label',
          hintKey: 'login_password_hint',
          prefixIcon: Icons.lock_outline,
          isSecure: true,
          onChanged: (val) {
            formBloc.add(LoginFormPasswordChangedEvent(val));
          },
        ),
      ],
    );
  }
}
