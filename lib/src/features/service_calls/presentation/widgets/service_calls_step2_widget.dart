part of '../pages/service_calls_screen.dart';

class ServiceCallsStep2Widget extends StatelessWidget {
  final _ServiceCallsScreenState parent;
  const ServiceCallsStep2Widget({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignedServiceCallsBloc, AssignedServiceCallsState>(
      bloc: parent._assignedServiceCallsBloc,
      builder: (context, assignedState) {
        return BlocBuilder<PendingServiceCallsBloc, PendingServiceCallsState>(
          bloc: parent._pendingServiceCallsBloc,
          builder: (context, pendingState) {
            int assignedCount = 0;
            if (assignedState is AssignedServiceCallsSuccessState) {
              assignedCount = assignedState.data.data.pagination.totalItems;
            } else if (assignedState is AssignedServiceCallsPaginationLoadingState) {
              assignedCount = assignedState.currentData.data.pagination.totalItems;
            }
            int pendingCount = 0;
            if (pendingState is PendingServiceCallsSuccessState) {
              pendingCount = pendingState.data.data.pagination.totalItems;
            } else if (pendingState is PendingServiceCallsPaginationLoadingState) {
              pendingCount = pendingState.currentData.data.pagination.totalItems;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      alignment: parent._selectedTab == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: parent._buildSegmentTab(
                            0,
                            'service_calls_tab_assigned'.tr(),
                            count: assignedCount,
                            isLoading: assignedState is AssignedServiceCallsLoadingState ||
                                assignedState is AssignedServiceCallsInitialState,
                          ),
                        ),
                        Expanded(
                          child: parent._buildSegmentTab(
                            1,
                            'service_calls_tab_pending'.tr(),
                            count: pendingCount,
                            isLoading: pendingState is PendingServiceCallsLoadingState ||
                                pendingState is PendingServiceCallsInitialState,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
