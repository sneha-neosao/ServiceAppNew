import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class NotificationScreen extends StatelessWidget {
  final VoidCallback onBack;
  const NotificationScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header Section ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(20),
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
              Text(
                'notif_header_title'.tr(),
                style: AppFont.style(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D121F),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 16, color: Color(0xFF1565C0)),
                    const SizedBox(width: 6),
                    Text(
                      'notif_clear_filters'.tr(),
                      style: AppFont.style(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Filters ───────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildFilterDropdown('notif_filter_customer'.tr(), Icons.business_outlined),
              const SizedBox(height: 12),
              _buildFilterDropdown('notif_filter_site'.tr(), Icons.location_on_outlined),
              const SizedBox(height: 12),
              _buildFilterField('notif_filter_date'.tr(), Icons.calendar_today_outlined),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

        // ── Notifications List ────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _NotificationCard(
                type: NotificationType.info,
                title: 'New Service Call Assigned',
                description: 'You have been assigned a new service call for Site "Galaxy Residency" (SRV-2024-001).',
                tags: ['GALAXY GROUP', 'GALAXY RESIDENCY'],
                time: '10:30 AM',
                date: '2024-03-20',
                isNew: true,
              ),
              const SizedBox(height: 16),
              _NotificationCard(
                type: NotificationType.warning,
                title: 'AMC Renewal Due',
                description: 'Customer "Tech Center" AMC is expiring in 5 days. Please follow up for renewal.',
                tags: ['TECH CENTER', 'MAIN OFFICE'],
                time: '09:15 AM',
                date: '2024-03-20',
                isNew: true,
              ),
              const SizedBox(height: 16),
              _NotificationCard(
                type: NotificationType.success,
                title: 'Service Report Approved',
                description: 'The service report for Complaint #1024 has been approved by the admin.',
                tags: ['METRO MALL', 'LOBBY AC'],
                time: '04:45 PM',
                date: '2024-03-19',
              ),
              const SizedBox(height: 16),
              _NotificationCard(
                type: NotificationType.error,
                title: 'Escalated Complaint',
                description: 'Complaint #1098 has been escalated due to delay. Immediate action required.',
                tags: ['CITY HOSPITAL', 'ICU WING'],
                time: '11:20 AM',
                date: '2024-03-19',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, IconData icon) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFA5ABB7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF424B5C)),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
        ],
      ),
    );
  }

  Widget _buildFilterField(String label, IconData icon) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFA5ABB7)),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppFont.style(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFA5ABB7)),
          ),
        ],
      ),
    );
  }
}

enum NotificationType { info, warning, success, error }

class _NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String description;
  final List<String> tags;
  final String time;
  final String date;
  final bool isNew;

  const _NotificationCard({
    required this.type,
    required this.title,
    required this.description,
    required this.tags,
    required this.time,
    required this.date,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor;
    IconData icon;
    Color iconBg;

    switch (type) {
      case NotificationType.info:
        accentColor = const Color(0xFF1565C0);
        icon = Icons.info_outline;
        iconBg = const Color(0xFFF1F8FF);
        break;
      case NotificationType.warning:
        accentColor = const Color(0xFFF9A825);
        icon = Icons.error_outline;
        iconBg = const Color(0xFFFFFDE7);
        break;
      case NotificationType.success:
        accentColor = const Color(0xFF2E7D32);
        icon = Icons.check_circle_outline;
        iconBg = const Color(0xFFE8F5E9);
        break;
      case NotificationType.error:
        accentColor = const Color(0xFFD32F2F);
        icon = Icons.error_outline;
        iconBg = const Color(0xFFFFEBEE);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(width: 5, height: 160, color: accentColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: accentColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: AppFont.style(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0D121F),
                                    ),
                                  ),
                                ),
                                if (isNew)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1565C0),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'notif_status_new'.tr(),
                                      style: AppFont.style(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: AppFont.style(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5C616E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          runSpacing: 8,
                          children: tags.map((tag) => _buildTag(tag)).toList(),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _buildFooterItem(Icons.access_time, time),
                            const SizedBox(width: 16),
                            _buildFooterItem(Icons.calendar_today_outlined, date),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppFont.style(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF8E9BAE)),
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFFA5ABB7)),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF8E9BAE)),
        ),
      ],
    );
  }
}
