part of '../pages/service_calls_screen.dart';

class ServiceCallsStep3Widget extends StatelessWidget {
  final _ServiceCallsScreenState parent;
  const ServiceCallsStep3Widget({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    if (parent._selectedTab == 0) {
      return Row(
        children: [
          Expanded(
            child: BlocBuilder<CustomerBloc, CustomerState>(
              bloc: parent._customerBloc,
              builder: (context, state) {
                final customers = <Customer>[];
                if (state is CustomerSuccessState) {
                  customers.addAll(state.data.data);
                }
                return SearchableDropdown<Customer>(
                  items: customers,
                  value: parent._selectedCustomerId != null
                      ? customers.where((c) => c.id == parent._selectedCustomerId).isEmpty
                          ? null
                          : customers.firstWhere((c) => c.id == parent._selectedCustomerId)
                      : null,
                  hintText: 'service_calls_filter_select_customer'.tr(),
                  itemAsString: (c) => c.name,
                  isLoading: state is CustomerLoadingState,
                  isFilter: true,
                  filterFn: (item, filter) => true,
                  onSearchChanged: (v) {
                    parent._customerBloc.add(CustomerGetEvent(search: v, page: 1, pageSize: 10));
                  },
                  onLoadMore: (lastSearch) {
                    parent._customerBloc.add(CustomerGetEvent(search: lastSearch, page: 2, pageSize: 10));
                  },
                  onChanged: (customer) {
                    parent.updateState(() {
                      parent._selectedCustomerName = customer?.name;
                      parent._selectedCustomerId = customer?.id;
                      parent._selectedSiteName = null;
                      parent._selectedSiteId = null;
                    });
                    if (customer != null) {
                      parent._sitesBloc.add(SitesGetEvent(customer_id: customer.id));
                    }
                    parent._fetchServiceCalls(isRefresh: true, isAssignedOnly: true);
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BlocBuilder<SitesBloc, SitesState>(
              bloc: parent._sitesBloc,
              builder: (context, state) {
                final sites = <Site>[];
                if (state is SitesSuccessState) {
                  sites.addAll(state.data.data);
                }

                Site? initialValue;
                if (parent._selectedSiteId != null) {
                  final matches = sites.where((s) => s.id == parent._selectedSiteId);
                  if (matches.isNotEmpty) {
                    initialValue = matches.first;
                  } else if (parent._selectedSiteName != null) {
                    final s = Site(id: parent._selectedSiteId!, name: parent._selectedSiteName!);
                    sites.add(s);
                    initialValue = s;
                  }
                }

                Widget siteDropdown = SearchableDropdown<Site>(
                  items: sites,
                  value: initialValue,
                  hintText: 'service_calls_filter_select_site'.tr(),
                  itemAsString: (s) => s.name,
                  isLoading: state is SitesLoadingState,
                  isFilter: true,
                  filterFn: (item, filter) => true,
                  onSearchChanged: parent._selectedCustomerId != null
                      ? (v) => parent._sitesBloc.add(SitesGetEvent(customer_id: parent._selectedCustomerId!, search: v, page: 1, pageSize: 10))
                      : null,
                  onLoadMore: parent._selectedCustomerId != null
                      ? (lastSearch) => parent._sitesBloc.add(SitesGetEvent(customer_id: parent._selectedCustomerId!, search: lastSearch, page: 2, pageSize: 10))
                      : null,
                  onChanged: (site) {
                    parent.updateState(() {
                      parent._selectedSiteName = site?.name;
                      parent._selectedSiteId = site?.id;
                    });
                    parent._fetchServiceCalls(isRefresh: true, isAssignedOnly: true);
                  },
                );

                if (parent._selectedCustomerId == null) {
                  return IgnorePointer(
                    child: Opacity(opacity: 0.5, child: siteDropdown),
                  );
                }
                return siteDropdown;
              },
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: parent._pendingCustomerController,
              style: AppFont.style(fontSize: 13, color: const Color(0xFF0D121F)),
              decoration: InputDecoration(
                hintText: 'Enter customer name',
                hintStyle: AppFont.style(fontSize: 13, color: const Color(0xFFA5ABB7)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF1F2F6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF1F2F6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF0B68B9)),
                ),
              ),
              onSubmitted: (_) => parent._fetchServiceCalls(isRefresh: true, isPendingOnly: true),
              onChanged: (_) => parent.updateState(() {}),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: parent._pendingSiteController,
              style: AppFont.style(fontSize: 13, color: const Color(0xFF0D121F)),
              decoration: InputDecoration(
                hintText: 'Enter site name',
                hintStyle: AppFont.style(fontSize: 13, color: const Color(0xFFA5ABB7)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF1F2F6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF1F2F6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF0B68B9)),
                ),
              ),
              onSubmitted: (_) => parent._fetchServiceCalls(isRefresh: true, isPendingOnly: true),
              onChanged: (_) => parent.updateState(() {}),
            ),
          ),
        ],
      );
    }
  }
}
