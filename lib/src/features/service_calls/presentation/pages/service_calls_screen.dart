import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_state.dart';
import 'package:service_app/src/remote/models/service_calls_model/assigned_service_calls_response.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_state.dart';
import 'package:service_app/src/remote/models/service_calls_model/pending_serbice_calls_response.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/assign_technician_dialog.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/complaint_report_dialog.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/service_call_card.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/close_over_call_dialog.dart';

class ServiceCallsScreen extends StatefulWidget {
  const ServiceCallsScreen({super.key});

  @override
  State<ServiceCallsScreen> createState() => _ServiceCallsScreenState();
}

class _ServiceCallsScreenState extends State<ServiceCallsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isCreatingReport = false;

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late AssignedServiceCallsBloc _assignedServiceCallsBloc;
  late PendingServiceCallsBloc _pendingServiceCallsBloc;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _complaintController = TextEditingController();

  String? _selectedCustomerName;
  String? _selectedCustomerId;

  String? _selectedSiteName;
  String? _selectedSiteId;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    
    _assignedServiceCallsBloc = getIt<AssignedServiceCallsBloc>()
      ..add(const AssignedServiceCallsGetEvent());
      
    _pendingServiceCallsBloc = getIt<PendingServiceCallsBloc>()
      ..add(const PendingServiceCallsGetEvent());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (_tabController.index == 0) {
          _fetchServiceCalls(isRefresh: false, isAssignedOnly: true);
        } else {
          _fetchServiceCalls(isRefresh: false, isPendingOnly: true);
        }
      }
    });
  }

  void _fetchServiceCalls({bool isRefresh = false, bool isAssignedOnly = false, bool isPendingOnly = false}) {
    final complaintText = _complaintController.text.trim();
    if (!isPendingOnly) {
      _assignedServiceCallsBloc.add(AssignedServiceCallsGetEvent(
        customerId: _selectedCustomerId,
        siteId: _selectedSiteId,
        complaintNumber: complaintText.isEmpty ? null : complaintText,
        date: _selectedDate,
        isRefresh: isRefresh,
      ));
    }
    if (!isAssignedOnly) {
      _pendingServiceCallsBloc.add(PendingServiceCallsGetEvent(
        customerId: _selectedCustomerId,
        siteId: _selectedSiteId,
        complaintNumber: complaintText.isEmpty ? null : complaintText,
        date: _selectedDate,
        isRefresh: isRefresh,
      ));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _complaintController.dispose();
    _customerBloc.close();
    _sitesBloc.close();
    _assignedServiceCallsBloc.close();
    _pendingServiceCallsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_isCreatingReport) {
    //   return CreateCommissioningReportScreen(
    //     isServiceReport: true,
    //     onBack: () {
    //       setState(() {
    //         _isCreatingReport = false;
    //       });
    //     },
    //     commissioningWorkId: '',
    //   );
    // }

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
        BlocBuilder<AssignedServiceCallsBloc, AssignedServiceCallsState>(
          bloc: _assignedServiceCallsBloc,
          builder: (context, assignedState) {
            return BlocBuilder<PendingServiceCallsBloc, PendingServiceCallsState>(
              bloc: _pendingServiceCallsBloc,
              builder: (context, pendingState) {
                int assignedCount = 0;
                bool isAssignedLoading = assignedState is AssignedServiceCallsLoadingState || assignedState is AssignedServiceCallsInitialState;
                if (assignedState is AssignedServiceCallsSuccessState) {
                  assignedCount = assignedState.data.data.pagination.totalItems;
                } else if (assignedState is AssignedServiceCallsPaginationLoadingState) {
                  assignedCount = assignedState.currentData.data.pagination.totalItems;
                }

                int pendingCount = 0;
                bool isPendingLoading = pendingState is PendingServiceCallsLoadingState || pendingState is PendingServiceCallsInitialState;
                if (pendingState is PendingServiceCallsSuccessState) {
                  pendingCount = pendingState.data.data.pagination.totalItems;
                } else if (pendingState is PendingServiceCallsPaginationLoadingState) {
                  pendingCount = pendingState.currentData.data.pagination.totalItems;
                }

                return TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF1565C0),
                  unselectedLabelColor: const Color(0xFFA5ABB7),
                  indicatorColor: const Color(0xFF1565C0),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  labelPadding: const EdgeInsets.symmetric(vertical: 8),
                  dividerColor: const Color(0xFFF1F2F6),
                  tabs: [
                    _buildTab('ASSIGNED SERVICE CALLS', assignedCount, isLoading: isAssignedLoading),
                    _buildTab('PENDING SERVICE CALLS', pendingCount, isLoading: isPendingLoading),
                  ],
                );
              },
            );
          },
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
                            _fetchServiceCalls(isRefresh: true);
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
                            Icons.person_outline,
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
                            _fetchServiceCalls(isRefresh: true);
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
              // Filter Row 2
              Row(
                children: [
                  Expanded(
                    child: _buildComplaintInput(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateInput(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Clear Filters Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCustomerName = null;
                    _selectedCustomerId = null;
                    _selectedSiteName = null;
                    _selectedSiteId = null;
                    _selectedDate = null;
                    _complaintController.clear();
                  });
                  _fetchServiceCalls(isRefresh: true);
                },
                child: Container(
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

  Widget _buildTab(String label, int count, {bool isLoading = false}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppFont.style(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 4),
          isLoading
              ? const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1565C0)),
                )
              : Text(
                  '($count)',
                  style: AppFont.style(fontSize: 13, fontWeight: FontWeight.w400),
                ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label, IconData icon, {bool isLoading = false}) {
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
            child: isLoading
                ? const Row(
                    children: [
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  )
                : Text(
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

  Widget _buildComplaintInput() {
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
          const Icon(Icons.assignment_outlined, color: Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _complaintController,
              onSubmitted: (_) => _fetchServiceCalls(isRefresh: true),
              style: AppFont.style(
                fontSize: 14,
                color: const Color(0xFF0D121F),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Complaint No...',
                hintStyle: AppFont.style(
                  fontSize: 14,
                  color: const Color(0xFFA5ABB7),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            _selectedDate = DateFormat('yyyy-MM-dd').format(date);
          });
          _fetchServiceCalls(isRefresh: true);
        }
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Color(0xFFA5ABB7), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedDate != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(_selectedDate!)) : 'dd-mm-yyyy',
                style: AppFont.style(
                  fontSize: 14,
                  color: _selectedDate != null ? const Color(0xFF0D121F) : const Color(0xFFA5ABB7),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingList() {
    return BlocBuilder<AssignedServiceCallsBloc, AssignedServiceCallsState>(
      bloc: _assignedServiceCallsBloc,
      builder: (context, state) {
        if (state is AssignedServiceCallsLoadingState || state is AssignedServiceCallsInitialState) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }

        AssignedServiceCallsResponse? data;
        bool isPaginationLoading = false;

        if (state is AssignedServiceCallsSuccessState) {
          data = state.data;
        } else if (state is AssignedServiceCallsPaginationLoadingState) {
          data = state.currentData;
          isPaginationLoading = true;
        }

        if (data != null) {
          if (data.data.results.isEmpty) {
            return Center(
              child: Text(
                'No Assigned Service Calls',
                style: AppFont.style(fontSize: 14, color: const Color(0xFFA5ABB7)),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: data.data.results.length + (isPaginationLoading ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= data!.data.results.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                  ),
                );
              }

              final item = data.data.results[index];
              final techs = item.assignedTechnicians.map((e) => e.name).join(', ');

              return ServiceCallCard(
                type: ServiceCallType.ongoing,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                assignedTo: techs.isNotEmpty ? techs : 'UNASSIGNED',
                onView: () => _showReportDialog(context),
                onEdit: () => _showAssignTechDialog(context, item.id, item.complaintNumber),
                onSubmit: () {
                  setState(() {
                    _isCreatingReport = true;
                  });
                },
              );
            },
          );
        }

        if (state is AssignedServiceCallsFailureState) {
          return Center(
            child: Text(
              state.message,
              style: AppFont.style(color: Colors.red),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildActiveList() {
    return BlocBuilder<PendingServiceCallsBloc, PendingServiceCallsState>(
      bloc: _pendingServiceCallsBloc,
      builder: (context, state) {
        if (state is PendingServiceCallsLoadingState || state is PendingServiceCallsInitialState) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)));
        }

        PendingServiceCallsResponse? data;
        bool isPaginationLoading = false;

        if (state is PendingServiceCallsSuccessState) {
          data = state.data;
        } else if (state is PendingServiceCallsPaginationLoadingState) {
          data = state.currentData;
          isPaginationLoading = true;
        }

        if (data != null) {
          if (data.data.results.isEmpty) {
            return Center(
              child: Text(
                'No Pending Service Calls',
                style: AppFont.style(fontSize: 14, color: const Color(0xFFA5ABB7)),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: data.data.results.length + (isPaginationLoading ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= data!.data.results.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                  ),
                );
              }

              final item = data.data.results[index];

              return ServiceCallCard(
                type: ServiceCallType.active,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                onView: () => _showReportDialog(context),
                onEdit: () => _showAssignTechDialog(context, item.id, item.complaintNumber),
                onCloseOverCall: () => _showCloseOverCallDialog(
                  context,
                  item.complaintNumber,
                  item.customerName,
                  item.siteName,
                ),
                onSubmit: () => _showAssignTechDialog(context, item.id, item.complaintNumber),
              );
            },
          );
        }

        if (state is PendingServiceCallsFailureState) {
          return Center(
            child: Text(
              state.message,
              style: AppFont.style(color: Colors.red),
            ),
          );
        }

        return const SizedBox();
      },
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

  void _showAssignTechDialog(BuildContext context, String complaintId, String complaintNo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AssignTechnicianDialog(complaintId: complaintId, complaintNo: complaintNo);
      },
    );
  }

  void _showCloseOverCallDialog(BuildContext context, String complaintNo, String customerName, String siteName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CloseOverCallDialog(
          complaintNo: complaintNo,
          customerName: customerName,
          siteName: siteName,
        );
      },
    );
  }
}
