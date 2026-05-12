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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: TextFormField(
            initialValue: widget.initialValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: widget.isSecure ?? false ? _isVisible : false,
            onChanged: widget.onChanged,
            style: AppFont.style(
              fontSize: 15,
              color: const Color(0xFF1A1A1A),
            ),
            textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
            inputFormatters: widget.inputFormat,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly ?? false,
            validator: (val) {
              if (formBloc is AuthLoginFormBloc) {
                if (widget.label == "login_username_label" && !formBloc.state.email.isEmailValid) {
                  return "please_enter_valid_email".tr();
                }
               /*else if (widget.label == "login_password_label" && (val == null || val.length < 6)) {
                  return "password_too_short".tr();
                }*/
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: widget.hintKey.tr(),
              hintStyle: AppFont.style(
                fontSize: 15,
                color: const Color(0xFFBDBDBD),
              ),
              prefixIcon: Icon(
                widget.prefixIcon,
                size: 20,
                color: const Color(0xFFBDBDBD),
              ),
              suffixIcon: widget.isSecure ?? false
                  ? IconButton(
                      onPressed: _toggleVisibility,
                      icon: Icon(
                        _isVisible ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                        size: 20,
                        color: const Color(0xFF9E9E9E),
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              errorStyle: AppFont.style(fontSize: 10, color: Colors.red, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
