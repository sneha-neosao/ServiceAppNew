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
import 'package:service_app/src/features/service_calls/widgets/assign_technician_dialog.dart';
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';
import 'package:service_app/src/features/service_calls/widgets/complaint_report_dialog.dart';
import 'package:service_app/src/features/service_calls/widgets/service_call_card.dart';
import 'package:service_app/src/features/service_calls/widgets/reassign_technician_dialog.dart';
import 'package:service_app/src/features/service_calls/widgets/close_over_call_dialog.dart';


part 'package:service_app/src/features/service_calls/widgets/service_calls_step1_widget.dart';
part 'package:service_app/src/features/service_calls/widgets/service_calls_step2_widget.dart';
part 'package:service_app/src/features/service_calls/widgets/service_calls_step3_widget.dart';
part 'package:service_app/src/features/service_calls/widgets/service_calls_step4_widget.dart';
part 'package:service_app/src/features/service_calls/widgets/service_calls_step5_widget.dart';
part 'package:service_app/src/features/service_calls/widgets/service_calls_step6_widget.dart';

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
  // Pending tab — plain text inputs
  final TextEditingController _pendingCustomerController = TextEditingController();
  final TextEditingController _pendingSiteController = TextEditingController();

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
      final pendingCustomer = _pendingCustomerController.text.trim();
      final pendingSite = _pendingSiteController.text.trim();
      _pendingServiceCallsBloc.add(
        PendingServiceCallsGetEvent(
          customerName: pendingCustomer.isEmpty ? null : pendingCustomer,
          siteName: pendingSite.isEmpty ? null : pendingSite,
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
    _pendingCustomerController.dispose();
    _pendingSiteController.dispose();
    _customerBloc.close();
    _sitesBloc.close();
    _assignedServiceCallsBloc.close();
    _pendingServiceCallsBloc.close();
    super.dispose();
  }

  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceCallsStep1Widget(parent: this),
                ],
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _StickyFilterDelegate(
                  height: 280,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ServiceCallsStep2Widget(parent: this),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            ServiceCallsStep3Widget(parent: this),
                            const SizedBox(height: 12),
                            ServiceCallsStep4Widget(parent: this),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: const Color(0xFFF8F9FB),
          child: RefreshIndicator(
            edgeOffset: 280.0,
            color: const Color(0xFF0B68B9),
            onRefresh: () async {
              _fetchServiceCalls(isRefresh: true);
              await Future.delayed(const Duration(seconds: 1));
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
                    scrollInfo.metrics.axis == Axis.vertical) {
                  if (_selectedTab == 0) {
                    _fetchServiceCalls(isRefresh: false, isAssignedOnly: true);
                  } else {
                    _fetchServiceCalls(isRefresh: false, isPendingOnly: true);
                  }
                }
                return false;
              },
              child: _selectedTab == 0
                  ? ServiceCallsStep5Widget(parent: this)
                  : ServiceCallsStep6Widget(parent: this),
            ),
          ),
        ),
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
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
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
          // const Icon(
          //   Icons.assignment_outlined,
          //   color: Color(0xFFA5ABB7),
          //   size: 18,
          // ),
          // const SizedBox(width: 8),
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
            // const Icon(
            //   Icons.calendar_today_outlined,
            //   color: Color(0xFFA5ABB7),
            //   size: 18,
            // ),
            // const SizedBox(width: 8),
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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 292, bottom: 100),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) =>
                const ServiceCallCardShimmer(type: ServiceCallType.ongoing),
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
            return Padding(
              padding: const EdgeInsets.only(top: 276),
              child: Center(
                child: Text(
                  'service_calls_empty_assigned'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 292, bottom: 100),
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
              final dateStr = item.lastServiceDate != null && item.lastServiceDate!.isNotEmpty
                  ? DateFormat(
                      'd MMMM yyyy',
                    ).format(DateTime.parse(item.lastServiceDate!).toLocal())
                  : null;

              return ServiceCallCard(
                type: ServiceCallType.ongoing,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                assignedTo: techs.isNotEmpty ? techs : 'UNASSIGNED',
                dateReceived: dateStr,
                onView: () => _showReportDialog(context, item.id),
                onEdit: () => _showReassignTechDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  item.customerName,
                  item.customerId,
                  item.siteName,
                  item.siteId,
                  initialTechnicians: item.assignedTechnicians
                      .map(
                        (e) => Technician(id: e.id, name: e.name, code: e.code),
                      )
                      .toList(),
                ),
                onSubmit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCommissioningReportScreen(
                        isServiceReport: true,
                        onBack: () => Navigator.pop(context),
                        commissioningWorkId: item.id,
                        complaintNo: item.complaintNumber,
                        initialStepNo: item.step_no ?? 0,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is AssignedServiceCallsFailureState) {
          return Padding(
            padding: const EdgeInsets.only(top: 276),
            child: Center(
              child: Text(state.message, style: AppFont.style(color: Colors.red)),
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
        if (state is PendingServiceCallsLoadingState ||
            state is PendingServiceCallsInitialState) {
          return ListView.separated(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 292,
              bottom: 100,
            ),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, __) =>
                const ServiceCallCardShimmer(type: ServiceCallType.active),
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
            return Padding(
              padding: const EdgeInsets.only(top: 276),
              child: Center(
                child: Text(
                  'service_calls_empty_pending'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 292,
              bottom: 100,
            ),
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
              final dateStr = item.lastServiceDate != null && item.lastServiceDate!.isNotEmpty
                  ? DateFormat(
                      'd MMMM yyyy',
                    ).format(DateTime.parse(item.lastServiceDate!).toLocal())
                  : null;

              return ServiceCallCard(
                type: ServiceCallType.active,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                dateReceived: dateStr,
                onView: () => _showReportDialog(context, item.id),
                onEdit: () => _showAssignTechDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  initialTechnicians: item.assignedTechnicians
                      .map(
                        (e) => Technician(id: e.id, name: e.name, code: e.code),
                      )
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
                      .map(
                        (e) => Technician(id: e.id, name: e.name, code: e.code),
                      )
                      .toList(),
                ),
              );
            },
          );
        }

        if (state is PendingServiceCallsFailureState) {
          return Padding(
            padding: const EdgeInsets.only(top: 276),
            child: Center(
              child: Text(state.message, style: AppFont.style(color: Colors.red)),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  void _showReportDialog(BuildContext context, String complaintId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ComplaintReportDialog(complaintId: complaintId);
      },
    );
  }

  void _showAssignTechDialog(
    BuildContext context,
    String complaintId,
    String complaintNo, {
    List<Technician>? initialTechnicians,
  }) {
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

  void _showReassignTechDialog(
    BuildContext context,
    String complaintId,
    String complaintNo,
    String customerName,
    String customerId,
    String siteName,
    String siteId, {
    List<Technician>? initialTechnicians,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ReassignTechnicianDialog(
          complaintId: complaintId,
          complaintNo: complaintNo,
          customerName: customerName,
          customerId: customerId,
          siteName: siteName,
          siteId: siteId,
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

class _StickyFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyFilterDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _StickyFilterDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
