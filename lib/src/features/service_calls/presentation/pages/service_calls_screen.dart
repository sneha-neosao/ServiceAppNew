import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart';
import 'package:service_app/src/features/home/presentation/pages/home_screen.dart';
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
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/complaint_report_dialog.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/service_call_card.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/close_over_call_dialog.dart';

class ServiceCallsScreen extends StatefulWidget {
  const ServiceCallsScreen({super.key});

  @override
  State<ServiceCallsScreen> createState() => _ServiceCallsScreenState();
}

class _ServiceCallsScreenState extends State<ServiceCallsScreen> {
  int _selectedTab = 0; // 0 = Assigned, 1 = Pending

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late AssignedServiceCallsBloc _assignedServiceCallsBloc;
  late PendingServiceCallsBloc _pendingServiceCallsBloc;
  final TextEditingController _complaintController = TextEditingController();

  String? _selectedCustomerName;
  String? _selectedCustomerId;

  String? _selectedSiteName;
  String? _selectedSiteId;
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();

    _assignedServiceCallsBloc = getIt<AssignedServiceCallsBloc>()
      ..add(const AssignedServiceCallsGetEvent());

    _pendingServiceCallsBloc = getIt<PendingServiceCallsBloc>()
      ..add(const PendingServiceCallsGetEvent());
  }

  void _fetchServiceCalls({
    bool isRefresh = false,
    bool isAssignedOnly = false,
    bool isPendingOnly = false,
  }) {
    final complaintText = _complaintController.text.trim();
    if (!isPendingOnly) {
      _assignedServiceCallsBloc.add(
        AssignedServiceCallsGetEvent(
          customerId: _selectedCustomerId,
          siteId: _selectedSiteId,
          complaintNumber: complaintText.isEmpty ? null : complaintText,
          date: _selectedDate,
          isRefresh: isRefresh,
        ),
      );
    }
    if (!isAssignedOnly) {
      _pendingServiceCallsBloc.add(
        PendingServiceCallsGetEvent(
          customerId: _selectedCustomerId,
          siteId: _selectedSiteId,
          complaintNumber: complaintText.isEmpty ? null : complaintText,
          date: _selectedDate,
          isRefresh: isRefresh,
        ),
      );
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _customerBloc.close();
    _sitesBloc.close();
    _assignedServiceCallsBloc.close();
    _pendingServiceCallsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Service Calls Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  'service_calls_title'.tr(),
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
          BlocBuilder<AssignedServiceCallsBloc, AssignedServiceCallsState>(
            bloc: _assignedServiceCallsBloc,
            builder: (context, assignedState) {
              return BlocBuilder<
                PendingServiceCallsBloc,
                PendingServiceCallsState
              >(
                bloc: _pendingServiceCallsBloc,
                builder: (context, pendingState) {
                  int assignedCount = 0;
                  if (assignedState is AssignedServiceCallsSuccessState) {
                    assignedCount =
                        assignedState.data.data.pagination.totalItems;
                  } else if (assignedState
                      is AssignedServiceCallsPaginationLoadingState) {
                    assignedCount =
                        assignedState.currentData.data.pagination.totalItems;
                  }
                  int pendingCount = 0;
                  if (pendingState is PendingServiceCallsSuccessState) {
                    pendingCount = pendingState.data.data.pagination.totalItems;
                  } else if (pendingState
                      is PendingServiceCallsPaginationLoadingState) {
                    pendingCount =
                        pendingState.currentData.data.pagination.totalItems;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F2F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSegmentTab(
                              0,
                              'service_calls_tab_assigned'.tr(),
                              count: assignedCount,
                              isLoading:
                                  assignedState
                                      is AssignedServiceCallsLoadingState ||
                                  assignedState
                                      is AssignedServiceCallsInitialState,
                            ),
                          ),
                          Expanded(
                            child: _buildSegmentTab(
                              1,
                              'service_calls_tab_pending'.tr(),
                              count: pendingCount,
                              isLoading:
                                  pendingState
                                      is PendingServiceCallsLoadingState ||
                                  pendingState
                                      is PendingServiceCallsInitialState,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
          // ── Search & Filters ────────────────────────────────────────────────
          Container(
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
                          return SearchableDropdown<Customer>(
                            items: customers,
                            value: _selectedCustomerId != null
                                ? customers
                                          .where(
                                            (c) => c.id == _selectedCustomerId,
                                          )
                                          .isEmpty
                                      ? null
                                      : customers.firstWhere(
                                          (c) => c.id == _selectedCustomerId,
                                        )
                                : null,
                            hintText: 'service_calls_filter_select_customer'
                                .tr(),
                            itemAsString: (c) => c.name,
                            isLoading: state is CustomerLoadingState,
                            isFilter: true,
                            filterFn: (item, filter) => true,
                            onSearchChanged: (v) {
                              _customerBloc.add(
                                CustomerGetEvent(
                                  search: v,
                                  page: 1,
                                  pageSize: 10,
                                ),
                              );
                            },
                            onLoadMore: (lastSearch) {
                              _customerBloc.add(
                                CustomerGetEvent(
                                  search: lastSearch,
                                  page: 2,
                                  pageSize: 10,
                                ),
                              );
                            },
                            // icon: const Icon(
                            //   Icons.person_outline,
                            //   color: Color(0xFFA5ABB7),
                            //   size: 18,
                            // ),
                            onChanged: (customer) {
                              setState(() {
                                _selectedCustomerName = customer?.name;
                                _selectedCustomerId = customer?.id;
                                _selectedSiteName = null;
                                _selectedSiteId = null;
                              });
                              if (customer != null) {
                                _sitesBloc.add(
                                  SitesGetEvent(customer_id: customer.id),
                                );
                              }
                              _fetchServiceCalls(isRefresh: true);
                            },
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

                          Site? initialValue;
                          if (_selectedSiteId != null) {
                            final matches = sites.where(
                              (s) => s.id == _selectedSiteId,
                            );
                            if (matches.isNotEmpty) {
                              initialValue = matches.first;
                            } else if (_selectedSiteName != null) {
                              // If it's selected but not in the current paginated list, manually add it
                              final s = Site(
                                id: _selectedSiteId!,
                                name: _selectedSiteName!,
                              );
                              sites.add(s);
                              initialValue = s;
                            }
                          }

                          return SearchableDropdown<Site>(
                            items: sites,
                            value: initialValue,
                            hintText: 'service_calls_filter_select_site'.tr(),
                            itemAsString: (s) => s.name,
                            isLoading: state is SitesLoadingState,
                            isFilter: true,
                            filterFn: (item, filter) => true,
                            // icon: const Icon(
                            //   Icons.location_on_outlined,
                            //   color: Color(0xFFA5ABB7),
                            //   size: 18,
                            // ),
                            onSearchChanged: _selectedCustomerId != null
                                ? (v) => _sitesBloc.add(
                                    SitesGetEvent(
                                      customer_id: _selectedCustomerId!,
                                      search: v,
                                      page: 1,
                                      pageSize: 10,
                                    ),
                                  )
                                : null,
                            onLoadMore: _selectedCustomerId != null
                                ? (lastSearch) => _sitesBloc.add(
                                    SitesGetEvent(
                                      customer_id: _selectedCustomerId!,
                                      search: lastSearch,
                                      page: 2,
                                      pageSize: 10,
                                    ),
                                  )
                                : null,
                            onChanged: (site) {
                              setState(() {
                                _selectedSiteName = site?.name;
                                _selectedSiteId = site?.id;
                              });
                              _fetchServiceCalls(isRefresh: true);
                            },
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
                    Expanded(child: _buildComplaintInput()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDateInput()),
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
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'service_calls_clear_filters'.tr(),
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

          // ── Tab Body ────────────────────────────────────────────────────────
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FB),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent &&
                      scrollInfo.metrics.axis == Axis.vertical) {
                    if (_selectedTab == 0) {
                      _fetchServiceCalls(
                        isRefresh: false,
                        isAssignedOnly: true,
                      );
                    } else {
                      _fetchServiceCalls(isRefresh: false, isPendingOnly: true);
                    }
                  }
                  return false;
                },
                child: _selectedTab == 0
                    ? _buildOngoingList()
                    : _buildActiveList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentTab(
    int index,
    String label, {
    int count = 0,
    bool isLoading = false,
  }) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = index);
        if (index == 0) {
          _fetchServiceCalls(isRefresh: true, isAssignedOnly: true);
        } else {
          _fetchServiceCalls(isRefresh: true, isPendingOnly: true);
        }
      },
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF1565C0)
                      : const Color(0xFFA5ABB7),
                ),
              ),
              const SizedBox(width: 4),
              isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : Text(
                      '($count)',
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                      ),
                    ),
            ],
          ),
        ),
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
          const Icon(
            Icons.assignment_outlined,
            color: Color(0xFFA5ABB7),
            size: 18,
          ),
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
                hintText: 'service_calls_filter_complaint_hint'.tr(),
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
            const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFFA5ABB7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedDate != null
                    ? DateFormat(
                        'dd MMM yyyy',
                      ).format(DateTime.parse(_selectedDate!))
                    : 'service_calls_filter_date_hint'.tr(),
                style: AppFont.style(
                  fontSize: 14,
                  color: _selectedDate != null
                      ? const Color(0xFF0D121F)
                      : const Color(0xFFA5ABB7),
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
        if (state is AssignedServiceCallsLoadingState ||
            state is AssignedServiceCallsInitialState) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) => const ListCardShimmer(),
          );
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
                'service_calls_empty_assigned'.tr(),
                style: AppFont.style(
                  fontSize: 14,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
            );
          }

          return ListView.separated(
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
              final techs = item.assignedTechnicians
                  .map((e) => e.name)
                  .join(', ');

              return ServiceCallCard(
                type: ServiceCallType.ongoing,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                assignedTo: techs.isNotEmpty ? techs : 'UNASSIGNED',
                onView: () => _showReportDialog(context, item.id),
                onEdit: () => _showAssignTechDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  initialTechnicians: item.assignedTechnicians
                      .map((e) => Technician(
                            id: e.id,
                            name: e.name,
                            code: e.code,
                          ))
                      .toList(),
                ),
                onSubmit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCommissioningReportScreen(
                        isServiceReport: true,
                        onBack: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HomeScreen(initialIndex: 2),
                          ),
                          (route) => false,
                        ),
                        commissioningWorkId: item.id,
                        complaintNo: item.complaintNumber,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is AssignedServiceCallsFailureState) {
          return Center(
            child: Text(state.message, style: AppFont.style(color: Colors.red)),
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
        if (state is PendingServiceCallsLoadingState ||
            state is PendingServiceCallsInitialState) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) => const ListCardShimmer(),
          );
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
                'service_calls_empty_pending'.tr(),
                style: AppFont.style(
                  fontSize: 14,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
            );
          }

          return ListView.separated(
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
                onView: () => _showReportDialog(context, item.id),
                onEdit: () => _showAssignTechDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  initialTechnicians: item.assignedTechnicians
                      .map((e) => Technician(
                            id: e.id,
                            name: e.name,
                            code: e.code,
                          ))
                      .toList(),
                ),
                onCloseOverCall: () => _showCloseOverCallDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  item.customerName,
                  item.siteName,
                ),
                onSubmit: () => _showAssignTechDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  initialTechnicians: item.assignedTechnicians
                      .map((e) => Technician(
                            id: e.id,
                            name: e.name,
                            code: e.code,
                          ))
                      .toList(),
                ),
              );
            },
          );
        }

        if (state is PendingServiceCallsFailureState) {
          return Center(
            child: Text(state.message, style: AppFont.style(color: Colors.red)),
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
          onView: () => _showReportDialog(context, 'dummy_id'),
          onEdit: () {},
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context, String complaintId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ComplaintReportDialog(
          complaintId: complaintId,
        );
      },
    );
  }

  void _showAssignTechDialog(
      BuildContext context, String complaintId, String complaintNo,
      {List<Technician>? initialTechnicians}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AssignTechnicianDialog(
          complaintId: complaintId,
          complaintNo: complaintNo,
          initialTechnicians: initialTechnicians,
          onSuccess: () => _fetchServiceCalls(isRefresh: true),
        );
      },
    );
  }

  void _showCloseOverCallDialog(
    BuildContext context,
    String complaintId,
    String complaintNo,
    String customerName,
    String siteName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CloseOverCallDialog(
          complaintId: complaintId,
          complaintNo: complaintNo,
          customerName: customerName,
          siteName: siteName,
          onSuccess: () => _fetchServiceCalls(isRefresh: true),
        );
      },
    );
  }
}
