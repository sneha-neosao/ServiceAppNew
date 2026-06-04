import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/profile/bloc/profile_details_bloc/profile_details_bloc.dart';
import 'package:service_app/src/features/profile/widgets/profile_dialogs.dart';
import 'package:service_app/src/remote/models/profile_details_model/profile_details_model.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  const ProfileScreen({super.key, required this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false;
  bool _pushNotifications = false;
  String _selectedLanguage = 'English';

  // ── Language bottom sheet ──────────────────────────────────────────────────
  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModal) {
            Widget option(String lang) {
              final isSelected = _selectedLanguage.toUpperCase() == lang;
              return GestureDetector(
                onTap: () {
                  final formatted = lang[0] + lang.substring(1).toLowerCase();
                  setModal(() {});
                  setState(() => _selectedLanguage = formatted);
                  Future.delayed(const Duration(milliseconds: 180), () {
                    if (mounted) Navigator.pop(ctx);
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0B68B9)
                          : const Color(0xFFF1F2F6),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang,
                        style: AppFont.style(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF0B68B9)
                              : const Color(0xFF8E9BAE),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0B68B9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(ctx).viewInsets.bottom + 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'profile_language_title'.tr(),
                        style: AppFont.style(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFFA5ABB7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  for (final l in [
                    'ENGLISH',
                    'MARATHI',
                    'HINDI',
                    'GUJARATI',
                    'KANNADA',
                  ])
                    option(l),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ProfileLogoutDialog(),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ProfileDeleteDialog(),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileDetailsBloc>()..add(const ProfileDetailsGetEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FA),
        body: BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
          builder: (context, state) {
            final data = state is ProfileDetailsSuccessState
                ? state.data.data
                : null;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Blue header ────────────────────────────────────────────
                  _buildHeader(data),

                  const SizedBox(height: 16),

                  // ── API error banner ───────────────────────────────────────
                  if (state is ProfileDetailsFailureState)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade400,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.message,
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── Contact ──────────────────────────────────────────────────
                  _sectionLabel('Contact'),
                  _infoCard(
                    children: [
                      _contactRow(
                        "assets/icons/call_icon.png",
                        'Mobile',
                        data?.phone ?? '—',
                      ),
                      // _divider(),
                      // _contactRow("assets/icons/mail_icon.png", 'Email', data?.email ?? '—'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Employer ─────────────────────────────────────────────────
                  _sectionLabel('Dealer'),
                  _employerCard(data),

                  const SizedBox(height: 20),

                  _sectionLabel('Choose Language'),
                  _infoCard(
                    children: [
                      _prefRow(
                        "assets/icons/language.png",
                        'Language',
                        _selectedLanguage,
                        onTap: _showLanguageBottomSheet,
                      ),
                      // _divider(),
                      // _prefToggleRow(
                      //   Icons.dark_mode_outlined,
                      //   'Dark mode',
                      //   'Easier on the eyes at night',
                      //   _darkMode,
                      //   (v) => setState(() => _darkMode = v),
                      // ),
                      // _divider(),
                      // _prefToggleRow(
                      //   Icons.notifications_outlined,
                      //   'Push notifications',
                      //   'Job assignments & alerts',
                      //   _pushNotifications,
                      //   (v) => setState(() => _pushNotifications = v),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Security & session ────────────────────────────────────────
                  _sectionLabel('Security & session'),
                  _infoCard(
                    children: [
                      _actionRow(
                        "assets/icons/logout_icon.png",
                        'Logout',
                        onTap: _showLogoutDialog,
                      ),
                      _divider(),
                      _actionRow(
                        "assets/icons/accountdelete_icon.png",
                        'Delete Account',
                        textColor: Colors.red,
                        onTap: _showDeleteDialog,
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Header widget ──────────────────────────────────────────────────────────
  Widget _buildHeader(ProfileData? data) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Blue gradient bg
        Container(
          height: 140,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/profile_bg_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            bottom: false,
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back arrow
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Color(0xFF5C616E),
                        ),
                        onPressed: widget.onBack,
                      ),
                    ),
                  ),
                  // Title centred
                  Text(
                    'My Profile',
                    style: AppFont.style(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Profile card — floats half out of the header
        Positioned(
          left: 16,
          right: 16,
          top: 105,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC2E2FE), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B68B9),
                    shape: BoxShape.circle,
                    // border: Border.all(color: const Color(0xFF0B68B9), width: 2),
                  ),
                  child: Image.asset("assets/icons/profile_icon.png"),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data?.name ?? '—',
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 13,
                          color: Color(0xFFA5ABB7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data != null ? 'ID: ${data.code}' : '—',
                          style: AppFont.style(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Space the Stack so the floating card doesn't get clipped
        const SizedBox(height: 180),
      ],
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────
  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Text(
        title,
        style: AppFont.style(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0D121F),
        ),
      ),
    );
  }

  // ── White rounded card ─────────────────────────────────────────────────────
  Widget _infoCard({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC2E2FE), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    thickness: 1,
    indent: 16,
    endIndent: 16,
    color: Color(0xFFF1F2F6),
  );

  // ── Contact row ────────────────────────────────────────────────────────────
  Widget _contactRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF0B68B9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Image.asset(icon),
            ),
          ),
          const SizedBox(width: 14),

          // FIX
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFont.style(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D121F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Employer card (blue bg) ────────────────────────────────────────────────
  Widget _employerCard(ProfileData? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B68B9).withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Blue company name row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF0B68B9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    child: Image.asset("assets/icons/dealer_icon.png"),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      data?.dealer.name.isNotEmpty == true
                          ? data!.dealer.name
                          : '—',
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // White rows below
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  left: BorderSide(color: Color(0xFFC2E2FE), width: 1),
                  right: BorderSide(color: Color(0xFFC2E2FE), width: 1),
                  bottom: BorderSide(color: Color(0xFFC2E2FE), width: 1),
                ),
              ),
              child: Column(
                children: [
                  _contactRow(
                    "assets/icons/dealercode_icon.png",
                    'Dealer code',
                    data?.dealer.code.isNotEmpty == true
                        ? data!.dealer.code
                        : '—',
                  ),
                  // _divider(),
                  // _contactRow("assets/icons/mail_icon.png", 'Support line', '+91 20 2233 4455'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Preference tap row ─────────────────────────────────────────────────────
  Widget _prefRow(
    String icon,
    String label,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF0B68B9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Image.asset(icon),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0B68B9),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Preference toggle row ──────────────────────────────────────────────────
  Widget _prefToggleRow(
    IconData icon,
    String label,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F0FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF0B68B9)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0B68B9),
                  ),
                ),
                Text(
                  subtitle,
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0B68B9),
          ),
        ],
      ),
    );
  }

  // ── Action row (logout / delete) ───────────────────────────────────────────
  Widget _actionRow(
    String icon,
    String label, {
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final color = textColor ?? const Color(0xFF0B68B9);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Color(0xFF0B68B9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Image.asset(icon),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
