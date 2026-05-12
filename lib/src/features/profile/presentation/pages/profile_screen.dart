import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

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
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: Color(0xFFF8F9FB), shape: BoxShape.circle),
                  child: const Icon(Icons.logout, size: 32, color: Color(0xFF1565C0)),
                ),
                const SizedBox(height: 24),
                Text(
                  'logout_dialog_title'.tr(),
                  style: AppFont.style(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
                ),
                const SizedBox(height: 12),
                Text(
                  'logout_dialog_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7), letterSpacing: 0.5),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle logout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      'logout_dialog_btn_confirm'.tr(),
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F9FB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'logout_dialog_btn_cancel'.tr(),
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF8E9BAE)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(color: Color(0xFFFFF1F0), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline, size: 32, color: Color(0xFFF44336)),
                ),
                const SizedBox(height: 24),
                Text(
                  'delete_dialog_title'.tr(),
                  style: AppFont.style(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFFF44336)),
                ),
                const SizedBox(height: 12),
                Text(
                  'delete_dialog_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7), letterSpacing: 0.5),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle deletion
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF44336),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      'delete_dialog_btn_confirm'.tr(),
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F9FB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      'delete_dialog_btn_cancel'.tr(),
                      style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF8E9BAE)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
            _buildSectionHeader('profile_details_section'.tr()),
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
                          _buildInfoItem(Icons.location_on_outlined, 'profile_office_address'.tr(), '123, Industrial Area, Phase II, Pune - 411013'),
                          const SizedBox(height: 24),
                          _buildInfoItem(Icons.phone_outlined, 'profile_support_line'.tr(), '+91 20 2233 4455'),
                          const SizedBox(height: 24),
                          _buildInfoItem(Icons.verified_user_outlined, 'profile_tax_id'.tr(), '27AAACM1234A1Z5'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Preferences Section ──────────────────────────────────────────
            _buildSectionHeader('profile_preferences_section'.tr()),
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
            _buildSectionHeader('profile_security_section'.tr()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildActionButton(Icons.logout, 'profile_btn_logout'.tr(), const Color(0xFFF8F9FB), const Color(0xFF8E9BAE), _showLogoutDialog),
                  const SizedBox(height: 16),
                  _buildActionButton(Icons.delete_outline, 'profile_btn_delete'.tr(), const Color(0xFFFFEBEE), const Color(0xFFE53935), _showDeleteDialog),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Text(
            title,
            style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0D121F)),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6))),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFFA5ABB7)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppFont.style(fontSize: 15, fontWeight: FontWeight.w900, color: const Color(0xFF455A64)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w900, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
