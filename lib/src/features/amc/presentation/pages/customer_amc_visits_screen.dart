import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';
import 'package:service_app/src/features/amc/bloc/customer_amc_visits_bloc/customer_amc_visits_bloc.dart';
import 'package:service_app/src/features/amc/bloc/customer_amc_visits_bloc/customer_amc_visits_event.dart';
import 'package:service_app/src/features/amc/bloc/customer_amc_visits_bloc/customer_amc_visits_state.dart';
import 'package:intl/intl.dart';
import 'package:service_app/src/features/amc/bloc/amc_visit_reports_bloc/amc_visit_reports_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_pdf_bloc/amc_report_pdf_bloc.dart';
import 'package:service_app/src/features/widgets/amc_report_card_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/features/report_history/presentation/pages/feedback_details_screen.dart';

class CustomerAmcVisitsScreen extends StatelessWidget {
  final String customerId;

  const CustomerAmcVisitsScreen({
    super.key,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CustomerAmcVisitsBloc>()
            ..add(GetCustomerAmcVisitsEvent(customerId)),
        ),
        BlocProvider(
          create: (context) => getIt<AmcReportPdfBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AmcReportPdfBloc, AmcReportPdfState>(
            listener: (context, state) {
              if (state is AmcReportPdfLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                  ),
                );
              } else if (state is AmcReportPdfFailure) {
                Navigator.pop(context);
                appSnackBar(context, const Color(0xFFF44336), state.error);
              } else if (state is AmcReportPdfSuccess) {
                Navigator.pop(context);
                final url = state.pdfUrl;
                if (url.isNotEmpty) {
                  final uri = Uri.parse(url);
                  final cacheClearUri = uri.replace(queryParameters: {
                    ...uri.queryParameters,
                    'v': DateTime.now().millisecondsSinceEpoch.toString(),
                  });
                  launchUrl(cacheClearUri, mode: LaunchMode.externalApplication);
                } else {
                  appSnackBar(context, const Color(0xFFF44336), 'pdf_url_is_empty'.tr());
                }
              }
            },
          ),
        ],
        child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'view_all_visits'.tr(),
                            style: AppFont.style(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<CustomerAmcVisitsBloc, CustomerAmcVisitsState>(
          builder: (context, state) {
            if (state is CustomerAmcVisitsLoading || state is CustomerAmcVisitsInitial) {
              return const _CustomerAmcVisitsShimmer();
            }

            if (state is CustomerAmcVisitsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: AppFont.family,
                  ),
                ),
              );
            }

            if (state is CustomerAmcVisitsSuccess) {
              final items = state.response.data?.results ?? [];
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'no_visits_found'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppFont.family,
                    ),
                  ),
                );
              }

              final firstItem = items.first;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeaderCard(firstItem),
                  const SizedBox(height: 16),
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CollapsibleVisitCard(item: item, defaultLocation: firstItem.siteName ?? ''),
                      )),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    ],
  ),
),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('close_call_customer_name_label'.tr(), item.customerName),
                    const SizedBox(height: 8),
                    _buildInfoRow('close_call_site_name_label'.tr(), item.siteName),
                    const SizedBox(height: 8),
                    _buildInfoRow('total_visits'.tr(), '${item.totalVisits}'),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'amc_duration'.tr(),
                      '${item.contractStart} - ${item.contractEnd}',
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(item.contractStatus),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: AppFont.family,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: AppFont.family,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildStatusBadge(String status) {
    final statusUpper = status.toUpperCase();
    Color bgColor;
    Color textColor;

    if (statusUpper == 'ACTIVE' || statusUpper == 'COMPLETED') {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF4CAF50);
    } else if (statusUpper == 'PENDING') {
      bgColor = const Color(0xFFFFF8E1);
      textColor = const Color(0xFFFFB300);
    } else if (statusUpper == 'EXPIRED') {
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFF44336);
    } else {
      bgColor = Colors.grey[200]!;
      textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusUpper,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: AppFont.family,
        ),
      ),
    );
  }
}

class _CollapsibleVisitCard extends StatefulWidget {
  final dynamic item;
  final String defaultLocation;

  const _CollapsibleVisitCard({
    required this.item,
    required this.defaultLocation,
  });

  @override
  State<_CollapsibleVisitCard> createState() => _CollapsibleVisitCardState();
}

class _CollapsibleVisitCardState extends State<_CollapsibleVisitCard> {
  bool _isExpanded = false;
  late AmcVisitReportsBloc _reportsBloc;

  @override
  void initState() {
    super.initState();
    _reportsBloc = getIt<AmcVisitReportsBloc>();
  }

  @override
  void dispose() {
    _reportsBloc.close();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded && _reportsBloc.state is AmcVisitReportsInitialState) {
        _reportsBloc.add(AmcVisitReportsGetEvent(visitId: widget.item.visitId));
      }
    });
  }

  void _showQrCodeDialog(BuildContext context) {
    final qrCodeImage = widget.item.qrCodeImage ?? widget.item.qrCodeUrl;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFFA5ABB7)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'amc_report_feedback'.tr(),
                  textAlign: TextAlign.center,
                  style: AppFont.style(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F2F6)),
                  ),
                  child: qrCodeImage != null && qrCodeImage.toString().isNotEmpty
                      ? Image.network(
                          qrCodeImage,
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.qr_code_2,
                          size: 180,
                          color: Color(0xFF0D121F),
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  'create_report_scan_feedback'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusUpper = status.toUpperCase();
    Color bgColor;
    Color textColor;

    if (statusUpper == 'ACTIVE' || statusUpper == 'COMPLETED') {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF4CAF50);
    } else if (statusUpper == 'PENDING') {
      bgColor = const Color(0xFFFFF8E1);
      textColor = const Color(0xFFFFB300);
    } else if (statusUpper == 'EXPIRED') {
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFF44336);
    } else {
      bgColor = Colors.grey[200]!;
      textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusUpper,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: AppFont.family,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F2F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Visit ${widget.item.visitNumber}',
                        style: TextStyle(
                          color: const Color(0xFF4F46E5),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFont.family,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildStatusBadge(widget.item.visitStatus),
                    if (widget.item.feedbackSubmitted)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackDetailsScreen(
                                reportId: widget.item.visitId,
                                isServiceCall: false,
                                isAmc: true,
                                title: 'amc_feedback_details'.tr(),
                                onBack: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.check_circle, color: Colors.green, size: 24),
                        ),
                      )
                    else if (widget.item.qrCodeImage != null || widget.item.qrCodeUrl != null)
                      GestureDetector(
                        onTap: () => _showQrCodeDialog(context),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Image.asset('assets/images/qr_icon.png', width: 24, height: 24, errorBuilder: (c,e,s) => const Icon(Icons.qr_code, size: 24, color: Colors.orange)),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${'amc_schedule_window'.tr()} : ${widget.item.visitFromDate} - ${widget.item.visitToDate}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFont.family,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          BlocBuilder<AmcVisitReportsBloc, AmcVisitReportsState>(
            bloc: _reportsBloc,
            builder: (context, state) {
              if (state is AmcVisitReportsLoadingState) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: AmcReportCardShimmer(isFromHistory: true),
                );
              }
              if (state is AmcVisitReportsFailureState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)),
                );
              }
              if (state is AmcVisitReportsSuccessState) {
                final reportsCount = state.data.data.reports.length;
                if (reportsCount == 0) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('no_reports_found'.tr()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: List.generate(reportsCount, (index) {
                      final report = state.data.data.reports[index];
                      final isSubmitted = report.status.toLowerCase() == 'submitted';
                      String? submittedDateStr;
                      if (report.submittedAt != null && report.submittedAt!.isNotEmpty) {
                        try {
                          final dt = DateTime.parse(report.submittedAt!).toLocal();
                          submittedDateStr = DateFormat('d MMM yyyy', context.locale.languageCode).format(dt);
                        } catch (e) {
                          submittedDateStr = report.submittedAt;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${'report'.tr()} ${index + 1}',
                                  style: AppFont.style(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0D121F),
                                  ),
                                ),
                                Text(
                                  submittedDateStr ?? 'not_submitted'.tr(),
                                  style: AppFont.style(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Color(0xFFA5ABB7),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    report.siteName ?? widget.defaultLocation,
                                    style: AppFont.style(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF7A8699),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF9FAFB),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    size: 20,
                                    color: Color(0xFFCDD0D8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report.technicianRepresentativeName ?? 'unknown_technician'.tr(),
                                        style: AppFont.style(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF0D121F),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        report.dealerName ?? '',
                                        style: AppFont.style(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFA5ABB7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSubmitted ? const Color(0xFFE8F5E9) : const Color(0xFFFFE0B2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isSubmitted ? 'submitted'.tr() : 'draft'.tr(),
                                    style: AppFont.style(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isSubmitted ? const Color(0xFF00A76F) : const Color(0xFFE65100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (report.id != null) {
                                    context.read<AmcReportPdfBloc>().add(FetchAmcReportPdfEvent(reportId: report.id!));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${'view_report'.tr()} ${index + 1}',
                                      style: AppFont.style(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
      ],
    );
  }
}

class _CustomerAmcVisitsShimmer extends StatelessWidget {
  const _CustomerAmcVisitsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderShimmer(),
        const SizedBox(height: 16),
        ...List.generate(4, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildVisitShimmer(),
        )),
      ],
    );
  }

  Widget _buildHeaderShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 16, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(width: 120, height: 16, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(width: 100, height: 16, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(width: 180, height: 16, color: Colors.white),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
