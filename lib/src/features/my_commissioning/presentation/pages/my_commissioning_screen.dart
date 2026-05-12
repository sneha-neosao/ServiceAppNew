import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/remote/models/commissioning_model.dart';

import 'create_commissioning_report_screen.dart';
import 'edit_commissioning_screen.dart';

class MyCommissioningScreen extends StatefulWidget {
  const MyCommissioningScreen({super.key});

  @override
  State<MyCommissioningScreen> createState() => _MyCommissioningScreenState();
}

class _MyCommissioningScreenState extends State<MyCommissioningScreen> {
  bool _isEditing = false;
  bool _isCreating = false;
  CommissioningModel? _selectedItem;

  @override
  Widget build(BuildContext context) {
    if (_isEditing && _selectedItem != null) {
      return EditCommissioningScreen(
        customerName: _selectedItem!.companyName,
        siteLocation: _selectedItem!.location,
        assignedTechnicians: _selectedItem!.members,
        onBack: () => setState(() {
          _isEditing = false;
          _selectedItem = null;
        }),
      );
    }

    if (_isCreating) {
      return CreateCommissioningReportScreen(
        onBack: () => setState(() {
          _isCreating = false;
        }),
      );
    }

    final List<CommissioningModel> items = CommissioningModel.dummyList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'commissioning_section_title'.tr(),
                  style: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Count badge
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF1565C0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${items.length}',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── List ─────────────────────────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return _CommissioningCard(
                companyName: item.companyName,
                location: item.location,
                members: item.members,
                onEdit: () => setState(() {
                  _selectedItem = item;
                  _isEditing = true;
                }),
                onDelete: () => _showDeleteDialog(context),
                onSubmit: () => setState(() {
                  _isCreating = true;
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.delete_forever, color: Color(0xFFFF4D4F), size: 36),
                ),
                const SizedBox(height: 28),
                // Title
                Text(
                  'delete_job_title'.tr(),
                  style: AppFont.style(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 14),
                // Subtitle
                Text(
                  'delete_job_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8E9BAE),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),
                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00569E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'delete_job_confirm'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF8F9FB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFFF0F2F5)),
                      ),
                    ),
                    child: Text(
                      'delete_job_cancel'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF8E9BAE),
                        letterSpacing: 0.8,
                      ),
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
}

// ── Commissioning card widget ─────────────────────────────────────────────────
class _CommissioningCard extends StatelessWidget {
  final String companyName;
  final String location;
  final String members;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const _CommissioningCard({
    required this.companyName,
    required this.location,
    required this.members,
    required this.onEdit,
    required this.onDelete,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Company name + action icons ──────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    companyName,
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(Icons.edit_outlined, size: 20, color: Colors.grey.shade500),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade500),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // ── Location ──────────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Members row ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.people_outline,
                      size: 18, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      members,
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Submit button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(
                  'commissioning_submit_btn'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
