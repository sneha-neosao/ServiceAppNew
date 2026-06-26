import 'package:flutter/material.dart';
import '../../core/theme/app_color.dart';

class AppGreenButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const AppGreenButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<AppGreenButtonWidget> createState() => _AppGreenButtonWidgetState();
}

class _AppGreenButtonWidgetState extends State<AppGreenButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: AppColor.white,
            fontSize: 15,
          ),
        ), // uses theme textStyle automatically
      ),
    );
  }
}
