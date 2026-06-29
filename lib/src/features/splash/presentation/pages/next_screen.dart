import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/routes/app_route_path.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  // Animated dot controller — one per slide
  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotWidthAnimations;

  static const _totalPages = 3;
  static const _autoPlayDuration = Duration(seconds: 4);
  static const _animDuration = Duration(milliseconds: 400);

  // Pill indicator dimensions
  static const double _dotSize = 8.0;
  static const double _activePillWidth = 28.0;
  static const double _dotSpacing = 6.0;

  final List<String> _imageUrls = const [
    "https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=2069&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=2070&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2070&auto=format&fit=crop",
  ];

  final List<Map<String, String>> _slideContent = [
    {'title': 'slide1_title', 'subtitle': 'slide1_subtitle'},
    {'title': 'slide2_title', 'subtitle': 'slide2_subtitle'},
    {'title': 'slide3_title', 'subtitle': 'slide3_subtitle'},
  ];

  @override
  void initState() {
    super.initState();

    // Create one AnimationController per dot
    _dotControllers = List.generate(
      _totalPages,
      (i) => AnimationController(vsync: this, duration: _animDuration),
    );

    _dotWidthAnimations = _dotControllers.map((ctrl) {
      return Tween<double>(
        begin: _dotSize,
        end: _activePillWidth,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
    }).toList();

    // Activate first dot immediately
    _dotControllers[0].forward();

    // Start auto-play
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(_autoPlayDuration, (_) {
      final next = (_currentPage + 1) % _totalPages;
      _animateToPage(next);
    });
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    // Reverse old dot, forward new dot
    _dotControllers[_currentPage].reverse();
    _dotControllers[index].forward();
    setState(() => _currentPage = index);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen pager ──────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return _SlideItem(
                imageUrl: _imageUrls[index],
                titleKey: _slideContent[index]['title']!,
                subtitleKey: _slideContent[index]['subtitle']!,
              );
            },
          ),

          // ── Top bar: Logo left + Skip right ────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                  // Skip button
                  GestureDetector(
                    onTap: () => context.goNamed(AppRoute.loginScreen.name),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'skip'.tr(),
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom indicator area ──────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(_totalPages, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < _totalPages - 1 ? _dotSpacing : 0,
                    ),
                    child: _AnimatedDot(
                      widthAnimation: _dotWidthAnimations[index],
                      isActive: _currentPage == index,
                      dotSize: _dotSize,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual slide ──────────────────────────────────────────────────────────
class _SlideItem extends StatelessWidget {
  final String imageUrl;
  final String titleKey;
  final String subtitleKey;

  const _SlideItem({
    required this.imageUrl,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background network image
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            return Container(color: Colors.black87);
          },
          errorBuilder: (ctx, error, stack) => Container(color: Colors.black87),
        ),

        // Dark gradient overlay — stronger at bottom for text legibility
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.color55000000, // subtle top tint
                AppColor.color22000000, // mid transparent
                AppColor.colorBB000000, // heavy bottom for text
                AppColor.colorDD000000,
              ],
              stops: [0.0, 0.35, 0.7, 1.0],
            ),
          ),
        ),

        // Text content — positioned above the indicator bar
        Positioned(
          left: 20,
          right: 20,
          bottom: 72, // sits above the dots (dots at bottom:40)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titleKey.tr(),
                style: AppFont.style(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitleKey.tr(),
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.90),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Animated dot/pill indicator ───────────────────────────────────────────────
class _AnimatedDot extends StatelessWidget {
  final Animation<double> widthAnimation;
  final bool isActive;
  final double dotSize;

  const _AnimatedDot({
    required this.widthAnimation,
    required this.isActive,
    required this.dotSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widthAnimation,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widthAnimation.value,
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive
                ? AppColor.colorFF1565C0
                : Colors.grey.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      },
    );
  }
}
