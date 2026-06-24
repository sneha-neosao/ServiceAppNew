import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/features/home/bloc/upcoming_amc_bloc/upcoming_amc_bloc.dart';
import 'package:service_app/src/features/home/presentation/widgets/upcoming_amc_card.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';
import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_list_response.dart';
import 'package:intl/intl.dart';
class AmcScheduleScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String initialFilter;
  final Function(String visitId, String title, String location, String visitInfo, String window)
  onItemTap;
  const AmcScheduleScreen({
    super.key,
    required this.onBack,
    this.initialFilter = 'Today',
    required this.onItemTap,
  });

  @override
  State<AmcScheduleScreen> createState() => _AmcScheduleScreenState();
}

class _AmcScheduleScreenState extends State<AmcScheduleScreen> {
  // ── Dropdown data ──────────────────────────────────────────────────────────
  final List<Customer> _customers = [];
  final List<Site> _sites = [];
  final List<AmcVisitData> _amcVisits = [];

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late UpcomingAmcBloc _upcomingAmcBloc;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _customerBloc = getIt<CustomerBloc>()..add(const CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _upcomingAmcBloc = getIt<UpcomingAmcBloc>()..add(UpcomingAmcGetEvent(widget.initialFilter));
  }

  @override
  void dispose() {
    _customerBloc.close();
    _sitesBloc.close();
    _upcomingAmcBloc.close();
    super.dispose();
  }

  // ── State ──────────────────────────────────────────────────────────────────
  Customer? _selectedCustomer;
  Site? _selectedSite;
  late String _selectedFilter;
  bool _isMissedAmcVisitsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
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
                  onPressed: widget.onBack,
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

        // ── Dropdowns + List ──────────────────────────────────────────────
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF0B68B9),
            onRefresh: () async {
              String? pendingParam;
              if (_isMissedAmcVisitsChecked) {
                pendingParam = 'is_prious_pending';
              }
              _upcomingAmcBloc.add(UpcomingAmcGetEvent(_selectedFilter, pending: pendingParam));
              
              _customerBloc.add(const CustomerGetEvent());
              if (_selectedCustomer != null) {
                _sitesBloc.add(SitesGetEvent(customer_id: _selectedCustomer!.id, page: 1, pageSize: 10));
              }
              
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
              SearchableDropdown<String>(
                items: const ['Today', 'Tomorrow', 'Week', 'Month'],
                value: _selectedFilter,
                hintText: 'Select Filter',
                itemAsString: (item) {
                  switch (item) {
                    case 'Today': return 'filter_today'.tr();
                    case 'Tomorrow': return 'filter_tomorrow'.tr();
                    case 'Week': return 'filter_week'.tr();
                    case 'Month': return 'filter_month'.tr();
                    default: return item;
                  }
                },
                isSearchable: false,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedFilter = val;
                    });
                    String? pendingParam;
                    if (_isMissedAmcVisitsChecked) {
                      pendingParam = 'is_prious_pending';
                    }
                    _upcomingAmcBloc.add(UpcomingAmcGetEvent(val, pending: pendingParam));
                  }
                },
              ),
              const SizedBox(height: 12),
              // ── Customer dropdown ────────────────────────────────────────
              BlocBuilder<CustomerBloc, CustomerState>(
                bloc: _customerBloc,
                builder: (context, state) {
                  bool isLoading = state is CustomerLoadingState;
                  if (state is CustomerSuccessState) {
                    _customers.clear();
                    _customers.addAll(state.data.data);
                  }

                  List<Customer> validItems = List.from(_customers);
                  if (_selectedCustomer != null && !validItems.any((e) => e.id == _selectedCustomer!.id)) {
                    validItems.add(_selectedCustomer!);
                  }

                  return SearchableDropdown<Customer>(
                    items: validItems,
                    value: _selectedCustomer,
                    hintText: 'amc_schedule_filter_select_customer'.tr(),
                    itemAsString: (item) => item.name,
                    isLoading: isLoading,
                    filterFn: (item, filter) => true, // Disable local filtering so API takes over
                    onSearchChanged: (v) {
                      _customerBloc.add(CustomerGetEvent(search: v, page: 1, pageSize: 10));
                    },
                    onLoadMore: (lastSearch) {
                      _customerBloc.add(CustomerGetEvent(search: lastSearch, page: 2, pageSize: 10));
                    },
                    onChanged: (v) {
                      setState(() {
                        _selectedCustomer = v;
                        _selectedSite = null;
                        _sites.clear();
                      });
                      if (v != null) {
                        _sitesBloc.add(SitesGetEvent(customer_id: v.id, page: 1, pageSize: 10));
                      }
                    },
                    onClear: () {
                      setState(() {
                        _selectedCustomer = null;
                        _selectedSite = null;
                        _sites.clear();
                      });
                    },
                  );
                },
              ),

              const SizedBox(height: 12),

              // ── Site dropdown ────────────────────────────────────────────
              BlocBuilder<SitesBloc, SitesState>(
                bloc: _sitesBloc,
                builder: (context, state) {
                  bool isLoading = state is SitesLoadingState;
                  if (state is SitesSuccessState) {
                    _sites.clear();
                    _sites.addAll(state.data.data);
                  }

                  List<Site> validItems = List.from(_sites);
                  if (_selectedSite != null && !validItems.any((e) => e.id == _selectedSite!.id)) {
                    validItems.add(_selectedSite!);
                  }

                  Widget siteDropdown = SearchableDropdown<Site>(
                    enabled: _selectedCustomer != null,
                    items: validItems,
                    value: _selectedSite,
                    hintText: 'amc_schedule_filter_select_site'.tr(),
                    itemAsString: (item) => item.name,
                    isLoading: isLoading,
                    filterFn: (item, filter) => true,
                    onSearchChanged: (v) {
                      if (_selectedCustomer != null) {
                        _sitesBloc.add(SitesGetEvent(
                            customer_id: _selectedCustomer!.id, search: v, page: 1, pageSize: 10));
                      }
                    },
                    onLoadMore: (lastSearch) {
                      if (_selectedCustomer != null) {
                        _sitesBloc.add(SitesGetEvent(
                            customer_id: _selectedCustomer!.id, search: lastSearch, page: 2, pageSize: 10));
                      }
                    },
                    onChanged: (v) {
                      setState(() {
                        _selectedSite = v;
                      });
                    },
                    onClear: () {
                      setState(() {
                        _selectedSite = null;
                      });
                    },
                  );

                  return siteDropdown;
                },
              ),

              const SizedBox(height: 12),

              // ── Missed AMC Visits Checkbox ──────────────────────────────────────────
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isMissedAmcVisitsChecked = !_isMissedAmcVisitsChecked;
                  });
                  String? pendingParam;
                  if (_isMissedAmcVisitsChecked) {
                    pendingParam = 'is_prious_pending';
                  }
                  _upcomingAmcBloc.add(UpcomingAmcGetEvent(_selectedFilter, pending: pendingParam));
                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFF1F2F6)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _isMissedAmcVisitsChecked ? const Color(0xFFA86F4B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _isMissedAmcVisitsChecked ? const Color(0xFFA86F4B) : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                        ),
                        child: _isMissedAmcVisitsChecked
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Missed AMC Visits',
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4A6581),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Schedule cards ───────────────────────────────────────────
              BlocBuilder<UpcomingAmcBloc, UpcomingAmcState>(
                bloc: _upcomingAmcBloc,
                builder: (context, state) {
                  if (state is UpcomingAmcLoadingState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ListCardShimmer(),
                        );
                      },
                    );
                  }

                  if (state is UpcomingAmcSuccessState) {
                    _amcVisits.clear();
                    if (state.data.data?.visits != null) {
                      _amcVisits.addAll(state.data.data!.visits!);
                    }
                  }

                  // Filter logic
                  var filteredVisits = _amcVisits;
                  if (_selectedCustomer != null && _selectedCustomer!.name != 'All') {
                    filteredVisits = filteredVisits.where((e) => e.customerName == _selectedCustomer!.name).toList();
                  }
                  if (_selectedSite != null && _selectedSite!.name != 'All') {
                    filteredVisits = filteredVisits.where((e) => e.siteName == _selectedSite!.name).toList();
                  }

                  if (filteredVisits.isEmpty && state is UpcomingAmcSuccessState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'No AMC visits found.',
                          style: AppFont.style(
                            fontSize: 15,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredVisits.length,
                    itemBuilder: (context, index) {
                      final visit = filteredVisits[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _AmcScheduleCard(
                          title: visit.customerName,
                          location: visit.siteName,
                          visitInfo: "${'visit'.tr()} ${visit.visitNumber}/${visit.totalVisits}",
                          date: visit.fromDate != null
                              ? DateFormat('d MMMM yyyy', context.locale.languageCode).format(DateTime.parse(visit.fromDate!).toLocal())
                              : '-',
                          onTap: () => widget.onItemTap(
                            visit.id,
                            visit.customerName,
                            visit.siteName,
                            '${'visit'.tr()} ${visit.visitNumber}/${visit.totalVisits}',
                            visit.status,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ],
    );
  }
}



// ── Schedule card ──────────────────────────────────────────────────────────────
class _AmcScheduleCard extends StatelessWidget {
  final String title;
  final String location;
  final String visitInfo;
  final String date;
  final VoidCallback onTap;

  const _AmcScheduleCard({
    required this.title,
    required this.location,
    required this.visitInfo,
    required this.date,
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
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4),
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
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Color(0xFF1565C0),
                            ),
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
                          'amc_report_date_label'.tr(),
                          style: AppFont.style(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFA5ABB7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
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
      ),
    );
  }
}
