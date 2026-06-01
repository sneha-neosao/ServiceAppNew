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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _AmcViewState { dashboard, schedule, details, createReport }

class _HomeScreenState extends State<HomeScreen> {
  late UpcomingAmcBloc _upcomingAmcBloc;
  late ProfileDetailsBloc _profileDetailsBloc;

  @override
  void initState() {
    super.initState();
    _upcomingAmcBloc = getIt<UpcomingAmcBloc>()..add(const UpcomingAmcGetEvent('Today'));
    _profileDetailsBloc = getIt<ProfileDetailsBloc>()..add(const ProfileDetailsGetEvent());
  }

  @override
  void dispose() {
    _upcomingAmcBloc.close();
    _profileDetailsBloc.close();
    super.dispose();
  }

  int _selectedIndex = 0;
  bool _showNotifications = false;
  bool _showCreateReport = false;
  bool _showProfile = false;
  _AmcViewState _amcViewState = _AmcViewState.dashboard;
  int _amcReportsCreated = 0;

  // Selected AMC Item Data
  String? _selectedAmcTitle;
  String? _selectedAmcLocation;
  String? _selectedAmcVisitInfo;
  String? _selectedAmcWindow;

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

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _amcViewState = _AmcViewState.dashboard;
      _amcReportsCreated = 0;
      _showNotifications = false;
      _showCreateReport = false;
      _showProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(155),
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
                              _amcViewState = _AmcViewState.dashboard;
                              _amcReportsCreated = 0;
                              _showNotifications = false;
                              _showProfile = false;
                              _showCreateReport = false;
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
                          onTap: () => setState(() {
                            _showNotifications = true;
                            _showCreateReport = false;
                            _showProfile = false;
                          }),
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
                          onTap: () => setState(() {
                            _showProfile = true;
                            _showNotifications = false;
                            _showCreateReport = false;
                          }),
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
      body: _buildCurrentView(),
      bottomNavigationBar: SafeArea(
        top: false,
        child: _CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onTabTapped,
          navItems: _navItems,
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_showNotifications) {
      return NotificationScreen(
        onBack: () => setState(() => _showNotifications = false),
      );
    }
    if (_showProfile) {
      return ProfileScreen(onBack: () => setState(() => _showProfile = false));
    }

    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const MyCommissioningScreen();
      case 2:
        return const ServiceCallsScreen();
      case 3:
        return const ReportHistoryScreen();
      default:
        return _buildPlaceholder();
    }
  }

  Widget _buildHomeTab() {
    switch (_amcViewState) {
      case _AmcViewState.details:
        return AmcVisitDetailsScreen(
          title: _selectedAmcTitle ?? '',
          location: _selectedAmcLocation ?? '',
          visitInfo: _selectedAmcVisitInfo ?? '',
          window: _selectedAmcWindow ?? '',
          reportsCreated: _amcReportsCreated,
          onBack: () => setState(() => _amcViewState = _AmcViewState.schedule),
          onSubmit: () =>
              setState(() => _amcViewState = _AmcViewState.createReport),
          onCompleteAmcWork: () {
            setState(() {
              _amcViewState = _AmcViewState.dashboard;
              _amcReportsCreated = 0;
            });
          },
        );
      case _AmcViewState.createReport:
        return CreateAmcReportScreen(
          onBack: () => setState(() => _amcViewState = _AmcViewState.details),
          onSubmit: () => setState(() {
            _amcReportsCreated++;
            _amcViewState = _AmcViewState.details;
          }),
        );
      case _AmcViewState.schedule:
        return AmcScheduleScreen(
          onBack: () => setState(() => _amcViewState = _AmcViewState.dashboard),
          onItemTap: (title, location, visitInfo, window) {
            setState(() {
              _selectedAmcTitle = title;
              _selectedAmcLocation = location;
              _selectedAmcVisitInfo = visitInfo;
              _selectedAmcWindow = window;
              _amcReportsCreated = 0;
              _amcViewState = _AmcViewState.details;
            });
          },
        );
      case _AmcViewState.dashboard:
        return _buildHomeBody();
    }
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
              if (state is ProfileDetailsLoadingState || state is ProfileDetailsInitialState) {
                return Shimmer.fromColors(
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
                );
              }

              String name = 'home_greeting_name'.tr();
              if (state is ProfileDetailsSuccessState) {
                final data = state.data.data;
                if (data != null && data.name.isNotEmpty) {
                  name = data.name;
                }
              }

              return Text(
                name,
                style: AppFont.style(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            'home_greeting_message'.tr(),
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 36),
          // AMC Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC2E2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        color: Color(0xFF0B68B9),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'home_amc_card_title'.tr(),
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    _DropdownPill(
                      label: 'home_amc_card_dropdown'.tr(),
                      onChanged: (val) {
                        _upcomingAmcBloc.add(UpcomingAmcGetEvent(val));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2E2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<UpcomingAmcBloc, UpcomingAmcState>(
                            bloc: _upcomingAmcBloc,
                            builder: (context, state) {
                              if (state is UpcomingAmcLoadingState) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              } else if (state is UpcomingAmcSuccessState) {
                                return Text(
                                  '${state.data.data?.total ?? 0}',
                                  style: AppFont.style(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0B68B9),
                                  ),
                                );
                              }
                              return Text(
                                '0',
                                style: AppFont.style(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0B68B9),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'home_amc_total_label'.tr(),
                            style: AppFont.style(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0B68B9),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => setState(
                          () => _amcViewState = _AmcViewState.schedule,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF0B68B9),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class _DropdownPill extends StatefulWidget {
  final String label;
  final ValueChanged<String>? onChanged;
  const _DropdownPill({required this.label, this.onChanged});
  @override
  State<_DropdownPill> createState() => _DropdownPillState();
}

class _DropdownPillState extends State<_DropdownPill> {
  late String _selectedLabel;
  final List<String> _options = ['Today', 'Tomorrow', 'Week', 'Month'];
  @override
  void initState() {
    super.initState();
    _selectedLabel = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      onSelected: (val) {
        setState(() => _selectedLabel = val);
        if (widget.onChanged != null) {
          widget.onChanged!(val);
        }
      },
      offset: const Offset(0, 45),
      itemBuilder: (ctx) => _options
          .map((opt) => PopupMenuItem(value: opt, child: Text(opt, style: AppFont.style(color: Colors.black))))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCFD8DC)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedLabel,
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF455A64),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Color(0xFF90A4AE),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom bottom nav bar ──────────────────────────────────────────────────────
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
