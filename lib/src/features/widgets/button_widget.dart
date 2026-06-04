import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final double? disabledElevation;
  final double? focusElevation;
  final double? hoverElevation;
  final double? highlightElevation;
  final Duration? animationDuration;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MouseCursor? mouseCursor;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;
  final bool? autofocus;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final MaterialStatesController? statesController;
  final bool isFullWidth;
  final bool isLoading;
  final Widget? loadingChild;

  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.disabledElevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.animationDuration,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.side,
    this.shape,
    this.mouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.statesController,
    this.isFullWidth = false,
    this.isLoading = false,
    this.loadingChild,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        onLongPress: isLoading ? null : onLongPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor ?? Colors.white,
          disabledBackgroundColor:
              disabledBackgroundColor ?? Colors.grey.shade300,
          disabledForegroundColor:
              disabledForegroundColor ?? Colors.grey.shade500,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          elevation: elevation ?? 2.0,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          minimumSize: minimumSize ?? const Size(88, 48),
          fixedSize: fixedSize,
          maximumSize: maximumSize ?? Size.infinite,
          side: side,
          shape:
              shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          visualDensity: visualDensity,
          tapTargetSize: tapTargetSize,
          animationDuration:
              animationDuration ?? const Duration(milliseconds: 200),
          enableFeedback: true,
          alignment: Alignment.center,
          splashFactory: InkRipple.splashFactory,
        ),
        clipBehavior: clipBehavior,
        focusNode: focusNode,
        statesController: statesController,
        autofocus: autofocus ?? false,
        child: isLoading
            ? (loadingChild ?? _buildLoadingIndicator(context))
            : child,
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          foregroundColor ?? Colors.white,
        ),
      ),
    );
  }
}
