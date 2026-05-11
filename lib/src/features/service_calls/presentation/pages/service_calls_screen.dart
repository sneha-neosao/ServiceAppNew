import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

class ServiceCallsScreen extends StatefulWidget {
  const ServiceCallsScreen({super.key});

  @override
  State<ServiceCallsScreen> createState() => _ServiceCallsScreenState();
}

class _ServiceCallsScreenState extends State<ServiceCallsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Active Service Calls Header ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                'service_calls_section_title'.tr(),
                style: AppFont.style(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D121F),
                ),
              ),
            ],
          ),
        ),

        // ── Custom Tab Bar ──────────────────────────────────────────────────
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1565C0),
          unselectedLabelColor: const Color(0xFFA5ABB7),
          indicatorColor: const Color(0xFF1565C0),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          labelPadding: const EdgeInsets.symmetric(vertical: 8),
          dividerColor: const Color(0xFFF1F2F6),
          tabs: [
            _buildTab('service_calls_tab_ongoing'.tr(), 1),
            _buildTab('service_calls_tab_active'.tr(), 2),
            _buildTab('service_calls_tab_completed'.tr(), 1),
          ],
        ),

        // ── Search & Filters ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              _buildSearchField(),
              const SizedBox(height: 12),
              // Filter Row 1
              Row(
                children: [
                  Expanded(child: _buildFilterDropdown('service_calls_filter_clients'.tr(), Icons.search)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildFilterDropdown('service_calls_filter_sites'.tr(), Icons.location_on_outlined)),
                ],
              ),
              const SizedBox(height: 12),
              // Filter Row 2
              Row(
                children: [
                  Expanded(child: _buildFilterInput('service_calls_filter_complaint'.tr(), Icons.assignment_outlined)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildFilterInput('service_calls_filter_date'.tr(), Icons.calendar_today_outlined)),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

        // ── Tab Bar View / List ─────────────────────────────────────────────
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOngoingList(),
              _buildActiveList(),
              _buildCompletedList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppFont.style(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: AppFont.style(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'service_calls_search_hint'.tr(),
          hintStyle: AppFont.style(fontSize: 13, color: const Color(0xFFA5ABB7), fontWeight: FontWeight.w600),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFA5ABB7), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, IconData icon) {
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
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0D121F), size: 18),
        ],
      ),
    );
  }

  Widget _buildFilterInput(String label, IconData icon) {
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

  Widget _buildOngoingList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ServiceCallCard(
          type: ServiceCallType.ongoing,
          complaintNo: '#ABC-26-0492',
          companyName: 'Reliance Mart',
          location: 'CHILLER PLANT',
          assignedTo: 'VINOD PATIL, PRASHANT SHINDE',
          onView: () => _showReportDialog(context),
          onEdit: () => _showAssignTechDialog(context),
        ),
      ],
    );
  }

  Widget _buildActiveList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ServiceCallCard(
          type: ServiceCallType.active,
          complaintNo: '#ABC-26-0487',
          companyName: 'Global Infotech',
          location: 'MAIN SERVER ROOM',
          onView: () => _showReportDialog(context),
          onEdit: () => _showAssignTechDialog(context),
        ),
        const SizedBox(height: 16),
        _ServiceCallCard(
          type: ServiceCallType.active,
          complaintNo: '#ABC-26-0501',
          companyName: 'Tata Motors',
          location: 'ASSEMBLY LINE 4',
          onView: () => _showReportDialog(context),
          onEdit: () => _showAssignTechDialog(context),
        ),
      ],
    );
  }

  Widget _buildCompletedList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ServiceCallCard(
          type: ServiceCallType.completed,
          complaintNo: '#ABC-26-0450',
          companyName: 'Wipro Tech',
          location: 'TOWER A',
          assignedTo: 'RAHUL DESHMUKH',
          isCompleted: true,
          onView: () => _showReportDialog(context),
          onEdit: () {},
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.shield_outlined, color: Color(0xFF1565C0), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'complaint_report_title'.tr(),
                      style: AppFont.style(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFA5ABB7)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Info Grid
                Row(
                  children: [
                    Expanded(child: _buildInfoItem('complaint_report_no_label'.tr(), 'ABC-26-0492')),
                    Expanded(child: _buildInfoItem('complaint_report_received_label'.tr(), '22 Apr 2026')),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoItem('complaint_report_client_label'.tr(), 'Reliance Mart'),
                const SizedBox(height: 24),
                _buildInfoItem('complaint_report_site_label'.tr(), 'Chiller Plant'),
                const SizedBox(height: 32),
                // Issue Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'complaint_report_issue_label'.tr(),
                        style: AppFont.style(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Water leakage from seal',
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF424B5C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Download Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.file_download_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'complaint_report_btn_download'.tr(),
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAssignTechDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                      const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Action Button
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
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0D121F),
          ),
        ),
      ],
    );
  }
}

enum ServiceCallType { ongoing, active, completed }

class _ServiceCallCard extends StatelessWidget {
  final ServiceCallType type;
  final String complaintNo;
  final String companyName;
  final String location;
  final String? assignedTo;
  final bool isCompleted;
  final VoidCallback onView;
  final VoidCallback onEdit;

  const _ServiceCallCard({
    required this.type,
    required this.complaintNo,
    required this.companyName,
    required this.location,
    this.assignedTo,
    this.isCompleted = false,
    required this.onView,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    complaintNo,
                    style: AppFont.style(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                ),
                if (isCompleted) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'COMPLETED',
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (type == ServiceCallType.ongoing) ...[
                  _buildIconButton(Icons.edit_outlined, onTap: onEdit),
                  const SizedBox(width: 8),
                ],
                _buildIconButton(Icons.visibility_outlined, onTap: onView),
              ],
            ),
            const SizedBox(height: 12),
            // Company Name
            Text(
              companyName,
              style: AppFont.style(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0D121F),
              ),
            ),
            const SizedBox(height: 4),
            // Location
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFFA5ABB7)),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
            if (assignedTo != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Color(0xFF1565C0)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ASSIGNED: $assignedTo',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF424B5C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                if (type != ServiceCallType.completed)
                  Expanded(
                    child: _buildSecondaryButton(
                      'service_calls_btn_closed'.tr(),
                      Icons.phone_disabled_outlined,
                    ),
                  )
                else
                  Expanded(child: _buildCompletedButton()),
                if (type != ServiceCallType.completed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPrimaryButton(
                      type == ServiceCallType.ongoing
                          ? 'service_calls_btn_submit'.tr()
                          : 'service_calls_btn_assign'.tr(),
                      type == ServiceCallType.ongoing
                          ? Icons.check_circle_outline
                          : Icons.person_add_outlined,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFFA5ABB7)),
      ),
    );
  }

  Widget _buildPrimaryButton(String label, IconData icon) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String label, IconData icon) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5C616E)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF5C616E)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFFA5ABB7)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'service_calls_btn_completed'.tr(),
              style: AppFont.style(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFFA5ABB7)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
