import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class CommissioningCard extends StatelessWidget {
  final String companyName;
  final String location;
  final String members;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const CommissioningCard({
    super.key,
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
