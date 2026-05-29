import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/assign_technician_dialog.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/complaint_report_dialog.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/service_call_card.dart';

class ServiceCallsScreen extends StatefulWidget {
  const ServiceCallsScreen({super.key});

  @override
  State<ServiceCallsScreen> createState() => _ServiceCallsScreenState();
}

class _ServiceCallsScreenState extends State<ServiceCallsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isCreatingReport = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCreatingReport) {
      return CreateCommissioningReportScreen(
        isServiceReport: true,
        onBack: () {
          setState(() {
            _isCreatingReport = false;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Active Service Calls Header ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                'Service Calls',
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
            _buildTab('ASSIGNED SERVICE CALLS', 1),
            _buildTab('PENDING SERVICE CALLS', 2),
          ],
        ),

        // ── Search & Filters ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Filter Row 1
              Row(
                children: [
                  Expanded(
                    child: _buildFilterDropdown(
                      'Select Customer',
                      Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterDropdown(
                      'Select Site',
                      Icons.location_on_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Filter Row 2
              Row(
                children: [
                  Expanded(
                    child: _buildFilterInput(
                      'Complaint No...',
                      Icons.assignment_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterInput(
                      'dd-mm-yyyy',
                      Icons.calendar_today_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Clear Filters Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // Using dashed-like border by using a light solid border if no package is available
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Center(
                  child: Text(
                    'CLEAR FILTERS',
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFA5ABB7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

        // ── Tab Bar View / List ─────────────────────────────────────────────
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildOngoingList(), _buildActiveList()],
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

  Widget _buildFilterDropdown(String label, IconData icon) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 14,
                color: const Color(0xFFA5ABB7),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFFA5ABB7),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInput(String label, IconData icon) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 14,
                color: const Color(0xFFA5ABB7),
                fontWeight: FontWeight.w500,
              ),
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
        ServiceCallCard(
          type: ServiceCallType.ongoing,
          complaintNo: '#ABC-26-0492',
          companyName: 'Reliance Mart',
          location: 'CHILLER PLANT',
          assignedTo: 'VINOD PATIL, PRASHANT SHINDE',
          onView: () => _showReportDialog(context),
          onEdit: () => _showAssignTechDialog(context),
          onSubmit: () {
            setState(() {
              _isCreatingReport = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActiveList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ServiceCallCard(
          type: ServiceCallType.active,
          complaintNo: '#ABC-26-0487',
          companyName: 'Global Infotech',
          location: 'MAIN SERVER ROOM',
          onView: () => _showReportDialog(context),
          onEdit: () => _showAssignTechDialog(context),
          onSubmit: () {
            setState(() {
              _isCreatingReport = true;
            });
          },
        ),
        const SizedBox(height: 16),
        ServiceCallCard(
          type: ServiceCallType.active,
          complaintNo: '#ABC-26-0501',
          companyName: 'Tata Motors',
          location: 'ASSEMBLY LINE 4',
          onView: () => _showReportDialog(context),
          onEdit: () => _showAssignTechDialog(context),
          onSubmit: () {
            setState(() {
              _isCreatingReport = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCompletedList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ServiceCallCard(
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
        return const ComplaintReportDialog(
          complaintNo: 'ABC-26-0492',
          date: '22 Apr 2026',
          client: 'Reliance Mart',
          site: 'Chiller Plant',
          issue: 'Water leakage from seal',
        );
      },
    );
  }

  void _showAssignTechDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AssignTechnicianDialog();
      },
    );
  }
}
