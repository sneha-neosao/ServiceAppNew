import 'package:service_app/src/core/theme/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/amc/bloc/amc_visit_reports_bloc/amc_visit_reports_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_pdf_bloc/amc_report_pdf_bloc.dart';
import 'package:service_app/src/features/widgets/amc_report_card_shimmer.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:service_app/src/features/amc/bloc/delete_amc_report_bloc/delete_amc_report_bloc.dart';
import 'package:service_app/src/features/amc/bloc/delete_amc_report_bloc/delete_amc_report_event.dart';
import 'package:service_app/src/features/amc/bloc/delete_amc_report_bloc/delete_amc_report_state.dart';

class AmcVisitDetailsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final Function(String, int) onEditReport;
  final VoidCallback? onCompleteAmcWork;
  final String visitId;
  final String title;
  final String location;
  final String visitInfo;
  final String window;
  final int reportsCreated;
  final bool isFromHistory;

  const AmcVisitDetailsScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
    required this.onEditReport,
    this.onCompleteAmcWork,
    required this.visitId,
    required this.title,
    required this.location,
    required this.visitInfo,
    required this.window,
    this.reportsCreated = 0,
    this.isFromHistory = false,
  });

  @override
  State<AmcVisitDetailsScreen> createState() => _AmcVisitDetailsScreenState();
}

class _AmcVisitDetailsScreenState extends State<AmcVisitDetailsScreen> {
  late AmcVisitReportsBloc _reportsBloc;
  late AmcReportPdfBloc _pdfBloc;
  late DeleteAmcReportBloc _deleteAmcReportBloc;

  @override
  void initState() {
    super.initState();
    _reportsBloc = getIt<AmcVisitReportsBloc>();
    _pdfBloc = getIt<AmcReportPdfBloc>();
    _deleteAmcReportBloc = getIt<DeleteAmcReportBloc>();
    _reportsBloc.add(AmcVisitReportsGetEvent(visitId: widget.visitId));
  }

  @override
  void dispose() {
    _reportsBloc.close();
    _deleteAmcReportBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _reportsBloc),
        BlocProvider.value(value: _pdfBloc),
        BlocProvider.value(value: _deleteAmcReportBloc),
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
                    child: CircularProgressIndicator(
                      color: AppColor.colorFF1565C0,
                    ),
                  ),
                );
              } else if (state is AmcReportPdfFailure) {
                Navigator.pop(context);
                appSnackBar(context, AppColor.bright_red, state.error);
              } else if (state is AmcReportPdfSuccess) {
                Navigator.pop(context);
                final url = state.pdfUrl;
                if (url.isNotEmpty) {
                  final uri = Uri.parse(url);
                  final cacheClearUri = uri.replace(
                    queryParameters: {
                      ...uri.queryParameters,
                      'v': DateTime.now().millisecondsSinceEpoch.toString(),
                    },
                  );
                  launchUrl(
                    cacheClearUri,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  appSnackBar(
                    context,
                    AppColor.bright_red,
                    'pdf_url_is_empty'.tr(),
                  );
                }
              }
            },
          ),
          BlocListener<DeleteAmcReportBloc, DeleteAmcReportState>(
            listener: (context, state) {
              if (state is DeleteAmcReportSuccessState) {
                appSnackBar(
                  context,
                  AppColor.green,
                  state.data.message ?? 'report_deleted_successfully'.tr(),
                );
                _reportsBloc.add(
                  AmcVisitReportsGetEvent(visitId: widget.visitId),
                );
              } else if (state is DeleteAmcReportFailureState) {
                appSnackBar(context, AppColor.bright_red, state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<AmcVisitReportsBloc, AmcVisitReportsState>(
          bloc: _reportsBloc,
          builder: (context, state) {
            int reportsCount = widget.reportsCreated;
            bool isLoading = state is AmcVisitReportsLoadingState;
            bool hasDraftReport = false;

            String visitStatus = 'amc_details_status_progress'.tr();
            Color badgeBorderColor = AppColor.colorFF1565C0;
            Color badgeTextColor = AppColor.colorFF1565C0;
            Color badgeBgColor = AppColor.colorFFC2E2FE;
            String visitRangeStr = widget.window;

            if (state is AmcVisitReportsSuccessState) {
              reportsCount = state.data.data.reports.length;
              hasDraftReport = state.data.data.reports.any(
                (report) => report.status.toLowerCase() == 'draft',
              );
              final statusString = state.data.data.visit.status.toLowerCase();

              try {
                final fDate = state.data.data.visit.fromDate;
                final tDate = state.data.data.visit.toDate;
                if (fDate.isNotEmpty && tDate.isNotEmpty) {
                  final fDt = DateTime.parse(fDate).toLocal();
                  final tDt = DateTime.parse(tDate).toLocal();
                  visitRangeStr =
                      '${DateFormat('d MMM yyyy', context.locale.languageCode).format(fDt)} ${'to'.tr()} ${DateFormat('d MMM yyyy', context.locale.languageCode).format(tDt)}';
                } else if (fDate.isNotEmpty) {
                  final fDt = DateTime.parse(fDate).toLocal();
                  visitRangeStr = DateFormat(
                    'd MMM yyyy',
                    context.locale.languageCode,
                  ).format(fDt);
                }
              } catch (_) {}

              if (statusString == 'pending') {
                visitStatus = 'pending'.tr();
                badgeBorderColor = Colors.transparent;
                badgeTextColor = AppColor.colorFFF44336;
                badgeBgColor = AppColor.colorFFFFEBEE;
              } else if (statusString == 'completed') {
                visitStatus = 'completed'.tr();
                badgeBorderColor = Colors.transparent;
                badgeTextColor = AppColor.colorFF00A76F;
                badgeBgColor = AppColor.colorFFE8F5E9;
              } else {
                visitStatus = state.data.data.visit.status;
                if (visitStatus.isNotEmpty) {
                  visitStatus =
                      visitStatus[0].toUpperCase() + visitStatus.substring(1);
                }
              }
            }
            return Column(
              children: [
                // ── Header ────────────────────────────────────────────────
                if (widget.isFromHistory)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: AppColor.colorFF5C616E,
                            ),
                            onPressed: widget.onBack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${'total_visits'.tr()} ($reportsCount)',
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.colorFF0D121F,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                visitRangeStr,
                                style: AppFont.style(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.colorFF0D121F,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.title,
                                style: AppFont.style(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.colorFF7A8699,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColor.colorFF1565C0,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.location,
                                      style: AppFont.style(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.colorFFA5ABB7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: badgeBorderColor != Colors.transparent
                                ? Border.all(color: badgeBorderColor)
                                : null,
                          ),
                          child: Text(
                            visitStatus,
                            style: AppFont.style(
                              fontSize: 6,
                              fontWeight: FontWeight.w800,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
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
                              color: AppColor.colorFF5C616E,
                            ),
                            onPressed: widget.onBack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.colorFF0D121F,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColor.colorFF1565C0,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.location,
                                      style: AppFont.style(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.colorFFA5ABB7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── Scrollable body ──────────────────────────────────────────────────
                Expanded(
                  child: RefreshIndicator(
                    color: AppColor.colorFF0B68B9,
                    onRefresh: () async {
                      _reportsBloc.add(
                        AmcVisitReportsGetEvent(visitId: widget.visitId),
                      );
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Visit Info Card ────────────────────────────────────────
                          if (!widget.isFromHistory)
                            if (isLoading)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),
                                        blurRadius: 12,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ── Badges row ──────────────────────────────────────
                                      Row(
                                        children: [
                                          _OutlineBadge(
                                            label: visitStatus,
                                            borderColor: badgeBorderColor,
                                            textColor: badgeTextColor,
                                            bgColor: badgeBgColor,
                                          ),
                                          const SizedBox(width: 10),
                                          _OutlineBadge(
                                            label: widget.visitInfo,
                                            borderColor: AppColor.colorFF1B5E20,
                                            textColor: AppColor.colorFF1B5E20,
                                            bgColor: AppColor.colorFFC8E6C9,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // ── Visit range ─────────────────────────────────────
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'amc_details_visit_window'.tr(),
                                            style: AppFont.style(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.colorFF0D121F,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            visitRangeStr,
                                            style: AppFont.style(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.colorFF1565C0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (reportsCount == 0) ...[
                                        const SizedBox(height: 20),
                                        // ── Submit button ───────────────────────────────────
                                        GestureDetector(
                                          onTap: widget.onSubmit,
                                          child: Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: AppColor.colorFF1565C0,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4.0,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.check_box_outlined,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      'amc_details_submit_btn'
                                                          .tr(),
                                                      style: AppFont.style(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),

                          if (!widget.isFromHistory) const SizedBox(height: 20),

                          // ── Reports Created label ──────────────────────────────────
                          if (!widget.isFromHistory)
                            Center(
                              child: Text(
                                reportsCount > 0
                                    ? '${'amc_details_reports_created'.tr()} ($reportsCount)'
                                    : '${'amc_details_reports_created'.tr()} (0)',
                                style: AppFont.style(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.colorFFA5ABB7,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),

                          if (isLoading)
                            AmcReportCardShimmer(
                              isFromHistory: widget.isFromHistory,
                            )
                          else if (reportsCount > 0) ...[
                            const SizedBox(height: 16),

                            ...List.generate(reportsCount, (index) {
                              bool isSubmitted = false;
                              String? submittedDateStr;
                              String? reportId;
                              if (state is AmcVisitReportsSuccessState) {
                                final report = state.data.data.reports[index];
                                reportId = report.id;
                                isSubmitted =
                                    report.status.toLowerCase() == 'submitted';
                                if (report.submittedAt != null &&
                                    report.submittedAt!.isNotEmpty) {
                                  try {
                                    final dt = DateTime.parse(
                                      report.submittedAt!,
                                    ).toLocal();
                                    submittedDateStr = DateFormat(
                                      'd MMM yyyy',
                                      context.locale.languageCode,
                                    ).format(dt);
                                  } catch (e) {
                                    submittedDateStr = report.submittedAt;
                                  }
                                }
                              }

                              if (widget.isFromHistory) {
                                final report =
                                    state is AmcVisitReportsSuccessState
                                    ? state.data.data.reports[index]
                                    : null;
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: 12,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title & Date Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${'report'.tr()} ${reportsCount - index}',
                                            style: AppFont.style(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.colorFF0D121F,
                                            ),
                                          ),
                                          Text(
                                            submittedDateStr ??
                                                'not_submitted'.tr(),
                                            style: AppFont.style(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w800,
                                              color: AppColor.colorFFA5ABB7,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Location Row
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                            color: AppColor.colorFFA5ABB7,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              report?.siteName ??
                                                  widget.location,
                                              style: AppFont.style(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                color: AppColor.colorFF7A8699,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: AppColor.colorFFF1F2F6,
                                      ),
                                      const SizedBox(height: 16),
                                      // Technician Row
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: AppColor.colorFFF9FAFB,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.person_outline,
                                              size: 20,
                                              color: AppColor.colorFFCDD0D8,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  report?.technicianRepresentativeName ??
                                                      'unknown_technician'.tr(),
                                                  style: AppFont.style(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        AppColor.colorFF0D121F,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  report?.dealerName ?? '',
                                                  style: AppFont.style(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.w800,
                                                    color:
                                                        AppColor.colorFFA5ABB7,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              color: isSubmitted
                                                  ? AppColor.colorFFE8F5E9
                                                  : AppColor.colorFFFFE0B2,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              isSubmitted
                                                  ? 'submitted'.tr()
                                                  : 'draft'.tr(),
                                              style: AppFont.style(
                                                fontSize: 6,
                                                fontWeight: FontWeight.w800,
                                                color: isSubmitted
                                                    ? AppColor.colorFF00A76F
                                                    : AppColor.colorFFE65100,
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
                                            if (reportId != null) {
                                              _pdfBloc.add(
                                                FetchAmcReportPdfEvent(
                                                  reportId: reportId,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.colorFF1565C0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${'view_report'.tr()} ${reportsCount - index}',
                                                style: AppFont.style(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.chevron_right,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isSubmitted
                                            ? AppColor.colorFFE8F5E9
                                            : AppColor.colorFFFFF3E0,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        isSubmitted
                                            ? Icons.check_circle_outline
                                            : Icons.info_outline,
                                        color: isSubmitted
                                            ? AppColor.colorFF00A76F
                                            : AppColor.colorFFFF9800,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${'report'.tr()} ${reportsCount - index}',
                                                style: AppFont.style(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColor.colorFF0D121F,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isSubmitted
                                                      ? AppColor.colorFFE8F5E9
                                                      : AppColor.colorFFFFE0B2,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  isSubmitted
                                                      ? 'submitted'.tr()
                                                      : 'draft'.tr(),
                                                  style: AppFont.style(
                                                    fontSize: 6,
                                                    fontWeight: FontWeight.w800,
                                                    color: isSubmitted
                                                        ? AppColor.colorFF00A76F
                                                        : AppColor
                                                              .colorFFE65100,
                                                  ),
                                                ),
                                              ),
                                              if (!isSubmitted) ...[
                                                const Spacer(),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color:
                                                        AppColor.colorFF1565C0,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    if (reportId != null &&
                                                        state
                                                            is AmcVisitReportsSuccessState) {
                                                      final r = state
                                                          .data
                                                          .data
                                                          .reports[index];
                                                      widget.onEditReport(
                                                        reportId,
                                                        r.stepNo,
                                                      );
                                                    }
                                                  },
                                                  constraints:
                                                      const BoxConstraints(),
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 8,
                                                        right: 4,
                                                      ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color:
                                                        AppColor.colorFFF44336,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    if (reportId != null) {
                                                      _showDeleteDialog(
                                                        context,
                                                        reportId,
                                                      );
                                                    }
                                                  },
                                                  constraints:
                                                      const BoxConstraints(),
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 4,
                                                      ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            isSubmitted &&
                                                    submittedDateStr != null
                                                ? '${'submitted_on'.tr()} $submittedDateStr'
                                                : 'not_submitted'.tr(),
                                            style: AppFont.style(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.colorFFA5ABB7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // + Create Another Report (dashed)
                            if (!widget.isFromHistory)
                              GestureDetector(
                                onTap: hasDraftReport ? null : widget.onSubmit,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hasDraftReport
                                        ? AppColor.colorFFE5E7EB
                                        : AppColor.colorFFF3F8FF,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: hasDraftReport
                                            ? AppColor.colorFFA5ABB7
                                            : AppColor.colorFF1565C0,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'create_another_report'.tr(),
                                          style: AppFont.style(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w800,
                                            color: hasDraftReport
                                                ? AppColor.colorFFA5ABB7
                                                : AppColor.colorFF1565C0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Bottom "Complete AMC Work" bar ───────────────────────────────────
                if (!widget.isFromHistory)
                  Container(
                    color: AppColor.colorFFF8F8F8,
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                    child: GestureDetector(
                      onTap: (reportsCount > 0 && !hasDraftReport)
                          ? () => _showCompleteAmcAlert(context)
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (reportsCount > 0 && !hasDraftReport)
                              ? AppColor.colorFF1565C0
                              : AppColor.colorFFECEFF1,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: (reportsCount > 0 && !hasDraftReport)
                                    ? Colors.white
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'amc_details_complete_btn'.tr(),
                                  style: AppFont.style(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: (reportsCount > 0 && !hasDraftReport)
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCompleteAmcAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColor.colorFFFFF8E1,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: AppColor.colorFFFF9800,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'finish_amc_work'.tr(),
                  style: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColor.colorFF0D121F,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'finish_amc_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppFont.style(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColor.colorFF6B7280,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      widget.onCompleteAmcWork?.call();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.colorFF1565C0,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'yes_complete'.tr(),
                          style: AppFont.style(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Container(
                    height: 44,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'cancel'.tr(),
                      style: AppFont.style(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColor.colorFFA5ABB7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String reportId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocListener<DeleteAmcReportBloc, DeleteAmcReportState>(
          bloc: _deleteAmcReportBloc,
          listener: (context, state) {
            if (state is DeleteAmcReportSuccessState ||
                state is DeleteAmcReportFailureState) {
              Navigator.of(dialogContext).pop();
            }
          },
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Icon ───────────────────────────────────────────────────────
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: AppColor.colorFFFFF1F0,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          color: AppColor.colorFFFF4D4F,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Title ───────────────────────────────────────────────────────
                      Text(
                        'delete_draft_report'.tr(),
                        style: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColor.colorFF0D121F,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Subtitle ────────────────────────────────────────────────────
                      Text(
                        'delete_draft_subtitle'.tr(),
                        textAlign: TextAlign.center,
                        style: AppFont.style(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColor.colorFF5C616E,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Buttons ─────────────────────────────────────────────────────
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColor.colorFFF6F6F6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'cancel'.tr(),
                                  style: AppFont.style(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColor.colorFF0D121F,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Delete Button
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child:
                                  BlocBuilder<
                                    DeleteAmcReportBloc,
                                    DeleteAmcReportState
                                  >(
                                    bloc: _deleteAmcReportBloc,
                                    builder: (context, state) {
                                      bool isLoading =
                                          state is DeleteAmcReportLoadingState;
                                      return ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                _deleteAmcReportBloc.add(
                                                  DeleteAmcReportSubmitEvent(
                                                    reportId,
                                                  ),
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColor.colorFFE30000,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Text(
                                                'Delete'.tr(),
                                                style: AppFont.style(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Close (X) Icon ────────────────────────────────────────────────
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColor.colorFFB0B8C8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Outlined badge (border only, no fill) ──────────────────────────────────────
class _OutlineBadge extends StatelessWidget {
  final String label;
  final Color borderColor;
  final Color textColor;
  final Color bgColor;

  const _OutlineBadge({
    required this.label,
    required this.borderColor,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: borderColor != Colors.transparent
            ? Border.all(color: borderColor, width: 1.5)
            : null,
      ),
      child: Text(
        label,
        style: AppFont.style(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
