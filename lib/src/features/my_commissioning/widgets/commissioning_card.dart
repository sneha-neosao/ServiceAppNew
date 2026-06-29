import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/core/theme/app_color.dart';

class CommissioningCard extends StatelessWidget {
  final String companyName;
  final String equipmentName;
  final String location;
  final String members;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const CommissioningCard({
    super.key,
    required this.companyName,
    required this.equipmentName,
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
        border: Border.all(color: AppColor.colorFFF1F2F6, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.12,
            ), // slightly stronger but still soft
            blurRadius: 12, // more blur for smoother edges
            spreadRadius: 1, // light spread to soften
            offset: const Offset(0, 4), // downward shadow, less diagonal
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
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColor.colorFF0D121F,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColor.colorFFA5ABB7,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            location,
                            style: AppFont.style(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColor.colorFFA5ABB7,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Location
                      Row(
                        children: [
                          Text(
                            'name_of_equipment'.tr(),
                            style: AppFont.style(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColor.colorFFA5ABB7,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            equipmentName,
                            style: AppFont.style(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Edit icon button
                _buildIconBtn(
                  icon: Icons.edit_outlined,
                  onTap: onEdit,
                  icon_color: Colors.blue,
                ),
                const SizedBox(width: 8),
                // Delete icon button
                _buildIconBtn(
                  icon: Icons.delete_outline,
                  onTap: onDelete,
                  icon_color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Members row ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.colorFFF8F9FB,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    members.contains(',')
                        ? Icons
                              .people_outline // multiple technicians
                        : Icons.person_outline, // single technician
                    size: 18,
                    color: AppColor.colorFF1565C0,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      members,
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.colorFF3A4152,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Submit button ─────────────────────────────────────────────
            GestureDetector(
              onTap: onSubmit,
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.colorFF1565C0,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'commissioning_submit_btn'.tr(),
                          style: AppFont.style(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBtn({
    required IconData icon,
    required VoidCallback onTap,
    required Color icon_color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColor.colorFFF8F9FB,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.colorFFF1F2F6, width: 1),
        ),
        child: Icon(icon, size: 18, color: icon_color),
      ),
    );
  }
}
