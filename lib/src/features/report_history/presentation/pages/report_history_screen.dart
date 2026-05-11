import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  int _selectedTab = 1; // Default to 'Service'

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Reports History Header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF5C616E)),
              ),
              const SizedBox(width: 16),
              Text(
                'reports_section_title'.tr(),
                style: AppFont.style(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D121F),
                ),
              ),
            ],
          ),
        ),

        // ── Segmented Tab Control ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildSegmentTab(0, 'reports_tab_commissioning'.tr())),
                Expanded(child: _buildSegmentTab(1, 'reports_tab_service'.tr())),
                Expanded(child: _buildSegmentTab(2, 'reports_tab_amc'.tr())),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

        // ── Filter Section ──────────────────────────────────────────────────
        _buildFilterSection(),

        // ── Reports List ────────────────────────────────────────────────────
        Expanded(
          child: Container(
            color: const Color(0xFFF8F9FB),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _buildReportList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildReportList() {
    if (_selectedTab == 0) {
      // Commissioning
      return [
        _ReportCard(
          id: 'COM-7721',
          type: ReportType.commissioning,
          companyName: 'Shree Krishna Ind.',
          location: 'Ahmedabad Plant',
          date: '28 Apr 2026',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
        ),
      ];
    } else if (_selectedTab == 1) {
      // Service
      return [
        _ReportCard(
          id: 'SRV-9901',
          type: ReportType.service,
          companyName: 'Global Infotech',
          location: 'Main Server Room',
          date: '29 Apr 2026',
          complaintNo: '#ABC-26-0821',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
        ),
        const SizedBox(height: 16),
        _ReportCard(
          id: 'SRV-9902',
          type: ReportType.service,
          companyName: 'Tata Motors',
          location: 'Assembly Line 4',
          date: '22 Apr 2026',
          complaintNo: '#ABC-26-0715',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
        ),
      ];
    } else {
      // AMC
      return [
        _ReportCard(
          id: 'AMC-5501',
          type: ReportType.amc,
          companyName: 'Reliance Mart',
          location: 'Chiller Plant',
          date: '30 Apr 2026',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
        ),
      ];
    }
  }

  Widget _buildSegmentTab(int index, String label) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFA5ABB7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Column(
        children: [
          // Search Field
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'reports_search_hint'.tr(),
                hintStyle: AppFont.style(fontSize: 13, color: const Color(0xFFA5ABB7), fontWeight: FontWeight.w600),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFA5ABB7), size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Row 1
          Row(
            children: [
              Expanded(child: _buildFilterItem('reports_filter_clients'.tr(), Icons.business_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _buildFilterItem('reports_filter_sites'.tr(), Icons.location_on_outlined)),
            ],
          ),
          // Complaint Number (Only for Service tab)
          if (_selectedTab == 1) ...[
            const SizedBox(height: 12),
            _buildFilterItemFull('reports_filter_complaint'.tr(), Icons.assignment_outlined),
          ],
          const SizedBox(height: 12),
          // Filter Row 2
          Row(
            children: [
              Expanded(child: _buildFilterItem('reports_filter_date'.tr(), Icons.calendar_today_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _buildFilterItem('reports_filter_technicians'.tr(), Icons.person_search_outlined)),
            ],
          ),
          const SizedBox(height: 16),
          // Clear Filters
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1565C0).withValues(alpha: 0.2), style: BorderStyle.solid),
            ),
            child: Center(
              child: Text(
                'reports_clear_filters'.tr(),
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1565C0).withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String label, IconData icon) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(fontSize: 12, color: const Color(0xFF0D121F), fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItemFull(String label, IconData icon) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(fontSize: 12, color: const Color(0xFFA5ABB7), fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

enum ReportType { commissioning, service, amc }

class _ReportCard extends StatelessWidget {
  final String id;
  final ReportType type;
  final String companyName;
  final String location;
  final String date;
  final String? complaintNo;
  final String technician;
  final String technicianId;

  const _ReportCard({
    required this.id,
    required this.type,
    required this.companyName,
    required this.location,
    required this.date,
    this.complaintNo,
    required this.technician,
    required this.technicianId,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    switch (type) {
      case ReportType.commissioning:
        badgeBg = const Color(0xFFE3F2FD);
        badgeText = const Color(0xFF1565C0);
        badgeLabel = 'reports_tab_commissioning'.tr();
        break;
      case ReportType.service:
        badgeBg = const Color(0xFFFFF1EB);
        badgeText = const Color(0xFFFF6D00);
        badgeLabel = 'reports_tab_service'.tr();
        break;
      case ReportType.amc:
        badgeBg = const Color(0xFFE8F5E9);
        badgeText = const Color(0xFF2E7D32);
        badgeLabel = 'reports_tab_amc'.tr();
        break;
    }

    return Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeLabel,
                    style: AppFont.style(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: badgeText,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'ID: $id',
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const Spacer(),
                Text(
                  date,
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Company
            Text(
              companyName,
              style: AppFont.style(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D121F),
              ),
            ),
            const SizedBox(height: 8),
            // Location
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF1565C0)),
                const SizedBox(width: 8),
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
            if (complaintNo != null) ...[
              const SizedBox(height: 12),
              // Complaint Row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE0B2).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Text(
                      complaintNo!,
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFF6D00),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'reports_view_complaint'.tr(),
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFF6D00),
                        letterSpacing: 0.5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F2F6)),
            const SizedBox(height: 16),
            // Technician Row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.refresh, size: 20, color: Color(0xFFA5ABB7)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technician,
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    Text(
                      technicianId,
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _buildDownloadButton(),
                const SizedBox(width: 12),
                _buildViewButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.download_outlined, size: 20, color: Color(0xFFA5ABB7)),
    );
  }

  Widget _buildViewButton() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            'reports_btn_view'.tr(),
            style: AppFont.style(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 18, color: Colors.white),
        ],
      ),
    );
  }
}
