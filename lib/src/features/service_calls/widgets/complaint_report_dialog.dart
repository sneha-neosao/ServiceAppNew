import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_details_bloc/service_call_details_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_details_bloc/service_call_details_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_details_bloc/service_call_details_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_complaint_pdf_bloc/service_call_complaint_pdf_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_complaint_pdf_bloc/service_call_complaint_pdf_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_complaint_pdf_bloc/service_call_complaint_pdf_state.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:service_app/src/core/theme/app_color.dart';

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
  late ServiceCallComplaintPdfBloc _pdfBloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ServiceCallDetailsBloc>()
      ..add(ServiceCallDetailsGetEvent(widget.complaintId));
    _pdfBloc = getIt<ServiceCallComplaintPdfBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
    _pdfBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCallComplaintPdfBloc, ServiceCallComplaintPdfState>(
      bloc: _pdfBloc,
      listener: (context, state) {
        if (state is ServiceCallComplaintPdfLoading) {
          // Loading is handled inline on the button
        } else if (state is ServiceCallComplaintPdfError) {
          appSnackBar(context, AppColor.bright_red, state.message);
        } else if (state is ServiceCallComplaintPdfLoaded) {
          final url = state.response.data?.pdfUrl;
          if (url != null && url.isNotEmpty) {
            final uri = Uri.parse(url);
            final cacheClearUri = uri.replace(queryParameters: {
              ...uri.queryParameters,
              'v': DateTime.now().millisecondsSinceEpoch.toString(),
            });
            launchUrl(cacheClearUri, mode: LaunchMode.externalApplication);
          } else {
            appSnackBar(context, AppColor.bright_red, 'pdf_url_is_empty'.tr());
          }
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
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
                  const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'complaint_report_title'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFFA5ABB7), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
              const SizedBox(height: 24),

              Flexible(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: BlocBuilder<ServiceCallDetailsBloc, ServiceCallDetailsState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is ServiceCallDetailsLoadingState || state is ServiceCallDetailsInitialState) {
                        return SingleChildScrollView(child: _buildShimmer());
                      } else if (state is ServiceCallDetailsFailureState) {
                        return SingleChildScrollView(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                state.message,
                                style: AppFont.style(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      } else if (state is ServiceCallDetailsSuccessState) {
                        final data = state.data.data;
                        final dateStr = data.createdAt.isNotEmpty
                            ? DateFormat('dd MMM yyyy (hh:mm a)').format(DateTime.parse(data.createdAt).toLocal())
                            : '-';

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Complaint Number
                              _buildInfoItem('complaint_report_no_label'.tr(), data.complaintNumber, isLarge: true),
                              const SizedBox(height: 16),
                              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                              const SizedBox(height: 16),
                              // Grid
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildInfoItem('complaint_report_client_label'.tr(), data.customerName),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem('complaint_date_and_time'.tr(), dateStr),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildInfoItem('close_call_site_name_label'.tr(), data.siteName),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem('contact_person'.tr(), data.name),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildInfoItem('equipment_model'.tr(), data.equipmentModelName),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem('contact_number'.tr(), data.contactNumber),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Issue Details
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFF1F2F6)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'complaint_description'.tr(),
                                      style: AppFont.style(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFA5ABB7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data.complaintDetails.isNotEmpty ? data.complaintDetails : '-',
                                      style: AppFont.style(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF424B5C),
                                        height: 1.5,
                                      ).copyWith(fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                              ),
                              if (data.assignedTechnicians.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                                const SizedBox(height: 16),
                                Text(
                                  'assigned_technicians'.tr(),
                                  style: AppFont.style(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: data.assignedTechnicians.map<Widget>((tech) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFF1F2F6)),
                                      ),
                                      child: Text(
                                        '${tech['name']} (${tech['phone']})',
                                        style: AppFont.style(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF424B5C),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                              if (data.attachments.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                                const SizedBox(height: 16),
                                Text(
                                  'attachments'.tr(),
                                  style: AppFont.style(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.5,
                                  ),
                                  itemCount: data.attachments.length,
                                  itemBuilder: (context, index) {
                                    final imageUrl = data.attachments[index]['image']?.toString() ?? '';
                                    return GestureDetector(
                                      onTap: () {
                                        if (imageUrl.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Scaffold(
                                                backgroundColor: Colors.black,
                                                appBar: AppBar(
                                                  backgroundColor: Colors.black,
                                                  iconTheme: const IconThemeData(color: Colors.white),
                                                ),
                                                body: Center(
                                                  child: InteractiveViewer(
                                                    child: Image.network(imageUrl),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],

                              // ── Complaint PDF Button ────────────────────────────────────
                              const SizedBox(height: 24),
                              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                              const SizedBox(height: 16),
                              BlocBuilder<ServiceCallComplaintPdfBloc, ServiceCallComplaintPdfState>(
                                bloc: _pdfBloc,
                                builder: (context, pdfState) {
                                  final isLoading = pdfState is ServiceCallComplaintPdfLoading;
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              _pdfBloc.add(
                                                FetchServiceCallComplaintPdfEvent(
                                                  complaintId: widget.complaintId,
                                                  action: ServiceCallComplaintPdfAction.view,
                                                ),
                                              );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1565C0),
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: const Color(0xFF1565C0).withValues(alpha: 0.6),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: isLoading
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.download, size: 20),
                                      label: Text(
                                        isLoading ? 'generating_pdf'.tr() : 'reports_view_complaint'.tr(),
                                        style: AppFont.style(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isLarge = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFont.style(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppFont.style(
            fontSize: isLarge ? 18 : 11,
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
