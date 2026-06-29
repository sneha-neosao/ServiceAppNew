import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_color.dart';

/// Shows a custom Toast/SnackBar using an OverlayEntry.
/// This guarantees it will always appear on top of dialogs, bottom sheets, etc.
void appSnackBar(BuildContext context, Color color, String label) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  // To handle animations, we need a StatefulBuilder or custom stateful widget.
  entry = OverlayEntry(
    builder: (context) => _AnimatedOverlaySnackBar(
      color: color,
      label: label,
      onDismissed: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _AnimatedOverlaySnackBar extends StatefulWidget {
  final Color color;
  final String label;
  final VoidCallback onDismissed;

  const _AnimatedOverlaySnackBar({
    required this.color,
    required this.label,
    required this.onDismissed,
  });

  @override
  State<_AnimatedOverlaySnackBar> createState() =>
      _AnimatedOverlaySnackBarState();
}

class _AnimatedOverlaySnackBarState extends State<_AnimatedOverlaySnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismissed();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine bottom padding, taking safe area (like keyboards/home indicators) into account.
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom +
        24.0;

    return Positioned(
      bottom: bottomPadding,
      left: 16.0,
      right: 16.0,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
