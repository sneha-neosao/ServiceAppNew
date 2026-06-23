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
import 'package:service_app/src/features/my_commissioning/presentation/pages/add_commissioning_screen.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_list_bloc/commissioning_work_list_bloc.dart';
import 'package:service_app/src/features/notifications/presentation/pages/notification_screen.dart';
import 'package:service_app/src/features/report_history/presentation/pages/report_history_screen.dart';
import 'package:service_app/src/features/profile/presentation/pages/profile_screen.dart';
import 'package:service_app/src/features/reports/presentation/pages/create_report_screen.dart';
import 'package:service_app/src/features/service_calls/presentation/pages/service_calls_screen.dart';
import 'package:service_app/src/features/home/presentation/widgets/upcoming_amc_card.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_workflow_screen.dart';
import 'package:service_app/src/core/services/notification_service.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/features/notifications/bloc/fcm_register_bloc/fcm_register_bloc.dart';
import 'package:service_app/src/features/notifications/bloc/fcm_register_bloc/fcm_register_event.dart';
import 'package:service_app/src/features/home/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:service_app/src/features/home/bloc/app_settings_bloc/app_settings_state.dart';
import 'package:service_app/src/features/home/bloc/app_settings_bloc/app_settings_event.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:service_app/src/features/login/bloc/auth_login_bloc/login_bloc.dart';
import 'package:service_app/src/features/notifications/bloc/unread_count_bloc/unread_count_bloc.dart';
import 'package:service_app/src/features/notifications/bloc/unread_count_bloc/unread_count_event.dart';
import 'package:go_router/go_router.dart';
import 'package:service_app/src/routes/app_route_path.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UpcomingAmcBloc _upcomingAmcBloc;
  late ProfileDetailsBloc _profileDetailsBloc;
  late FcmRegisterBloc _fcmRegisterBloc;
  late AppSettingsBloc _appSettingsBloc;
  late UnreadCountBloc _unreadCountBloc;

  @override
  void initState() {
    super.initState();
    _upcomingAmcBloc = getIt<UpcomingAmcBloc>()
      ..add(const UpcomingAmcGetEvent('Today'));
    _profileDetailsBloc = getIt<ProfileDetailsBloc>()
      ..add(const ProfileDetailsGetEvent());
    _fcmRegisterBloc = getIt<FcmRegisterBloc>();
    _appSettingsBloc = getIt<AppSettingsBloc>()
      ..add(const GetAppSettingsEvent());
    _unreadCountBloc = getIt<UnreadCountBloc>()
      ..add(const GetUnreadNotificationCountEvent());
    _checkAndRegisterFcmToken();
  }



  Future<void> _checkAndRegisterFcmToken() async {
    final String? newToken = await NoficationService.getToken();
    if (newToken != null && newToken.isNotEmpty) {
      final String? savedToken = await SessionManager.getFirebaseToken();
      if (savedToken != newToken) {
        _fcmRegisterBloc.add(FcmRegisterTriggerEvent(fcmToken: newToken));
        await SessionManager.saveFirebaseToken(newToken);
      }
    }
  }

  @override
  void dispose() {
    _upcomingAmcBloc.close();
    _profileDetailsBloc.close();
    _fcmRegisterBloc.close();
    _appSettingsBloc.close();
    _unreadCountBloc.close();
    super.dispose();
  }

  late int _selectedIndex = widget.initialIndex;
  bool _showCreateReport = false;
  // ── Bottom nav tab labels & icons ─────────────────────────────────────────
  List<_NavItem> get _currentNavItems {
    List<_NavItem> items = [
      const _NavItem(
        labelKey: 'home_nav_home',
        iconAsset: 'assets/icons/home_unselected_icon.png',
        activeIconAsset: 'assets/icons/home_selected_icon.png',
        originalIndex: 0,
      ),
    ];
    List<String> perms = [];
    if (_profileDetailsBloc.state is ProfileDetailsSuccessState) {
      perms = (_profileDetailsBloc.state as ProfileDetailsSuccessState).data.data.permissions;
    } else {
      // Default to all if not loaded yet, or you can default to none
      perms = ['commissioning_work', 'service_calls', 'amcs'];
    }

    if (perms.contains('commissioning_work')) {
      items.add(const _NavItem(
        labelKey: 'home_nav_commissioning',
        iconAsset: 'assets/icons/mycommissioning_unselected_icon.png',
        activeIconAsset: 'assets/icons/mycommissioning_selected_icon.png',
        originalIndex: 1,
      ));
    }

    if (perms.contains('service_calls')) {
      items.add(const _NavItem(
        labelKey: 'home_nav_service_calls',
        iconAsset: 'assets/icons/servicecalls_unselected_icon.png',
        activeIconAsset: 'assets/icons/servicecalls_selected_icon.png',
        originalIndex: 2,
      ));
    }

    items.add(const _NavItem(
      labelKey: 'home_nav_reports',
      iconAsset: 'assets/icons/reporthistory_unselected_icon.png',
      activeIconAsset: 'assets/icons/reporthistory_selected_icon.png',
      originalIndex: 3,
    ));

    return items;
  }

  bool _showSystemBars = true;
  final GlobalKey<MyCommissioningScreenState> _myCommissioningKey = GlobalKey<MyCommissioningScreenState>();

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showCreateReport = false;
      _showSystemBars = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppSettingsBloc, AppSettingsState>(
          bloc: _appSettingsBloc,
      listener: (context, state) async {
        if (state is AppSettingsSuccess) {
          try {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            final storeVersion = packageInfo.version;

            String? currentVersion;
            bool isCompulsory = false;
            String? updateMessage;
            String? link;

            if (Platform.isAndroid) {
              currentVersion = state.data.data?.androidApp?.version;
              isCompulsory = state.data.data?.androidApp?.forceUpdate ?? false;
              updateMessage = state.data.data?.androidApp?.updateMessage;
              link = state.data.data?.androidApp?.playStoreLink;
            } else if (Platform.isIOS) {
              currentVersion = state.data.data?.iosApp?.version;
              isCompulsory = state.data.data?.iosApp?.forceUpdate ?? false;
              updateMessage = state.data.data?.iosApp?.updateMessage;
              link = state.data.data?.iosApp?.appStoreLink;
            }

            if (currentVersion != null && currentVersion != storeVersion) {
              _updateWarningDialog(
                context,
                message: updateMessage ?? "new_version_is_available".tr(),
                isCompulsory: isCompulsory,
                link: link,
              );
            }
          } catch (e) {
            print("Error fetching installed version: $e");
          }
        }
      },
    ),
    BlocListener<ProfileDetailsBloc, ProfileDetailsState>(
      bloc: _profileDetailsBloc,
      listener: (context, state) {
        if (state is ProfileDetailsSuccessState) {
          final profileData = state.data;
          if (profileData.status == 300) {
            _maintenanceWarningDialog(context,
                message: profileData.message ?? "Account issue");
          }
        }
      },
    ),
  ],
  child: PopScope(
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
      child: BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
        bloc: _profileDetailsBloc,
        builder: (context, state) {
          final currentItems = _currentNavItems;
          final int originalIndex = (currentItems.isNotEmpty && _selectedIndex < currentItems.length)
              ? currentItems[_selectedIndex].originalIndex
              : 0;

          return Stack(
            children: [
              Scaffold(
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
                                ).then((_) {
                                  // Refresh count after returning from notifications
                                  _unreadCountBloc.add(
                                    const GetUnreadNotificationCountEvent(),
                                  );
                                });
                              },
                              child: BlocBuilder<UnreadCountBloc, UnreadCountState>(
                                bloc: _unreadCountBloc,
                                builder: (context, state) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0B68B9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                      if (state is UnreadCountLoading)
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        )
                                      else if (state is UnreadCountLoaded &&
                                          state.unreadCount > 0)
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                state.unreadCount > 99
                                                    ? '99+'
                                                    : '${state.unreadCount}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
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
                                child: state is ProfileDetailsLoadingState || state is ProfileDetailsInitialState
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person_outline,
                                        color: Colors.white,
                                        size: 26,
                                      ),
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
      bottomNavigationBar: state is ProfileDetailsLoadingState || state is ProfileDetailsInitialState
          ? AnimatedSize(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _showSystemBars ? 1.0 : 0.0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : AnimatedSize(
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
                    navItems: _currentNavItems,
                  ),
                ),
              ),
            ),
          ),
          if (originalIndex == 1)
            Positioned(
              bottom: 146,
              right: 22,
              child: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCommissioningScreen(onBack: () => Navigator.pop(context)),
                    ),
                  );
                  _myCommissioningKey.currentState?.refreshList();
                },
                backgroundColor: const Color(0xFF0B68B9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ],
        );
        },
      ),
    ),
    );
  }

  void _updateWarningDialog(BuildContext context,
      {required String message, required bool isCompulsory, String? link}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "app_update".tr(),
                    style: AppFont.style(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF424B5C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (!isCompulsory) {
                        Navigator.of(dialogContext).pop(false);
                      }
                      if (link != null && link.isNotEmpty) {
                        launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF0B68B9),
                      ),
                      child: Center(
                        child: Text(
                          "update_now".tr(),
                          style: AppFont.style(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!isCompulsory)
                    GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                        ),
                        child: Center(
                          child: Text(
                            "cancel".tr(),
                            style: AppFont.style(
                              fontSize: 14,
                              color: const Color(0xFF1A1A1A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _maintenanceWarningDialog(BuildContext context, {required String message}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => getIt<AuthLoginBloc>(),
          child: BlocListener<AuthLoginBloc, AuthLoginState>(
            listener: (loginContext, state) {
              if (state is AuthLogoutSuccessState) {
                final nav = Navigator.of(loginContext, rootNavigator: true);
                final router = GoRouter.of(loginContext);
                
                nav.pop(); // close dialog
                router.goNamed(AppRoute.loginScreen.name);
              }
            },
            child: PopScope(
              canPop: false,
              child: Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Icon ───────────────────────────────────────────────────────
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF1F0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          color: Color(0xFFFF4D4F),
                          size: 32,
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // ── Title ───────────────────────────────────────────────────────
                      Text(
                        'maintenance_mode'.tr(),
                        style: AppFont.style(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D121F),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Subtitle ────────────────────────────────────────────────────
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5C616E),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Buttons ─────────────────────────────────────────────────────
                      Row(
                        children: [
                          // Exit Button
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  SystemNavigator.pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFF6F6F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'exit'.tr(),
                                    maxLines: 1,
                                    style: AppFont.style(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0D121F),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Log Out Button
                          Expanded(
                            child: BlocBuilder<AuthLoginBloc, AuthLoginState>(
                              builder: (loginContext, state) {
                                final isLoading = state is AuthLogoutLoadingState;
                                return SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            loginContext.read<AuthLoginBloc>().add(AuthLogoutEvent());
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0B68B9),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'logout_dialog_btn_confirm'.tr(),
                                              maxLines: 1,
                                              style: AppFont.style(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
        );
      },
    );
  }

  Widget _buildCurrentView() {
    final currentItems = _currentNavItems;
    if (_selectedIndex >= currentItems.length) {
      _selectedIndex = 0; // fallback
    }
    final originalIndex = currentItems.isNotEmpty ? currentItems[_selectedIndex].originalIndex : 0;

    List<String> perms = [];
    if (_profileDetailsBloc.state is ProfileDetailsSuccessState) {
      perms = (_profileDetailsBloc.state as ProfileDetailsSuccessState).data.data.permissions;
    } else {
      perms = ['commissioning_work', 'service_calls', 'amcs'];
    }

    Widget child;
    switch (originalIndex) {
      case 0:
        child = _buildHomeBody();
        break;
      case 1:
        child = MyCommissioningScreen(key: _myCommissioningKey);
        break;
      case 2:
        child = const ServiceCallsScreen();
        break;
      case 3:
        child = ReportHistoryScreen(permissions: perms);
        break;
      default:
        child = _buildPlaceholder();
    }

    if (originalIndex == 1 || originalIndex == 2 || originalIndex == 3) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        return RefreshIndicator(
          color: const Color(0xFF0B68B9),
          onRefresh: () async {
            _upcomingAmcBloc.add(const UpcomingAmcGetEvent('Today'));
            _profileDetailsBloc.add(const ProfileDetailsGetEvent());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
                  bloc: _profileDetailsBloc,
                  builder: (context, state) {
                    if (state is ProfileDetailsLoadingState ||
                        state is ProfileDetailsInitialState) {
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 200,
                              height: 37,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(8),
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
                                borderRadius:
                                BorderRadius.circular(8),
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
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: AppFont.style(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getGreetingMessage()
                              .tr(args: [dealerName]),
                          style: AppFont.style(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: screenHeight / 5),

                // AMC Card
                if (_profileDetailsBloc.state is ProfileDetailsSuccessState && (_profileDetailsBloc.state as ProfileDetailsSuccessState).data.data.permissions.contains('amcs'))
                  UpcomingAmcCard(
                    upcomingAmcBloc: _upcomingAmcBloc,
                    onScheduleTap: () {
                      String initialFilter = 'Today';
                      if (_upcomingAmcBloc.state is UpcomingAmcSuccessState) {
                        final f = (_upcomingAmcBloc.state as UpcomingAmcSuccessState).data.data?.filter;
                        if (f != null && f.isNotEmpty) {
                          initialFilter = f[0].toUpperCase() + f.substring(1).toLowerCase();
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AmcWorkflowScreen(initialFilter: initialFilter),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        );
      },
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
    final currentItems = _currentNavItems;
    final originalIndex = currentItems.isNotEmpty ? currentItems[_selectedIndex].originalIndex : 0;
    switch (originalIndex) {
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

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greetingMorning';
    if (hour < 17) return 'greetingAfternoon';
    if (hour < 21) return 'greetingEvening';
    return 'greetingNight';
  }
}

class _NavItem {
  final String labelKey;
  final String iconAsset;
  final String activeIconAsset;
  final int originalIndex;
  const _NavItem({
    required this.labelKey,
    required this.iconAsset,
    required this.activeIconAsset,
    required this.originalIndex,
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
                            width: 20,
                            height: 20,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.55),
                          ),
                          const SizedBox(height: 4),
                          // ── label ──────────────────────────────────────────
                          Text(
                            item.labelKey.tr(),
                            style: AppFont.style(
                              fontSize: 10,
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