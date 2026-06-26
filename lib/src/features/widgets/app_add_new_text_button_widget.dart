import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_color.dart';

class AppAddNewTextButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const AppAddNewTextButtonWidget({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        foregroundColor: _getTextColor(isDark), // text + icon color
        textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text("add_new".tr()),
    );
  }

  Color _getTextColor(bool isDark) {
    if (isDark) {
      return AppColor.white;
    } else {
      return enabled ? AppColor.primaryColor : AppColor.black;
    }
  }
}
