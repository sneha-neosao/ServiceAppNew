part of '../pages/service_calls_screen.dart';

class ServiceCallsStep6Widget extends StatelessWidget {
  final _ServiceCallsScreenState parent;
  const ServiceCallsStep6Widget({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingServiceCallsBloc, PendingServiceCallsState>(
      bloc: parent._pendingServiceCallsBloc,
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
              final dateStr = item.createdAt.isNotEmpty
                  ? DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(item.createdAt).toLocal())
                  : null;

              return ServiceCallCard(
                type: ServiceCallType.active,
                complaintNo: item.complaintNumber,
                companyName: item.customerName,
                location: item.siteName,
                dateReceived: dateStr,
                onView: () => parent._showReportDialog(context, item.id),
                onEdit: () => parent._showAssignTechDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  initialTechnicians: item.assignedTechnicians
                      .map(
                        (e) => Technician(id: e.id, name: e.name, code: e.code),
                      )
                      .toList(),
                ),
                onCloseOverCall: () => parent._showCloseOverCallDialog(
                  context,
                  item.id,
                  item.complaintNumber,
                  item.customerName,
                  item.siteName,
                ),
                onSubmit: () => parent._showAssignTechDialog(
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
}
