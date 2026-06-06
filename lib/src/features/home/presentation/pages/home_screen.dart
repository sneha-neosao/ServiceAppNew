import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/home/bloc/upcoming_amc_bloc/upcoming_amc_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/profile/bloc/profile_details_bloc/profile_details_bloc.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_schedule_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_visit_details_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/create_amc_report_screen.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/my_commissioning_screen.dart';
import 'package:service_app/src/features/notifications/presentation/pages/notification_screen.dart';
import 'package:service_app/src/features/report_history/presentation/pages/report_history_screen.dart';
import 'package:service_app/src/features/profile/presentation/pages/profile_screen.dart';
import 'package:service_app/src/features/reports/presentation/pages/create_report_screen.dart';
import 'package:service_app/src/features/service_calls/presentation/pages/service_calls_screen.dart';
import 'package:service_app/src/features/home/presentation/widgets/upcoming_amc_card.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_workflow_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UpcomingAmcBloc _upcomingAmcBloc;
  late ProfileDetailsBloc _profileDetailsBloc;

  @override
  void initState() {
    super.initState();
    _upcomingAmcBloc = getIt<UpcomingAmcBloc>()
      ..add(const UpcomingAmcGetEvent('Today'));
    _profileDetailsBloc = getIt<ProfileDetailsBloc>()
      ..add(const ProfileDetailsGetEvent());
  }

  @override
  void dispose() {
    _upcomingAmcBloc.close();
    _profileDetailsBloc.close();
    super.dispose();
  }

  late int _selectedIndex = widget.initialIndex;
  bool _showCreateReport = false;
  // ── Bottom nav tab labels & icons ─────────────────────────────────────────
  static const List<_NavItem> _navItems = [
    _NavItem(
      labelKey: 'home_nav_home',
      iconAsset: 'assets/icons/home_unselected_icon.png',
      activeIconAsset: 'assets/icons/home_selected_icon.png',
    ),
    _NavItem(
      labelKey: 'home_nav_commissioning',
      iconAsset: 'assets/icons/mycommissioning_unselected_icon.png',
      activeIconAsset: 'assets/icons/mycommissioning_selected_icon.png',
    ),
    _NavItem(
      labelKey: 'home_nav_service_calls',
      iconAsset: 'assets/icons/servicecalls_unselected_icon.png',
      activeIconAsset: 'assets/icons/servicecalls_selected_icon.png',
    ),
    _NavItem(
      labelKey: 'home_nav_reports',
      iconAsset: 'assets/icons/reporthistory_unselected_icon.png',
      activeIconAsset: 'assets/icons/reporthistory_selected_icon.png',
    ),
  ];

  bool _showSystemBars = true;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showCreateReport = false;
      _showSystemBars = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
            _showCreateReport = false;
            _showSystemBars = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSystemBars ? 155 : 0,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: Stack(
              children: [
                // ── Background + content ─────────────────────────────────────────
                Container(
                  height: 155,
                  color: const Color(0xFFE9F5FF),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 38,
                        left: 16,
                        right: 16,
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            // ── Logo ───────────────────────────────────────────
                            Image.asset(
                              'assets/images/logo_tightcrop.png',
                              width: 135,
                              fit: BoxFit.fill,
                            ),
                            const Spacer(),
                            // ── + button ───────────────────────────────────────
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                    _selectedIndex = 0;
                                    _showCreateReport = false;
                                    _showSystemBars = true;
                                  });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateReportScreen(
                                      onBack: () => Navigator.pop(context),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B68B9),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset('assets/icons/add_icon.png'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ── Notification ───────────────────────────────────
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NotificationScreen(
                                      onBack: () => Navigator.pop(context),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B68B9),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/icons/notification_icon.png',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ── Profile avatar ─────────────────────────────────
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                      onBack: () => Navigator.pop(context),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0B68B9),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset('assets/icons/profile_icon.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // ── Upper-left corner decoration ──────────────────────────────
                Positioned(
                  top: -35,
                  left: -47,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/icons/upper_left_corner_image.png',
                      height: 163,
                      width: 181,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // ── Upper-right corner decoration ─────────────────────────────
                Positioned(
                  top: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/icons/upper_right_corner_image.png',
                      height: 160,
                      width: 140,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showSystemBars ? 0 : MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: true,
              child: _buildCurrentView(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: _showSystemBars ? 1.0 : 0.0,
          child: SafeArea(
            top: false,
            child: _CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onTap: _onTabTapped,
              navItems: _navItems,
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildCurrentView() {
    Widget child;
    switch (_selectedIndex) {
      case 0:
        child = _buildHomeBody();
        break;
      case 1:
        child = const MyCommissioningScreen();
        break;
      case 2:
        child = const ServiceCallsScreen();
        break;
      case 3:
        child = const ReportHistoryScreen();
        break;
      default:
        child = _buildPlaceholder();
    }

    if (_selectedIndex == 1 || _selectedIndex == 2 || _selectedIndex == 3) {
      return NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            if (notification.metrics.pixels <= 0) {
              if (!_showSystemBars) setState(() => _showSystemBars = true);
            } else if (!notification.metrics.outOfRange && notification.scrollDelta != null) {
              if (notification.scrollDelta! > 2) {
                // User scrolls down the list (content goes up) -> hide bars
                if (_showSystemBars) setState(() => _showSystemBars = false);
              } else if (notification.scrollDelta! < -2) {
                // User scrolls up the list (content goes down) -> show bars
                if (!_showSystemBars) setState(() => _showSystemBars = true);
              }
            }
          }
          return false;
        },
        child: child,
      );
    }
    return child;
  }

  

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
            bloc: _profileDetailsBloc,
            builder: (context, state) {
              if (state is ProfileDetailsLoadingState ||
                  state is ProfileDetailsInitialState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 200,
                        height: 37,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 250,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                );
              }

              String name = 'home_greeting_name'.tr();
              String dealerName = '';
              if (state is ProfileDetailsSuccessState) {
                final data = state.data.data;
                if (data.name.isNotEmpty) {
                  name = data.name;
                }
                if (data.dealer.name.isNotEmpty) {
                  dealerName = data.dealer.name;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppFont.style(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'home_greeting_message'.tr(args: [dealerName]),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 36),
          // AMC Card
          UpcomingAmcCard(
            upcomingAmcBloc: _upcomingAmcBloc,
            onScheduleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AmcWorkflowScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        'home_placeholder'.tr(),
        style: AppFont.style(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 1:
        return 'commissioning_appbar_title'.tr();
      case 2:
        return 'service_calls_appbar_title'.tr();
      case 3:
        return 'reports_appbar_title'.tr();
      default:
        return 'home_appbar_title'.tr();
    }
  }
}

class _NavItem {
  final String labelKey;
  final String iconAsset;
  final String activeIconAsset;
  const _NavItem({
    required this.labelKey,
    required this.iconAsset,
    required this.activeIconAsset,
  });
}

class _CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> navItems;

  const _CustomBottomNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.navItems,
  });

  static const double _indicatorSize = 20;
  static const double _barHeight = 72;
  // shifts the whole tab group to the left by this many logical pixels
  static const double _groupShift = 24.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // pill width = screen width minus left (8) + right (8) padding
    final pillWidth = screenWidth - 16;
    // effective tab area is narrowed by _groupShift on the right → tabs move left
    final tabWidth = (pillWidth - _groupShift) / navItems.length;
    final indicatorLeft =
        tabWidth * selectedIndex + (tabWidth / 2) - (_indicatorSize / 2);

    return Container(
      // page background colour visible above the pill
      // color: const Color(0xFFE9F5FF),
      // top padding = half indicator height so it has room to overflow upward
      padding: EdgeInsets.fromLTRB(8, _indicatorSize / 2, 8, 12),
      child: Stack(
        clipBehavior: Clip.none, // allows indicator to float above the pill
        children: [
          // ── Blue pill ───────────────────────────────────────────────────
          Container(
            height: _barHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF0B68B9),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: _groupShift),
              child: Row(
                children: navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isActive = index == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // reserve space equal to half indicator so items
                          // are vertically centred inside the pill
                          const SizedBox(height: _indicatorSize / 2),
                          // ── icon ───────────────────────────────────────────
                          Image.asset(
                            isActive ? item.activeIconAsset : item.iconAsset,
                            width: 24,
                            height: 24,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.55),
                          ),
                          const SizedBox(height: 4),
                          // ── label ──────────────────────────────────────────
                          Text(
                            item.labelKey.tr(),
                            style: AppFont.style(
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.55),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Half-overflow selected indicator ────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: indicatorLeft,
            // top: 0 means the centre of the image sits on the top edge →
            // half above the pill, half inside
            top: -(_indicatorSize / 2),
            child: IgnorePointer(
              child: Image.asset(
                'assets/icons/selected_item_icon.png',
                width: _indicatorSize,
                height: _indicatorSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}