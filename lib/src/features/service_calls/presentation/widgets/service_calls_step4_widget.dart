part of '../pages/service_calls_screen.dart';

class ServiceCallsStep4Widget extends StatelessWidget {
  final _ServiceCallsScreenState parent;
  const ServiceCallsStep4Widget({super.key, required this.parent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: parent._buildComplaintInput()),
            const SizedBox(width: 12),
            Expanded(child: parent._buildDateInput()),
          ],
        ),
        const SizedBox(height: 16),
        // Clear Filters Button
        GestureDetector(
          onTap: () {
            parent.updateState(() {
              parent._selectedCustomerName = null;
              parent._selectedCustomerId = null;
              parent._selectedSiteName = null;
              parent._selectedSiteId = null;
              parent._selectedDate = null;
              parent._complaintController.clear();
              parent._pendingCustomerController.clear();
              parent._pendingSiteController.clear();
            });
            parent._fetchServiceCalls(isRefresh: true);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.refresh,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'service_calls_clear_filters'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
