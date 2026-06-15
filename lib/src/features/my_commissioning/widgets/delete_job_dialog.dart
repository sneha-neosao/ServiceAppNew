import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class DeleteJobDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final bool isLoading;

  const DeleteJobDialog({
    super.key,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon ───────────────────────────────────────────────────────
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Color(0xFFFF4D4F),
                    size: 32,
                  ),
                ),
                
                const SizedBox(height: 20),

                // ── Title ───────────────────────────────────────────────────────
                Text(
                  'Delete Work',
                  style: AppFont.style(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Subtitle ────────────────────────────────────────────────────
                Text(
                  'Are you sure you want to delete this\ncommissioning job? This action cannot be\nundone.',
                  textAlign: TextAlign.center,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5C616E),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Buttons ─────────────────────────────────────────────────────
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF6F6F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Cancel',
                              maxLines: 1,
                              style: AppFont.style(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0D121F),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete Now Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE30000),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Delete Now',
                                    maxLines: 1,
                                    style: AppFont.style(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // ── Close (X) Icon ────────────────────────────────────────────────
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFFB0B8C8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
