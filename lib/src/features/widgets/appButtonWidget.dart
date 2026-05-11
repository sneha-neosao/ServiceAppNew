import 'package:flutter/material.dart';

import '../../core/theme/app_color.dart';

class AppButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final bool enabled; // 👈 new param

  const AppButtonWidget({super.key, required this.onPressed, required this.label, this.enabled=true});

  @override
  State<AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.0),
        child: ElevatedButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 35,),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: _getTextColor(isDark),fontSize: 17),
              ),
              Image.asset("assets/icons/arrow.png", height: 35,)
            ],
          ), // uses theme textStyle automatically
        )
    );
  }
  Color _getTextColor(bool isDark) {
    if (isDark) {
      // Dark mode: always white
      return AppColor.white;
    } else {
      // Light mode: white if enabled, black if disabled
      return widget.enabled ? AppColor.white : AppColor.black;
    }
  }
}
