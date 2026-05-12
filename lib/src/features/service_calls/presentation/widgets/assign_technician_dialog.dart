import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class AssignTechnicianDialog extends StatelessWidget {
  const AssignTechnicianDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'assign_tech_title'.tr(),
                        style: AppFont.style(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'assign_tech_subtitle'.tr(),
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFA5ABB7), size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Selector
            Text(
              'assign_tech_select_label'.tr(),
              style: AppFont.style(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F2F6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '2 Selected',
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0D121F)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Assign Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'assign_tech_btn'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
