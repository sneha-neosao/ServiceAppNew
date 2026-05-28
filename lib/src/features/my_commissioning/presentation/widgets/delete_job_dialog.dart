import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class DeleteJobDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteJobDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Trash icon ─────────────────────────────────────────────────
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFFF4D4F),
                size: 38,
              ),
            ),

            const SizedBox(height: 24),

            // ── Title ───────────────────────────────────────────────────────
            Text(
              'delete_job_title'.tr(),
              style: AppFont.style(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),

            const SizedBox(height: 12),

            // ── Subtitle ────────────────────────────────────────────────────
            Text(
              'delete_job_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8E9BAE),
                height: 1.55,
              ),
            ),

            const SizedBox(height: 32),

            // ── Confirm Delete button ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const  Color(0xFF1565C0),
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
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Cancel button ───────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'delete_job_cancel'.tr(),
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB0B8C8),
                    letterSpacing: 1.0,
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

