import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class DeleteJobDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteJobDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
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
                onPressed: onConfirm,
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
  }
}
