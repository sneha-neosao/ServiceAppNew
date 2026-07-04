part of '../presentation/pages/service_calls_screen.dart';

class ServiceCallsStep5Widget extends StatelessWidget {
  final _ServiceCallsScreenState parent;
  const ServiceCallsStep5Widget({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignedServiceCallsBloc, AssignedServiceCallsState>(
      bloc: parent._assignedServiceCallsBloc,
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
                    fontSize: 12,
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
              final dateStr = item.createdAt.isNotEmpty
                  ? DateFormat(
                      'd MMMM yyyy', context.locale.languageCode
                    ).format(DateTime.parse(item.createdAt).toLocal())
                  : null;

              return ServiceCallCard(
                type: ServiceCallType.ongoing,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                assignedTo: techs.isNotEmpty ? techs : 'UNASSIGNED',
                dateReceived: dateStr,
                onView: () => parent._showReportDialog(context, item.id),
                onEdit: () => parent._showReassignTechDialog(
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
                        reportId: item.reportId,
                        defaultTechnicians: item.assignedTechnicians
                            .map((t) => {'id': t.id, 'name': t.name})
                            .toList(),
                        customerName: item.customerName,
                        siteName: item.siteName,
                      ),
                    ),
                  ).then((_) {
                    parent._fetchServiceCalls(isRefresh: true);
                  });
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
}
