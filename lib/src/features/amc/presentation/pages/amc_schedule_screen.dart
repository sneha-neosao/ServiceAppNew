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
import 'package:service_app/src/features/amc/bloc/amc_visits_list_bloc/amc_visits_list_bloc.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';
import 'package:service_app/src/remote/models/amc_visit_model/amc_visit_list_response.dart';
class AmcScheduleScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String visitId, String title, String location, String visitInfo, String window)
  onItemTap;
  const AmcScheduleScreen({
    super.key,
    required this.onBack,
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
  late AmcVisitsListBloc _amcVisitsListBloc;

  @override
  void initState() {
    super.initState();
    _customerBloc = getIt<CustomerBloc>()..add(const CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _amcVisitsListBloc = getIt<AmcVisitsListBloc>()..add(const AmcVisitsListGetEvent());
  }

  @override
  void dispose() {
    _customerBloc.close();
    _sitesBloc.close();
    _amcVisitsListBloc.close();
    super.dispose();
  }

  // ── State ──────────────────────────────────────────────────────────────────
  Customer? _selectedCustomer;
  Site? _selectedSite;

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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
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

                  return SearchableDropdown<Site>(
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
                  );
                },
              ),

              const SizedBox(height: 20),

              // ── Schedule cards ───────────────────────────────────────────
              BlocBuilder<AmcVisitsListBloc, AmcVisitsListState>(
                bloc: _amcVisitsListBloc,
                builder: (context, state) {
                  if (state is AmcVisitsListLoadingState) {
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

                  if (state is AmcVisitsListSuccessState) {
                    _amcVisits.clear();
                    _amcVisits.addAll(state.data.data);
                  }

                  // Filter logic
                  var filteredVisits = _amcVisits;
                  if (_selectedCustomer != null && _selectedCustomer!.name != 'All') {
                    filteredVisits = filteredVisits.where((e) => e.customerName == _selectedCustomer!.name).toList();
                  }
                  if (_selectedSite != null && _selectedSite!.name != 'All') {
                    filteredVisits = filteredVisits.where((e) => e.siteName == _selectedSite!.name).toList();
                  }

                  if (filteredVisits.isEmpty && state is AmcVisitsListSuccessState) {
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
                          visitInfo: 'Visit ${visit.visitNumber}',
                          window: visit.status,
                          onTap: () => widget.onItemTap(
                            visit.amcVisitId,
                            visit.customerName,
                            visit.siteName,
                            'Visit ${visit.visitNumber}',
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
      ],
    );
  }
}



// ── Schedule card ──────────────────────────────────────────────────────────────
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
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
      ),
    );
  }
}
