import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_details_bloc/service_call_details_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_details_bloc/service_call_details_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_details_bloc/service_call_details_state.dart';

class ComplaintReportDialog extends StatefulWidget {
  final String complaintId;

  const ComplaintReportDialog({
    super.key,
    required this.complaintId,
  });

  @override
  State<ComplaintReportDialog> createState() => _ComplaintReportDialogState();
}

class _ComplaintReportDialogState extends State<ComplaintReportDialog> {
  late ServiceCallDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ServiceCallDetailsBloc>()
      ..add(ServiceCallDetailsGetEvent(widget.complaintId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'complaint_report_title'.tr(),
                  style: AppFont.style(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFA5ABB7)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            BlocBuilder<ServiceCallDetailsBloc, ServiceCallDetailsState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is ServiceCallDetailsLoadingState || state is ServiceCallDetailsInitialState) {
                  return _buildShimmer();
                } else if (state is ServiceCallDetailsFailureState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        state.message,
                        style: AppFont.style(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (state is ServiceCallDetailsSuccessState) {
                  final data = state.data.data;
                  final dateStr = data.createdAt.isNotEmpty
                      ? DateFormat('dd MMM yyyy').format(DateTime.parse(data.createdAt).toLocal())
                      : '-';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'complaint_report_no_label'.tr(),
                              data.complaintNumber,
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'complaint_report_received_label'.tr(),
                              dateStr,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInfoItem('complaint_report_client_label'.tr(), data.customerName),
                      const SizedBox(height: 24),
                      _buildInfoItem('complaint_report_site_label'.tr(), data.siteName),
                      const SizedBox(height: 32),
                      // Issue Details
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'complaint_report_issue_label'.tr(),
                              style: AppFont.style(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFA5ABB7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.complaintDetails.isNotEmpty ? data.complaintDetails : '-',
                              style: AppFont.style(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF424B5C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Download Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Icon(Icons.file_download_outlined, size: 20),
                              // const SizedBox(width: 10),
                              Text(
                                'complaint_report_btn_download'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0D121F),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 12, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 16, color: Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 12, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(width: 80, height: 12, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 16, color: Colors.white),
          const SizedBox(height: 24),
          Container(width: 80, height: 12, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 16, color: Colors.white),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }
}
