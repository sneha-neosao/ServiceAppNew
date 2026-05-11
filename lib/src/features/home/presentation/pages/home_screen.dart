import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_schedule_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_visit_details_screen.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/my_commissioning_screen.dart';
import 'package:service_app/src/features/notifications/presentation/pages/notification_screen.dart';
import 'package:service_app/src/features/report_history/presentation/pages/report_history_screen.dart';
import 'package:service_app/src/features/reports/presentation/pages/create_report_screen.dart';
import 'package:service_app/src/features/service_calls/presentation/pages/service_calls_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _AmcViewState { dashboard, schedule, details }

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showNotifications = false;
  bool _showCreateReport = false;
  _AmcViewState _amcViewState = _AmcViewState.dashboard;

  // Selected AMC Item Data
  String? _selectedAmcTitle;
  String? _selectedAmcLocation;
  String? _selectedAmcVisitInfo;
  String? _selectedAmcWindow;

  // ── Bottom nav tab labels & icons ─────────────────────────────────────────
  static const List<_NavItem> _navItems = [
    _NavItem(labelKey: 'home_nav_home', icon: Icons.home_outlined, activeIcon: Icons.home),
    _NavItem(labelKey: 'home_nav_commissioning', icon: Icons.work_outline, activeIcon: Icons.work),
    _NavItem(labelKey: 'home_nav_service_calls', icon: Icons.phone_in_talk_outlined, activeIcon: Icons.phone_in_talk),
    _NavItem(labelKey: 'home_nav_reports', icon: Icons.insert_drive_file_outlined, activeIcon: Icons.insert_drive_file),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _amcViewState = _AmcViewState.dashboard;
      _showNotifications = false;
      _showCreateReport = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          _showNotifications
              ? 'notif_appbar_title'.tr()
              : _showCreateReport
                  ? 'create_report_appbar_title'.tr()
                  : _getAppBarTitle(),
          style: AppFont.style(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D121F),
          ),
        ),
        actions: [
          // ── + blue button ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showCreateReport = true;
                });
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),

          // ── Bell with notification dot ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _showNotifications = true;
                });
              },
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF1A1A1A),
                      size: 22,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5722),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Avatar ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8E8E8)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: const Icon(
                  Icons.person,
                  size: 28,
                  color: Color(0xFF5C6BC0),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────
      body: _showNotifications
          ? NotificationScreen(onBack: () => setState(() => _showNotifications = false))
          : _showCreateReport
              ? CreateReportScreen(onBack: () => setState(() => _showCreateReport = false))
              : _selectedIndex == 0
          ? (_amcViewState == _AmcViewState.details
              ? AmcVisitDetailsScreen(
                  title: _selectedAmcTitle ?? '',
                  location: _selectedAmcLocation ?? '',
                  visitInfo: _selectedAmcVisitInfo ?? '',
                  window: _selectedAmcWindow ?? '',
                  onBack: () => setState(() => _amcViewState = _AmcViewState.schedule),
                )
              : _amcViewState == _AmcViewState.schedule
                  ? AmcScheduleScreen(
                      onBack: () => setState(() => _amcViewState = _AmcViewState.dashboard),
                      onItemTap: (title, location, visitInfo, window) {
                        setState(() {
                          _selectedAmcTitle = title;
                          _selectedAmcLocation = location;
                          _selectedAmcVisitInfo = visitInfo;
                          _selectedAmcWindow = window;
                          _amcViewState = _AmcViewState.details;
                        });
                      },
                    )
                  : _buildHomeBody())
          : _selectedIndex == 1
              ? const MyCommissioningScreen()
              : _selectedIndex == 2
                  ? const ServiceCallsScreen()
                  : _selectedIndex == 3
                      ? const ReportHistoryScreen()
                      : _buildPlaceholder(),

      // ── Bottom Navigation Bar ─────────────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1565C0),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedLabelStyle: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          items: _navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.activeIcon),
              label: item.labelKey.tr(),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Home tab body ─────────────────────────────────────────────────────────
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Name
          Text(
            'home_greeting_name'.tr(),
            style: AppFont.style(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),

          // Greeting
          Text(
            'home_greeting_message'.tr(),
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 24),

          // ── AMC Card ────────────────────────────────────────────────────
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
                // Card header row
                Row(
                  children: [
                    // Icon container
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        color: Color(0xFFD4870A),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title
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

                    // Month dropdown
                    _DropdownPill(label: 'home_amc_card_dropdown'.tr()),
                  ],
                ),

                const SizedBox(height: 20),

                // Stats row
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2',
                            style: AppFont.style(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFD4870A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'home_amc_total_label'.tr(),
                            style: AppFont.style(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD4870A),
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _amcViewState = _AmcViewState.schedule;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFD4870A),
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


  // ── Placeholder for other tabs ─────────────────────────────────────────
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

// ── Helper data class ─────────────────────────────────────────────────────────
class _NavItem {
  final String labelKey;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
  });
}

// ── Month dropdown pill ───────────────────────────────────────────────────────
class _DropdownPill extends StatefulWidget {
  final String label;
  const _DropdownPill({required this.label});

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
      onSelected: (String value) {
        setState(() {
          _selectedLabel = value;
        });
      },
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (BuildContext context) {
        return _options.map((String option) {
          bool isSelected = option == _selectedLabel;
          return PopupMenuItem<String>(
            value: option,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isSelected ? const Color(0xFF757575) : Colors.transparent,
              child: Text(
                option,
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ),
          );
        }).toList();
      },
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


