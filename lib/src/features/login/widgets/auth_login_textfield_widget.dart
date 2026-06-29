import 'package:service_app/src/core/theme/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_app/src/core/theme/app_font.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';

class AuthTextField<T> extends StatefulWidget {
  final String label;
  final String hint;
  final bool? isSecure;
  final List<TextInputFormatter>? inputFormat;
  final void Function(String)? onChanged;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final TextCapitalization? textCapitalization;

  // NEW
  final IconData? prefixIcon;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.isSecure,
    this.readOnly,
    this.inputFormat,
    this.initialValue,
    this.keyboardType,
    this.textCapitalization,
    this.prefixIcon,
  });

  @override
  State<AuthTextField<T>> createState() => _AuthTextFieldState<T>();
}

class _AuthTextFieldState<T> extends State<AuthTextField<T>> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 33.w,
        vertical: 4.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LABEL
          Text(
            widget.label.tr(),
            style: AppFont.style(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColor.colorFF1A1A1A,
              letterSpacing: 1.2,
            ),
          ),

          8.hS,

          /// TEXTFIELD
          Container(
            decoration: BoxDecoration(
              color: AppColor.colorFFF5F5F5,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColor.colorFFE0E0E0, width: 1),
            ),
            child: TextFormField(
              initialValue: widget.initialValue,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: widget.isSecure ?? false ? _isVisible : false,
              cursorColor: AppColor.colorFF1A1A1A,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly ?? false,
              inputFormatters: widget.inputFormat,
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,

              style: AppFont.style(
                fontSize: 13.sp,
                color: AppColor.colorFF1A1A1A,
              ),

              decoration: InputDecoration(
                border: InputBorder.none,

                /// HINT
                hintText: widget.hint.tr(),
                hintStyle: AppFont.style(
                  fontSize: 13.sp,
                  color: AppColor.colorFFBDBDBD,
                ),

                /// PREFIX ICON
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        size: 20.sp,
                        color: AppColor.colorFFBDBDBD,
                      )
                    : null,

                /// PASSWORD ICON
                suffixIcon: widget.isSecure ?? false
                    ? IconButton(
                        onPressed: _toggleVisibility,
                        splashRadius: 20.r,
                        icon: Icon(
                          _isVisible
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          size: 20.sp,
                          color: AppColor.colorFF9E9E9E,
                        ),
                      )
                    : null,

                /// PADDING
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 16.w,
                ),

                /// ERROR STYLE
                errorMaxLines: 3,
                errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 8.sp,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
