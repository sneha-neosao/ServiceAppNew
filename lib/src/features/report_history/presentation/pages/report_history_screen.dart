import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_state.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_details_bloc/commissioning_report_details_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_details_bloc/commissioning_report_details_event.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  int _selectedTab = 1; // Default to 'Service'
  late CommissioningReportHistoryBloc _historyBloc;
  late CommissioningReportDetailsBloc _detailsBloc;
  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late TechnicianBloc _technicianBloc;
  String? _selectedCustomerName;
  String? _selectedCustomerId;
  String? _selectedSiteName;
  String? _selectedSiteId;
  String? _selectedTechnicianName;
  String? _selectedTechnicianId;

  void _fetchReportHistory() {
    _historyBloc.add(
      CommissioningReportHistoryGetEvent(
        params: CommissioningReportHistoryParams(
          customerId: _selectedCustomerId,
          siteId: _selectedSiteId,
          page: 1,
          pageSize: 10,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _historyBloc = getIt<CommissioningReportHistoryBloc>();
    _detailsBloc = getIt<CommissioningReportDetailsBloc>();
    _fetchReportHistory();
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
  }

  @override
  void dispose() {
    _historyBloc.close();
    _detailsBloc.close();
    _customerBloc.close();
    _sitesBloc.close();
    _technicianBloc.close();
    super.dispose();
  }

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
              Text(
                'Reports History',
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
                Expanded(child: _buildSegmentTab(0, 'COMMISSIONING')),
                Expanded(child: _buildSegmentTab(1, 'SERVICE')),
                Expanded(child: _buildSegmentTab(2, 'AMC')),
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
            child: _selectedTab == 0
                ? BlocBuilder<
                    CommissioningReportHistoryBloc,
                    CommissioningReportHistoryState
                  >(
                    bloc: _historyBloc,
                    builder: (context, state) {
                      if (state is CommissioningReportHistoryLoadingState ||
                          state is CommissioningReportHistoryInitialState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1565C0),
                          ),
                        );
                      } else if (state
                          is CommissioningReportHistoryFailureState) {
                        return Center(
                          child: Text(
                            state.message,
                            style: AppFont.style(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else if (state
                          is CommissioningReportHistorySuccessState) {
                        final items = state.data.data.results;
                        if (items.isEmpty) {
                          return Center(
                            child: Text(
                              'No commissioning reports found',
                              style: AppFont.style(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFA5ABB7),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            String formattedDate = item.submittedAt;
                            try {
                              final dt = DateTime.parse(item.submittedAt);
                              formattedDate = DateFormat(
                                'dd MMM yyyy',
                              ).format(dt);
                            } catch (_) {}

                            return _ReportCard(
                              id: item.commissioningWorkId,
                              reportId: item.id,
                              type: ReportType.commissioning,
                              companyName: item.customerName,
                              location: item.siteName,
                              date: formattedDate,
                              technician:
                                  item.technicianRepresentativeName ??
                                  'No representative',
                              technicianId: item.dealerName,
                              feedbackSubmitted: item.feedbackSubmitted,
                              qrCodeImage: item.qrCodeImage,
                              onViewTap: (id) {
                                _detailsBloc.add(
                                  CommissioningReportDetailsGetEvent(id),
                                );
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  )
                : ListView(
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
          feedbackSubmitted: false,
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
          feedbackSubmitted: false,
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
          feedbackSubmitted: true,
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
          feedbackSubmitted: false,
        ),
      ];
    }
  }

  Widget _buildSegmentTab(int index, String label) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFA5ABB7),
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
          // Filter Row 1
          Row(
            children: [
              Expanded(
                child: BlocBuilder<CustomerBloc, CustomerState>(
                  bloc: _customerBloc,
                  builder: (context, state) {
                    final customers = <Customer>[];
                    if (state is CustomerSuccessState) {
                      customers.addAll(state.data.data);
                    }
                    return PopupMenuButton<Customer>(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      onSelected: (customer) {
                        setState(() {
                          _selectedCustomerName = customer.name;
                          _selectedCustomerId = customer.id;
                          _selectedSiteName = null;
                          _selectedSiteId = null;
                        });
                        _sitesBloc.add(SitesGetEvent(customer.id));
                        _fetchReportHistory();
                      },
                      offset: const Offset(0, 45),
                      itemBuilder: (ctx) => customers
                          .map(
                            (c) => PopupMenuItem<Customer>(
                              value: c,
                              child: Text(
                                c.name,
                                style: AppFont.style(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      child: _buildFilterDropdown(
                        _selectedCustomerName ?? 'Select Customer',
                        Icons.business_outlined,
                        isLoading: state is CustomerLoadingState,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<SitesBloc, SitesState>(
                  bloc: _sitesBloc,
                  builder: (context, state) {
                    final sites = <Site>[];
                    if (state is SitesSuccessState) {
                      sites.addAll(state.data.data);
                    }
                    return PopupMenuButton<Site>(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      onSelected: (site) {
                        setState(() {
                          _selectedSiteName = site.name;
                          _selectedSiteId = site.id;
                        });
                        _fetchReportHistory();
                      },
                      offset: const Offset(0, 45),
                      itemBuilder: (ctx) => sites
                          .map(
                            (s) => PopupMenuItem<Site>(
                              value: s,
                              child: Text(
                                s.name,
                                style: AppFont.style(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      child: _buildFilterDropdown(
                        _selectedSiteName ?? 'Select Site',
                        Icons.location_on_outlined,
                        isLoading: state is SitesLoadingState,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Complaint Number
          _buildFilterInputFull(
            'Complaint Number...',
            Icons.assignment_outlined,
          ),
          const SizedBox(height: 12),
          // Filter Row 2
          Row(
            children: [
              Expanded(
                child: _buildFilterInput(
                  'dd-mm-yyyy',
                  Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<TechnicianBloc, TechnicianState>(
                  bloc: _technicianBloc,
                  builder: (context, state) {
                    final technicians = <Technician>[];
                    if (state is TechnicianSuccessState) {
                      technicians.addAll(state.data.data);
                    }
                    return PopupMenuButton<Technician>(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      onSelected: (tech) {
                        setState(() {
                          _selectedTechnicianName = tech.name;
                          _selectedTechnicianId = tech.id;
                        });
                        _fetchReportHistory();
                      },
                      offset: const Offset(0, 45),
                      itemBuilder: (ctx) => technicians
                          .map(
                            (t) => PopupMenuItem<Technician>(
                              value: t,
                              child: Text(
                                t.name,
                                style: AppFont.style(color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      child: _buildFilterDropdown(
                        _selectedTechnicianName ?? 'Select Technician',
                        Icons.person_outline,
                        isLoading: state is TechnicianLoadingState,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Clear Filters
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedCustomerName = null;
                _selectedCustomerId = null;
                _selectedSiteName = null;
                _selectedSiteId = null;
                _selectedTechnicianName = null;
                _selectedTechnicianId = null;
              });
              _fetchReportHistory();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    IconData icon, {
    bool isLoading = false,
  }) {
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
          if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF1565C0),
              ),
            )
          else
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

  Widget _buildFilterInputFull(String label, IconData icon) {
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
}

enum ReportType { commissioning, service, amc }

class _ReportCard extends StatelessWidget {
  final String id;
  final String? reportId;
  final ReportType type;
  final String companyName;
  final String location;
  final String date;
  final String? complaintNo;
  final String technician;
  final String technicianId;
  final bool feedbackSubmitted;
  final String? qrCodeImage;
  final void Function(String reportId)? onViewTap;

  const _ReportCard({
    required this.id,
    this.reportId,
    required this.type,
    required this.companyName,
    required this.location,
    required this.date,
    this.complaintNo,
    required this.technician,
    required this.technicianId,
    required this.feedbackSubmitted,
    this.qrCodeImage,
    this.onViewTap,
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
            // Company & Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  companyName,
                  style: AppFont.style(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                ),
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
            const SizedBox(height: 8),
            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Color(0xFFA5ABB7),
                ),
                const SizedBox(width: 8),
                Text(
                  location,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7A8699),
                  ),
                ),
              ],
            ),
            if (complaintNo != null) ...[
              const SizedBox(height: 16),
              // Complaint Row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      complaintNo!,
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'VIEW COMPLAINT REPORT',
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE65100),
                        letterSpacing: 0.5,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Technician Row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Color(0xFFCDD0D8),
                  ),
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
              ],
            ),
            const SizedBox(height: 16),
            _buildViewButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton(BuildContext context) {
    String btnText = 'VIEW SERVICE REPORT';
    if (type == ReportType.commissioning) {
      btnText = 'VIEW COMMISSIONING REPORT';
    } else if (type == ReportType.amc) {
      btnText = 'VIEW AMC REPORT';
    }
    return Column(
      children: [
        Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                btnText,
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 16, color: Colors.white),
            ],
          ),
        ),
        // Extra action buttons — only for commissioning type
        if (type == ReportType.commissioning) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              // Eye / View icon button
              Expanded(
                child: _buildIconActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: const Color(0xFF6B7280),
                  onTap: () {
                    if (reportId != null) {
                      onViewTap?.call(reportId!);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              // QR Code icon button or Checkmark
              Expanded(
                child: feedbackSubmitted
                    ? Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Center(
                          child: Icon(Icons.check_circle, color: Colors.green),
                        ),
                      )
                    : _buildIconActionButton(
                        icon: Icons.qr_code_2_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        onTap: () {
                          if (qrCodeImage != null && qrCodeImage!.isNotEmpty) {
                            _showQrCodeDialog(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('QR Code not available'),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildIconActionButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        ),
        child: Center(child: Icon(icon, size: 22, color: iconColor)),
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFA5ABB7)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_success_title'.tr(),
                  style: AppFont.style(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'create_report_success_subtitle'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F2F6)),
                  ),
                  child: qrCodeImage != null && qrCodeImage!.isNotEmpty
                      ? Image.network(
                          qrCodeImage!,
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.qr_code_2,
                          size: 180,
                          color: Color(0xFF0D121F),
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_scan_feedback'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Done',
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
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
}
