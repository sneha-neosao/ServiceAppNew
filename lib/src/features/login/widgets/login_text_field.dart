import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/extensions/string_validator_extension.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/login/bloc/auth_login_form/login_form_bloc.dart';

class LoginTextField<T> extends StatefulWidget {
  final String label;
  final String hintKey;
  final IconData prefixIcon;
  final bool? isSecure;
  final List<TextInputFormatter>? inputFormat;
  final void Function(String)? onChanged;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final TextCapitalization? textCapitalization;

  const LoginTextField({
    super.key,
    required this.label,
    required this.hintKey,
    required this.prefixIcon,
    this.onChanged,
    this.isSecure,
    this.readOnly,
    this.inputFormat,
    this.initialValue,
    this.keyboardType,
    this.textCapitalization,
  });

  @override
  State<LoginTextField<T>> createState() => _LoginTextFieldState<T>();
}

class _LoginTextFieldState<T> extends State<LoginTextField<T>> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<T>();
    return TextFormField(
      initialValue: widget.initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isSecure ?? false ? _isVisible : false,
      onChanged: widget.onChanged,
      style: AppFont.style(fontSize: 14, color: Colors.white),
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      inputFormatters: widget.inputFormat,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly ?? false,
      validator: (val) {
        if (formBloc is AuthLoginFormBloc) {
          /* if (widget.label == "login_username_label" && !formBloc.state.email.isEmailValid) {
            return "please_enter_valid_email".tr();
          }*/
          /*else if (widget.label == "login_password_label" && (val == null || val.length < 6)) {
            return "password_too_short".tr();
          }*/
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.label.tr(),
        labelStyle: AppFont.style(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.85),
        ),
        floatingLabelStyle: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        hintText: widget.hintKey.tr(),
        hintStyle: AppFont.style(
          fontSize: 14,
          color: Colors.white.withOpacity(0.5),
        ),
        suffixIcon: widget.isSecure ?? false
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: Icon(
                  _isVisible
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: Colors.white.withOpacity(0.8),
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.7),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue.withOpacity(0.8),
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 1.6),
        ),
        errorStyle: AppFont.style(
          fontSize: 10,
          color: Colors.blue,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
