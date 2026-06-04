import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class AmcVisitDetailsScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final VoidCallback? onCompleteAmcWork;
  final String title;
  final String location;
  final String visitInfo;
  final String window;
  final int reportsCreated;

  const AmcVisitDetailsScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
    this.onCompleteAmcWork,
    required this.title,
    required this.location,
    required this.visitInfo,
    required this.window,
    this.reportsCreated = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Scrollable body ──────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF5C616E),
                          ),
                          onPressed: onBack,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppFont.style(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Color(0xFF1565C0),
                              ),
                              const SizedBox(width: 4),
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
                    ],
                  ),
                ),

                // ── Visit Info Card ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Badges row ──────────────────────────────────────
                        Row(
                          children: [
                            _OutlineBadge(
                              label: 'amc_details_status_progress'.tr(),
                              borderColor: const Color(0xFF1565C0),
                              textColor: const Color(0xFF1565C0),
                              bgColor: Color(0xFFC2E2FE),
                            ),
                            const SizedBox(width: 10),
                            _OutlineBadge(
                              label: visitInfo,
                              borderColor: const Color(0xFF1B5E20),
                              textColor: const Color(0xFF1B5E20),
                              bgColor: Color(0xFFC8E6C9),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Visit range ─────────────────────────────────────
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${'amc_details_visit_window'.tr()}: ',
                                style: AppFont.style(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0D121F),
                                ),
                              ),
                              TextSpan(
                                text: window,
                                style: AppFont.style(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (reportsCreated == 0) ...[
                          const SizedBox(height: 20),
                          // ── Submit button ───────────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'amc_details_submit_btn'.tr(),
                                    style: AppFont.style(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Reports Created label ──────────────────────────────────
                Center(
                  child: Text(
                    reportsCreated > 0
                        ? 'Reports Created ($reportsCreated)'
                        : '${'amc_details_reports_created'.tr()} (0)',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                if (reportsCreated > 0) ...[
                  const SizedBox(height: 16),

                  ...List.generate(reportsCreated, (index) {
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 16,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9), // Light green
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF00A76F),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Report ${index + 1} – Completed',
                            style: AppFont.style(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // + Create Another Report (dashed)
                  GestureDetector(
                    onTap: onSubmit,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Color(0xFFA5ABB7),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Create Another Report',
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFA5ABB7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // ── Bottom "Complete AMC Work" bar ───────────────────────────────────
        Container(
          color: const Color(0xFFF8F8F8),
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
          child: GestureDetector(
            onTap: reportsCreated > 0 ? onCompleteAmcWork : null,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: reportsCreated > 0
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFECEFF1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: reportsCreated > 0
                        ? Colors.white
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Complete AMC Work',
                    style: AppFont.style(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: reportsCreated > 0
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Outlined badge (border only, no fill) ──────────────────────────────────────
class _OutlineBadge extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final Color bgColor;

  const _OutlineBadge({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        label,
        style: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
