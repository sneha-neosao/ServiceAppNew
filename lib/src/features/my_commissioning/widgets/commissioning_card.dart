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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F2F6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12), // slightly stronger but still soft
            blurRadius: 12,                        // more blur for smoother edges
            spreadRadius: 1,                        // light spread to soften
            offset: const Offset(0, 4),             // downward shadow, less diagonal
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Company name + action icons ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFFA5ABB7),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            location,
                            style: AppFont.style(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFA5ABB7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Edit icon button
                _buildIconBtn(icon: Icons.edit_outlined, onTap: onEdit),
                const SizedBox(width: 8),
                // Delete icon button
                _buildIconBtn(icon: Icons.delete_outline, onTap: onDelete),
              ],
            ),

            const SizedBox(height: 16),

            // ── Members row ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    members.contains(',')
                        ? Icons.people_outline   // multiple technicians
                        : Icons.person_outline,   // single technician
                    size: 18,
                    color: const Color(0xFFA5ABB7),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      members,
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3A4152),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Submit button ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
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
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: Text(
                  'commissioning_submit_btn'.tr(),
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF1F2F6), width: 1),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
      ),
    );
  }
}
