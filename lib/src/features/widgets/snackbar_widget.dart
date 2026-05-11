import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_color.dart';

/// Shows a custom SnackBar with the given label and background color.
appSnackBar(BuildContext context, Color color, String label) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label,style: TextStyle(color: AppColor.white),),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
