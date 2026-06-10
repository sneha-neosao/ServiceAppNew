import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/amc/bloc/amc_visit_reports_bloc/amc_visit_reports_bloc.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';

class AmcVisitDetailsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final Function(String) onEditReport;
  final VoidCallback? onCompleteAmcWork;
  final String visitId;
  final String title;
  final String location;
  final String visitInfo;
  final String window;
  final int reportsCreated;

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
  });

  @override
  State<AmcVisitDetailsScreen> createState() => _AmcVisitDetailsScreenState();
}

class _AmcVisitDetailsScreenState extends State<AmcVisitDetailsScreen> {
  late AmcVisitReportsBloc _reportsBloc;

  @override
  void initState() {
    super.initState();
    _reportsBloc = getIt<AmcVisitReportsBloc>()
      ..add(AmcVisitReportsGetEvent(visitId: widget.visitId));
  }

  @override
  void dispose() {
    _reportsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AmcVisitReportsBloc, AmcVisitReportsState>(
      bloc: _reportsBloc,
      builder: (context, state) {
        int reportsCount = widget.reportsCreated;
        bool isLoading = state is AmcVisitReportsLoadingState;
        
        String visitStatus = 'amc_details_status_progress'.tr();
        Color badgeBorderColor = const Color(0xFF1565C0);
        Color badgeTextColor = const Color(0xFF1565C0);
        Color badgeBgColor = const Color(0xFFC2E2FE);

        if (state is AmcVisitReportsSuccessState) {
          reportsCount = state.data.data.reports.length;
          final statusString = state.data.data.visit.status.toLowerCase();
          
          if (statusString == 'pending') {
            visitStatus = 'Pending';
            badgeBorderColor = const Color(0xFFE65100);
            badgeTextColor = const Color(0xFFE65100);
            badgeBgColor = const Color(0xFFFFE0B2);
          } else if (statusString == 'completed') {
            visitStatus = 'Completed';
            badgeBorderColor = const Color(0xFF1B5E20);
            badgeTextColor = const Color(0xFF1B5E20);
            badgeBgColor = const Color(0xFFC8E6C9);
          } else {
            visitStatus = state.data.data.visit.status;
            if (visitStatus.isNotEmpty) {
              visitStatus = visitStatus[0].toUpperCase() + visitStatus.substring(1);
            }
          }
        }
    return Column(
      children: [
        // ── Scrollable body ──────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────
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
                          onPressed: widget.onBack,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: AppFont.style(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Color(0xFF1565C0),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.location,
                                style: AppFont.style(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFA5ABB7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Visit Info Card ────────────────────────────────────────
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              borderColor: const Color(0xFF1B5E20),
                              textColor: const Color(0xFF1B5E20),
                              bgColor: Color(0xFFC8E6C9),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Visit range ─────────────────────────────────────
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${'amc_details_visit_window'.tr()}: ',
                                style: AppFont.style(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0D121F),
                                ),
                              ),
                              TextSpan(
                                text: widget.window,
                                style: AppFont.style(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (reportsCount == 0) ...[
                          const SizedBox(height: 20),
                          // ── Submit button ───────────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: widget.onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'amc_details_submit_btn'.tr(),
                                    style: AppFont.style(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Reports Created label ──────────────────────────────────
                Center(
                  child: Text(
                    reportsCount > 0
                        ? '${'amc_details_reports_created'.tr()} ($reportsCount)'
                        : '${'amc_details_reports_created'.tr()} (0)',
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: ListCardShimmer(),
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
                      isSubmitted = report.status.toLowerCase() == 'submitted';
                      if (report.submittedAt != null && report.submittedAt!.isNotEmpty) {
                        try {
                          final dt = DateTime.parse(report.submittedAt!).toLocal();
                          submittedDateStr = DateFormat('d MMM yyyy').format(dt);
                        } catch (e) {
                          submittedDateStr = report.submittedAt;
                        }
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 16,
                      ),
                      padding: const EdgeInsets.all(20),
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
                              color: isSubmitted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isSubmitted ? Icons.check_circle_outline : Icons.info_outline,
                              color: isSubmitted ? const Color(0xFF00A76F) : const Color(0xFFFF9800),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Report ${index + 1}',
                                      style: AppFont.style(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF0D121F),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSubmitted ? const Color(0xFFE8F5E9) : const Color(0xFFFFE0B2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        isSubmitted ? 'SUBMITTED' : 'DRAFT',
                                        style: AppFont.style(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isSubmitted ? const Color(0xFF00A76F) : const Color(0xFFE65100),
                                        ),
                                      ),
                                    ),
                                    if (!isSubmitted) ...[
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF1565C0), size: 20),
                                        onPressed: () {
                                          if (reportId != null) {
                                            widget.onEditReport(reportId);
                                          }
                                        },
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.only(left: 8, right: 4),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Color(0xFFF44336), size: 20),
                                        onPressed: () {
                                          // TODO: Delete action
                                        },
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.only(left: 4),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isSubmitted && submittedDateStr != null
                                      ? 'Submitted on $submittedDateStr'
                                      : 'Not submitted',
                                  style: AppFont.style(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFA5ABB7),
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
                  GestureDetector(
                    onTap: widget.onSubmit,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Color(0xFF1565C0),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Create Another Report',
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // ── Bottom "Complete AMC Work" bar ───────────────────────────────────
        Container(
          color: const Color(0xFFF8F8F8),
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
          child: GestureDetector(
            onTap: reportsCount > 0 ? widget.onCompleteAmcWork : null,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: reportsCount > 0
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFECEFF1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: reportsCount > 0
                        ? Colors.white
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'amc_details_complete_btn'.tr(),
                    style: AppFont.style(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: reportsCount > 0
                          ? Colors.white
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        label,
        style: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
