import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/profile/widgets/profile_dialogs.dart';
import 'package:service_app/src/features/profile/widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  const ProfileScreen({super.key, required this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English';

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(32, 32, 32, MediaQuery.of(context).viewInsets.bottom + 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'profile_language_title'.tr(),
                            style: AppFont.style(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                          ),
                          Text(
                            'profile_language_subtitle'.tr(),
                            style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFF8F9FB), shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 20, color: Color(0xFFA5ABB7)),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLanguageOption('ENGLISH', setModalState),
                          const SizedBox(height: 16),
                          _buildLanguageOption('MARATHI', setModalState),
                          const SizedBox(height: 16),
                          _buildLanguageOption('HINDI', setModalState),
                          const SizedBox(height: 16),
                          _buildLanguageOption('GUJARATI', setModalState),
                          const SizedBox(height: 16),
                          _buildLanguageOption('KANNADA', setModalState),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageOption(String lang, StateSetter setModalState) {
    bool isSelected = _selectedLanguage.toUpperCase() == lang;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _selectedLanguage = lang[0] + lang.substring(1).toLowerCase();
        });
        setState(() {
          _selectedLanguage = lang[0] + lang.substring(1).toLowerCase();
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) Navigator.pop(context);
        });
      },
      child: Container(
        width: double.infinity,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFF1F2F6),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang,
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF8E9BAE),
              ),
            ),
            if (isSelected)
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: Color(0xFF1565C0), shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 18, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ProfileLogoutDialog();
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ProfileDeleteDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFA5ABB7)),
                        onPressed: widget.onBack,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'profile_title'.tr(),
                        style: AppFont.style(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Profile Details Section ──────────────────────────────────────
            ProfileSectionHeader(title: 'profile_details_section'.tr()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F2F6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar & Name Row
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                'https://api.dicebear.com/7.x/avataaars/png?seed=Pravin',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pravin Patil',
                                  style: AppFont.style(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.badge_outlined, size: 14, color: Color(0xFFA5ABB7)),
                                      const SizedBox(width: 6),
                                      Text(
                                        'ID: T-4491',
                                        style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                    // Company Info
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'MS',
                                    style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF1565C0)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mainten Systems Pvt Ltd',
                                      style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'profile_verified_provider'.tr(),
                                          style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          ProfileInfoItem(icon: Icons.location_on_outlined, label: 'profile_office_address'.tr(), value: '123, Industrial Area, Phase II, Pune - 411013'),
                          const SizedBox(height: 24),
                          ProfileInfoItem(icon: Icons.phone_outlined, label: 'profile_support_line'.tr(), value: '+91 20 2233 4455'),
                          const SizedBox(height: 24),
                          ProfileInfoItem(icon: Icons.verified_user_outlined, label: 'profile_tax_id'.tr(), value: '27AAACM1234A1Z5'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Preferences Section ──────────────────────────────────────────
            ProfileSectionHeader(title: 'profile_preferences_section'.tr()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _showLanguageBottomSheet,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F2F6)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.language, color: Colors.orange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'profile_choose_language'.tr(),
                              style: AppFont.style(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                            ),
                            Text(
                              _selectedLanguage,
                              style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF1565C0)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFFF1F2F6)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Security Section ─────────────────────────────────────────────
            ProfileSectionHeader(title: 'profile_security_section'.tr()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileActionButton(icon: Icons.logout, label: 'profile_btn_logout'.tr(), bgColor: const Color(0xFFF8F9FB), textColor: const Color(0xFF8E9BAE), onTap: _showLogoutDialog),
                  const SizedBox(height: 16),
                  ProfileActionButton(icon: Icons.delete_outline, label: 'profile_btn_delete'.tr(), bgColor: const Color(0xFFFFEBEE), textColor: const Color(0xFFE53935), onTap: _showDeleteDialog),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

}
