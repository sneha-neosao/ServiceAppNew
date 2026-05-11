import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class AmcScheduleScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Function(String title, String location, String visitInfo, String window) onItemTap;
  const AmcScheduleScreen({super.key, required this.onBack, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header Section ────────────────────────────────────────────────
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
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF5C616E)),
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'amc_schedule_appbar_title'.tr(),
                    style: AppFont.style(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  Text(
                    'amc_schedule_subtitle'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Schedule List ─────────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _AmcScheduleCard(
                title: 'Infosys Campus',
                location: 'Data Center B',
                visitInfo: 'Visit 1 of 4',
                window: 'Apr 29 - May 05',
                onTap: () => onItemTap('Infosys Campus', 'Data Center B', 'Visit 1 of 4', 'Apr 29 - May 05'),
              ),
              const SizedBox(height: 20),
              _AmcScheduleCard(
                title: 'Wipro Office',
                location: 'Pantry Area',
                visitInfo: 'Visit 2 of 6',
                window: 'Apr 30 - May 10',
                onTap: () => onItemTap('Wipro Office', 'Pantry Area', 'Visit 2 of 6', 'Apr 30 - May 10'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmcScheduleCard extends StatelessWidget {
  final String title;
  final String location;
  final String visitInfo;
  final String window;
  final VoidCallback onTap;

  const _AmcScheduleCard({
    required this.title,
    required this.location,
    required this.visitInfo,
    required this.window,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppFont.style(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF1565C0)),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: AppFont.style(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF424B5C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'amc_schedule_status_active'.tr(),
                    style: AppFont.style(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFF1F2F6)),
            const SizedBox(height: 20),
            // Info Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'amc_schedule_visit_info'.tr(),
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        visitInfo,
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'amc_schedule_window'.tr(),
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        window,
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
