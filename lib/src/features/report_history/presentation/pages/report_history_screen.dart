import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_history_bloc/commissioning_report_history_state.dart';
import 'package:service_app/src/features/amc/presentation/bloc/amc_reports_history_bloc/amc_reports_history_bloc.dart';
import 'package:service_app/src/features/amc/presentation/bloc/amc_reports_history_bloc/amc_reports_history_event.dart';
import 'package:service_app/src/features/amc/presentation/bloc/amc_reports_history_bloc/amc_reports_history_state.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/remote/models/customer_model/customer_response.dart';
import 'package:service_app/src/remote/models/sites_model/sites_response.dart';
import 'package:service_app/src/remote/models/technician_model/technician_response.dart';
import 'package:service_app/src/features/my_commissioning/domain/usecase/commissioning_report_history_usecase.dart';
import 'package:service_app/src/features/report_history/presentation/pages/feedback_details_screen.dart';
import 'package:service_app/src/features/service_calls/presentation/widgets/complaint_report_dialog.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_details_bloc/commissioning_report_details_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_details_bloc/commissioning_report_details_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_history_bloc/service_call_report_history_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_history_bloc/service_call_report_history_event.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_workflow_screen.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_history_bloc/service_call_report_history_state.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_pdf_bloc/commissioning_report_pdf_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_pdf_bloc/commissioning_report_pdf_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_report_pdf_bloc/commissioning_report_pdf_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_pdf_bloc/service_call_report_pdf_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_pdf_bloc/service_call_report_pdf_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_pdf_bloc/service_call_report_pdf_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  int _selectedTab = 0; // Default to 'Commissioning'
  late CommissioningReportHistoryBloc _historyBloc;
  late ServiceCallReportHistoryBloc _serviceCallHistoryBloc;
  late AmcReportsHistoryBloc _amcReportsHistoryBloc;
  late CommissioningReportDetailsBloc _detailsBloc;
  late CommissioningReportPdfBloc _pdfBloc;
  late ServiceCallReportPdfBloc _serviceCallPdfBloc;
  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late TechnicianBloc _technicianBloc;
  String? _selectedCustomerName;
  String? _selectedCustomerId;
  String? _selectedSiteName;
  String? _selectedSiteId;
  String? _selectedTechnicianName;
  String? _selectedTechnicianId;
  DateTime? _selectedDate;

  void _fetchReportHistory() {
    final String? dateStr = _selectedDate != null
        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
        : null;
    _historyBloc.add(
      CommissioningReportHistoryGetEvent(
        params: CommissioningReportHistoryParams(
          customerId: _selectedCustomerId,
          siteId: _selectedSiteId,
          date: dateStr,
          page: 1,
          pageSize: 10,
        ),
      ),
    );
  }

  void _fetchServiceCallHistory() {
    _serviceCallHistoryBloc.add(FetchServiceCallReportHistory());
  }

  void _fetchAmcHistory() {
    _amcReportsHistoryBloc.add(GetAmcReportsHistoryEvent());
  }

  @override
  void initState() {
    super.initState();
    _historyBloc = getIt<CommissioningReportHistoryBloc>();
    _serviceCallHistoryBloc = getIt<ServiceCallReportHistoryBloc>();
    _amcReportsHistoryBloc = getIt<AmcReportsHistoryBloc>();
    _detailsBloc = getIt<CommissioningReportDetailsBloc>();
    _pdfBloc = getIt<CommissioningReportPdfBloc>();
    _serviceCallPdfBloc = getIt<ServiceCallReportPdfBloc>();
    _fetchReportHistory();
    _fetchServiceCallHistory();
    _fetchAmcHistory();
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
  }

  @override
  void dispose() {
    _historyBloc.close();
    _serviceCallHistoryBloc.close();
    _amcReportsHistoryBloc.close();
    _detailsBloc.close();
    _pdfBloc.close();
    _serviceCallPdfBloc.close();
    _customerBloc.close();
    _sitesBloc.close();
    _technicianBloc.close();
    super.dispose();
  }

  Future<void> _downloadPdf(String url) async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
        }
      }

      final dir = Directory('/storage/emulated/0/Download/Mainten');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      String fileName =
          'Report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      if (url.contains('.pdf')) {
        fileName = url.split('/').last.split('?').first;
      }

      final savePath = '${dir.path}/$fileName';

      if (mounted) {
        appSnackBar(context, const Color(0xFF1565C0), 'Downloading report...');
      }

      await Dio().download(url, savePath);

      if (mounted) {
        appSnackBar(
          context,
          const Color(0xFF4CAF50),
          'Downloaded successfully to $savePath',
        );
      }
    } catch (e) {
      if (mounted) {
        appSnackBar(context, const Color(0xFFF44336), 'Download failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CommissioningReportPdfBloc, CommissioningReportPdfState>(
          bloc: _pdfBloc,
          listener: (context, state) {
            if (state is CommissioningReportPdfLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                ),
              );
            } else if (state is CommissioningReportPdfError) {
              Navigator.pop(context);
              appSnackBar(context, const Color(0xFFF44336), state.message);
            } else if (state is CommissioningReportPdfLoaded) {
              Navigator.pop(context);
              final url = state.response.data?.pdfUrl;
              if (url != null && url.isNotEmpty) {
                if (state.action == PdfAction.view) {
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } else if (state.action == PdfAction.download) {
                  _downloadPdf(url);
                }
              } else {
                appSnackBar(context, const Color(0xFFF44336), 'PDF URL is empty');
              }
            }
          },
        ),
        BlocListener<ServiceCallReportPdfBloc, ServiceCallReportPdfState>(
          bloc: _serviceCallPdfBloc,
          listener: (context, state) {
            if (state is ServiceCallReportPdfLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1565C0)),
                ),
              );
            } else if (state is ServiceCallReportPdfError) {
              Navigator.pop(context);
              appSnackBar(context, const Color(0xFFF44336), state.message);
            } else if (state is ServiceCallReportPdfLoaded) {
              Navigator.pop(context);
              final url = state.response.data?.pdfUrl;
              if (url != null && url.isNotEmpty) {
                if (state.action == ServiceCallPdfAction.view) {
                  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } else if (state.action == ServiceCallPdfAction.download) {
                  _downloadPdf(url);
                }
              } else {
                appSnackBar(context, const Color(0xFFF44336), 'PDF URL is empty');
              }
            }
          },
        ),
      ],
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Reports History Header ──────────────────────────────────────────
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            //   child: Row(
            //     children: [
            //       Text(
            //         'reports_title'.tr(),
            //         style: AppFont.style(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w800,
            //           color: const Color(0xFF0D121F),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // ── Segmented Tab Control ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegmentTab(
                        0,
                        'reports_tab_commissioning'.tr(),
                      ),
                    ),
                    Expanded(
                      child: _buildSegmentTab(1, 'reports_tab_service'.tr()),
                    ),
                    Expanded(
                      child: _buildSegmentTab(2, 'reports_tab_amc'.tr()),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

            // ── Filter Section ──────────────────────────────────────────────────
            _buildFilterSection(
              _selectedTab == 0
                  ? 'Commissioning Report History'
                  : _selectedTab == 1
                      ? 'Service Report History'
                      : 'AMC Report History',
            ),

            // ── Reports List ────────────────────────────────────────────────────
            Expanded(
              child: Container(
                color: const Color(0xFFF8F9FB),
                child: _selectedTab == 0
                    ? BlocBuilder<
                        CommissioningReportHistoryBloc,
                        CommissioningReportHistoryState
                      >(
                        bloc: _historyBloc,
                        builder: (context, state) {
                          if (state is CommissioningReportHistoryLoadingState ||
                              state is CommissioningReportHistoryInitialState) {
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: 3,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) =>
                                  const ListCardShimmer(),
                            );
                          } else if (state
                              is CommissioningReportHistoryFailureState) {
                            return Center(
                              child: Text(
                                state.message,
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          } else if (state
                              is CommissioningReportHistorySuccessState) {
                            final items = state.data.data.results;
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'reports_empty_commissioning'.tr(),
                                  style: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                String formattedDate = item.submittedAt;
                                try {
                                  final dt = DateTime.parse(item.submittedAt);
                                  formattedDate = DateFormat(
                                    'dd MMM yyyy',
                                  ).format(dt);
                                } catch (_) {}

                                return _ReportCard(
                                  id: item.commissioningWorkId,
                                  reportId: item.id,
                                  type: ReportType.commissioning,
                                  companyName: item.customerName,
                                  location: item.siteName,
                                  date: formattedDate,
                                  technician:
                                      item.technicianRepresentativeName ??
                                      'No representative',
                                  technicianId: item.dealerName,
                                  feedbackSubmitted: item.feedbackSubmitted,
                                  qrCodeImage: item.qrCodeImage,
                                  status: item.status,
                                  onViewTap: (id) {
                                    _detailsBloc.add(
                                      CommissioningReportDetailsGetEvent(id),
                                    );
                                  },
                                  onViewPdfTap: (id) {
                                    _pdfBloc.add(
                                      FetchCommissioningReportPdfEvent(
                                        reportId: id,
                                        action: PdfAction.view,
                                      ),
                                    );
                                  },
                                  onDownloadPdfTap: (id) {
                                    _pdfBloc.add(
                                      FetchCommissioningReportPdfEvent(
                                        reportId: id,
                                        action: PdfAction.download,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    : _selectedTab == 1
                    ? BlocBuilder<
                        ServiceCallReportHistoryBloc,
                        ServiceCallReportHistoryState
                      >(
                        bloc: _serviceCallHistoryBloc,
                        builder: (context, state) {
                          if (state is ServiceCallReportHistoryLoading ||
                              state is ServiceCallReportHistoryInitial) {
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: 3,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) =>
                                  const ListCardShimmer(),
                            );
                          } else if (state is ServiceCallReportHistoryError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          } else if (state is ServiceCallReportHistoryLoaded) {
                            final items = state.response.data?.results ?? [];
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'reports_empty_service'.tr(),
                                  style: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                String formattedDate = item.submittedAt;
                                try {
                                  final dt = DateTime.parse(item.submittedAt);
                                  formattedDate = DateFormat(
                                    'dd MMM yyyy',
                                  ).format(dt);
                                } catch (_) {}

                                return _ReportCard(
                                  id: item.complaintNumber,
                                  complaintNo: item.complaintNumber,
                                  reportId: item.id,
                                  type: ReportType.service,
                                  companyName: item.customerName,
                                  location: item.siteName,
                                  date: formattedDate,
                                  technician: item.technicianRepresentativeName,
                                  technicianId: item.dealerName,
                                  feedbackSubmitted: item.feedbackSubmitted,
                                  qrCodeImage: item.qrCodeImage,
                                  status: item.reportType.isNotEmpty ? item.reportType : item.status,
                                  onViewPdfTap: (id) {
                                    _serviceCallPdfBloc.add(
                                      FetchServiceCallReportPdfEvent(
                                        reportId: id,
                                        action: ServiceCallPdfAction.view,
                                      ),
                                    );
                                  },
                                  onDownloadPdfTap: (id) {
                                    _serviceCallPdfBloc.add(
                                      FetchServiceCallReportPdfEvent(
                                        reportId: id,
                                        action: ServiceCallPdfAction.download,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    : BlocBuilder<AmcReportsHistoryBloc, AmcReportsHistoryState>(
                        bloc: _amcReportsHistoryBloc,
                        builder: (context, state) {
                          if (state is AmcReportsHistoryLoadingState ||
                              state is AmcReportsHistoryInitial) {
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: 3,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) =>
                                  const ListCardShimmer(),
                            );
                          } else if (state is AmcReportsHistoryErrorState) {
                            return Center(
                              child: Text(
                                state.errorMessage,
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          } else if (state is AmcReportsHistorySuccessState) {
                            final items = state.response.data;
                            if (items.isEmpty) {
                              return Center(
                                child: Text(
                                  'reports_empty_amc'.tr(),
                                  style: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: items.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                String formattedDate = item.submittedAt;
                                try {
                                  final dt = DateTime.parse(item.submittedAt);
                                  formattedDate = DateFormat('dd MMM yyyy').format(dt);
                                } catch (_) {}

                                return _ReportCard(
                                  id: item.id,
                                  reportId: item.amcVisitId,
                                  type: ReportType.amc,
                                  companyName: item.customerName,
                                  location: item.siteName,
                                  date: formattedDate,
                                  technician: item.technicianRepresentativeName,
                                  technicianId: item.dealerName,
                                  feedbackSubmitted: item.feedbackSubmitted,
                                  qrCodeImage: item.qrCodeImage,
                                  status: item.status,
                                  onViewTap: (_) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AmcWorkflowScreen(
                                          isFromHistory: true,
                                          initialVisitId: item.amcVisitId,
                                          initialTitle: item.customerName,
                                          initialLocation: item.siteName,
                                          initialVisitInfo: 'Visit ${item.visitNumber}',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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
    );
  }

  List<Widget> _buildReportList() {
    if (_selectedTab == 0) {
      // Commissioning
      return [
        _ReportCard(
          id: 'COM-7721',
          type: ReportType.commissioning,
          companyName: 'Shree Krishna Ind.',
          location: 'Ahmedabad Plant',
          date: '28 Apr 2026',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
          feedbackSubmitted: false,
          status: 'Submitted Report',
        ),
      ];
    } else if (_selectedTab == 1) {
      // Service
      return [
        _ReportCard(
          id: 'SRV-9901',
          type: ReportType.service,
          companyName: 'Global Infotech',
          location: 'Main Server Room',
          date: '29 Apr 2026',
          complaintNo: '#ABC-26-0821',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
          feedbackSubmitted: false,
          status: 'Submitted Report',
        ),
        const SizedBox(height: 16),
        _ReportCard(
          id: 'SRV-9902',
          type: ReportType.service,
          companyName: 'Tata Motors',
          location: 'Assembly Line 4',
          date: '22 Apr 2026',
          complaintNo: '#ABC-26-0715',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
          feedbackSubmitted: true,
          status: 'Closed Over Call',
        ),
      ];
    } else {
      // AMC
      return [
        _ReportCard(
          id: 'AMC-5501',
          type: ReportType.amc,
          companyName: 'Reliance Mart',
          location: 'Chiller Plant',
          date: '30 Apr 2026',
          technician: 'Pravin Patil',
          technicianId: 'T-101',
          feedbackSubmitted: false,
          status: 'Submitted Report',
        ),
      ];
    }
  }

  Widget _buildSegmentTab(int index, String label,) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = index);
        if (index == 0) {
          _fetchReportHistory();
        } else if (index == 1) {
          _fetchServiceCallHistory();
        } else if (index == 2) {
          _fetchAmcHistory();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFA5ABB7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Text(
                title.tr(),
                style: AppFont.style(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D121F),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Column(
            children: [
              // Filter Row 1
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<CustomerBloc, CustomerState>(
                      bloc: _customerBloc,
                      builder: (context, state) {
                        final customers = <Customer>[];
                        if (state is CustomerSuccessState) {
                          customers.addAll(state.data.data);
                        }
                        return SearchableDropdown<Customer>(
                          items: customers,
                          value: _selectedCustomerId != null
                              ? customers
                                        .where((c) => c.id == _selectedCustomerId)
                                        .isEmpty
                                    ? null
                                    : customers.firstWhere(
                                        (c) => c.id == _selectedCustomerId,
                                      )
                              : null,
                          hintText: 'reports_filter_select_customer'.tr(),
                          itemAsString: (c) => c.name,
                          isLoading: state is CustomerLoadingState,
                          isFilter: true,
                          filterFn: (item, filter) => true,
                          onSearchChanged: (v) {
                            _customerBloc.add(
                              CustomerGetEvent(search: v, page: 1, pageSize: 10),
                            );
                          },
                          onLoadMore: (lastSearch) {
                            _customerBloc.add(
                              CustomerGetEvent(
                                search: lastSearch,
                                page: 2,
                                pageSize: 10,
                              ),
                            );
                          },
                          // icon: const Icon(
                          //   Icons.person_outline,
                          //   color: Color(0xFFA5ABB7),
                          //   size: 18,
                          // ),
                          onChanged: (customer) {
                            setState(() {
                              _selectedCustomerName = customer?.name;
                              _selectedCustomerId = customer?.id;
                              _selectedSiteName = null;
                              _selectedSiteId = null;
                            });
                            if (customer != null) {
                              _sitesBloc.add(
                                SitesGetEvent(customer_id: customer.id),
                              );
                            }
                            _fetchReportHistory();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BlocBuilder<SitesBloc, SitesState>(
                      bloc: _sitesBloc,
                      builder: (context, state) {
                        final sites = <Site>[];
                        if (state is SitesSuccessState) {
                          sites.addAll(state.data.data);
                        }

                        Site? initialValue;
                        if (_selectedSiteId != null) {
                          final matches = sites.where(
                            (s) => s.id == _selectedSiteId,
                          );
                          if (matches.isNotEmpty) {
                            initialValue = matches.first;
                          } else if (_selectedSiteName != null) {
                            // If it's selected but not in the current paginated list, manually add it
                            final s = Site(
                              id: _selectedSiteId!,
                              name: _selectedSiteName!,
                            );
                            sites.add(s);
                            initialValue = s;
                          }
                        }

                        Widget siteDropdown = SearchableDropdown<Site>(
                          items: sites,
                          value: initialValue,
                          hintText: 'reports_filter_select_site'.tr(),
                          itemAsString: (s) => s.name,
                          isLoading: state is SitesLoadingState,
                          isFilter: true,
                          filterFn: (item, filter) => true,
                          onSearchChanged: _selectedCustomerId != null
                              ? (v) => _sitesBloc.add(
                                  SitesGetEvent(
                                    customer_id: _selectedCustomerId!,
                                    search: v,
                                    page: 1,
                                    pageSize: 10,
                                  ),
                                )
                              : null,
                          onLoadMore: _selectedCustomerId != null
                              ? (lastSearch) => _sitesBloc.add(
                                  SitesGetEvent(
                                    customer_id: _selectedCustomerId!,
                                    search: lastSearch,
                                    page: 2,
                                    pageSize: 10,
                                  ),
                                )
                              : null,
                          onChanged: (site) {
                            setState(() {
                              _selectedSiteName = site?.name;
                              _selectedSiteId = site?.id;
                            });
                            _fetchReportHistory();
                          },
                        );

                        if (_selectedCustomerId == null) {
                          return IgnorePointer(
                            child: Opacity(
                              opacity: 0.5,
                              child: siteDropdown,
                            ),
                          );
                        }

                        return siteDropdown;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Complaint Number — only for Service tab
              if (_selectedTab == 1) ...[
                _buildFilterInputFull(
                  'reports_filter_complaint_hint'.tr(),
                  Icons.assignment_outlined,
                ),
                const SizedBox(height: 12),
              ],
              // Filter Row 2
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF1565C0),
                                  onPrimary: Colors.white,
                                  onSurface: Color(0xFF0D121F),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                          _fetchReportHistory();
                        }
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            // const Icon(Icons.calendar_today_outlined, color: Color(0xFFA5ABB7), size: 18),
                            // const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
                                    : 'reports_filter_date_hint'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  color: _selectedDate != null
                                      ? const Color(0xFF0D121F)
                                      : const Color(0xFFA5ABB7),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (_selectedDate != null)
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedDate = null);
                                  _fetchReportHistory();
                                },
                                child: const Icon(Icons.close, color: Color(0xFFA5ABB7), size: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BlocBuilder<TechnicianBloc, TechnicianState>(
                      bloc: _technicianBloc,
                      builder: (context, state) {
                        final technicians = <Technician>[];
                        if (state is TechnicianSuccessState) {
                          technicians.addAll(state.data.data);
                        }
                        return SearchableDropdown<Technician>(
                          items: technicians,
                          value: _selectedTechnicianId != null
                              ? technicians
                                        .where((t) => t.id == _selectedTechnicianId)
                                        .isEmpty
                                    ? null
                                    : technicians.firstWhere(
                                        (t) => t.id == _selectedTechnicianId,
                                      )
                              : null,
                          hintText: 'reports_filter_select_technician'.tr(),
                          itemAsString: (t) => t.name,
                          isLoading: state is TechnicianLoadingState,
                          isFilter: true,
                          // icon: const Icon(
                          //   Icons.person_outline,
                          //   color: Color(0xFFA5ABB7),
                          //   size: 18,
                          // ),
                          onChanged: (tech) {
                            setState(() {
                              _selectedTechnicianName = tech?.name;
                              _selectedTechnicianId = tech?.id;
                            });
                            _fetchReportHistory();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Clear Filters
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCustomerName = null;
                    _selectedCustomerId = null;
                    _selectedSiteName = null;
                    _selectedSiteId = null;
                    _selectedTechnicianName = null;
                    _selectedTechnicianId = null;
                    _selectedDate = null;
                  });
                  _fetchReportHistory();
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
                        'reports_clear_filters'.tr(),
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
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    IconData icon, {
    bool isLoading = false,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 14,
                color: const Color(0xFFA5ABB7),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF1565C0),
              ),
            )
          else
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFFA5ABB7),
              size: 18,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterInput(String label, IconData icon) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 14,
                color: const Color(0xFFA5ABB7),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInputFull(String label, IconData icon) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Icon(icon, color: const Color(0xFFA5ABB7), size: 18),
          // const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppFont.style(
                fontSize: 14,
                color: const Color(0xFFA5ABB7),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

enum ReportType { commissioning, service, amc }

class _ReportCard extends StatelessWidget {
  final String id;
  final String? reportId;
  final ReportType type;
  final String companyName;
  final String location;
  final String date;
  final String? complaintNo;
  final String technician;
  final String technicianId;
  final bool feedbackSubmitted;
  final String? qrCodeImage;
  final String? status;
  final void Function(String reportId)? onViewTap;
  final void Function(String reportId)? onViewPdfTap;
  final void Function(String reportId)? onDownloadPdfTap;

  const _ReportCard({
    required this.id,
    this.reportId,
    required this.type,
    required this.companyName,
    required this.location,
    required this.date,
    this.complaintNo,
    required this.technician,
    required this.technicianId,
    required this.feedbackSubmitted,
    this.qrCodeImage,
    this.status,
    this.onViewTap,
    this.onViewPdfTap,
    this.onDownloadPdfTap,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    switch (type) {
      case ReportType.commissioning:
        badgeBg = const Color(0xFFE3F2FD);
        badgeText = const Color(0xFF1565C0);
        badgeLabel = 'reports_tab_commissioning'.tr();
        break;
      case ReportType.service:
        badgeBg = const Color(0xFFFFF1EB);
        badgeText = const Color(0xFFFF6D00);
        badgeLabel = 'reports_tab_service'.tr();
        break;
      case ReportType.amc:
        badgeBg = const Color(0xFFE8F5E9);
        badgeText = const Color(0xFF2E7D32);
        badgeLabel = 'reports_tab_amc'.tr();
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (status != null && status!.isNotEmpty && type == ReportType.service) ...[
              Align(
                alignment: Alignment.centerRight,
                child: _buildStatusPill(status!),
              ),
              const SizedBox(height: 12),
            ],
            // Company & Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  companyName,
                  style: AppFont.style(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                Text(
                  date,
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Color(0xFFA5ABB7),
                ),
                const SizedBox(width: 8),
                Text(
                  location,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7A8699),
                  ),
                ),
              ],
            ),
            if (complaintNo != null) ...[
              const SizedBox(height: 16),
              // Complaint Row
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      complaintNo!,
                      style: AppFont.style(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return ComplaintReportDialog(
                                complaintId: reportId ?? '',
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE0B2), // soft orange background
                          foregroundColor: const Color(0xFFE65100), // text/icon color
                          elevation: 2,                             // subtle shadow
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'reports_view_complaint'.tr(),
                          style: AppFont.style(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE65100),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
            const SizedBox(height: 16),
            // Technician Row
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technician,
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      technicianId,
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildViewButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton(BuildContext context) {
    String btnText = 'reports_btn_view_service'.tr();
    if (type == ReportType.commissioning) {
      btnText = 'reports_btn_view_commissioning'.tr();
    } else if (type == ReportType.amc) {
      btnText = 'reports_btn_view_amc'.tr();
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            if ((type == ReportType.commissioning || type == ReportType.service) &&
                onViewPdfTap != null &&
                reportId != null) {
              onViewPdfTap!(reportId!);
            } else if (onViewTap != null && reportId != null) {
              onViewTap!(reportId!);
            }
          },
          child: Container(
            height: 44,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  btnText,
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
        // Extra action buttons — for commissioning, service, and amc types
        if (type == ReportType.commissioning || type == ReportType.service || type == ReportType.amc) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              // Eye / View icon button (Service Calls only)
              if (type == ReportType.service) ...[
                Expanded(
                  child: _buildIconActionButton(
                    icon: Icons.remove_red_eye_outlined,
                    iconColor: const Color(0xFF6B7280),
                    onTap: () {
                      if (reportId != null) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return ComplaintReportDialog(
                              complaintId: reportId!,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
              // QR Code icon button or Checkmark
              Expanded(
                child: feedbackSubmitted
                    ? _buildIconActionButton(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        onTap: () {
                          if (reportId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackDetailsScreen(
                                  reportId: reportId!,
                                  isServiceCall: type == ReportType.service,
                                  isAmc: type == ReportType.amc,
                                  title: type == ReportType.service
                                      ? 'Service Call Feedback Details'
                                      : type == ReportType.amc
                                          ? 'AMC Feedback Details'
                                          : 'Commissioning Feedback Details',
                                  onBack: () => Navigator.pop(context),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : _buildIconActionButton(
                        icon: Icons.qr_code_2_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        onTap: () {
                          if (qrCodeImage != null && qrCodeImage!.isNotEmpty) {
                            _showQrCodeDialog(context);
                          } else {
                            appSnackBar(
                              context,
                              const Color(0xFFF44336),
                              'reports_qr_not_available'.tr(),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildIconActionButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        ),
        child: Center(child: Icon(icon, size: 22, color: iconColor)),
      ),
    );
  }

  Widget _buildStatusPill(String statusStr) {
    Color borderColor;
    Color bgColor;
    Color textColor;

    final lowerStatus = statusStr.trim().toLowerCase();

    if (lowerStatus == 'submitted report' || lowerStatus == 'submitted') {
      borderColor = const Color(0xFF4CAF50); // Green
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
    } else if (lowerStatus == 'closed over call') {
      borderColor = const Color(0xFF2196F3); // Blue
      bgColor = const Color(0xFFE3F2FD);
      textColor = const Color(0xFF1565C0);
    } else if (lowerStatus == 'existing complaint') {
      borderColor = const Color(0xFFFFB300); // Amber/Orange
      bgColor = const Color(0xFFFFF8E1);
      textColor = const Color(0xFFE65100);
    } else if (lowerStatus == 'no complaints') {
      borderColor = const Color(0xFF9C27B0); // Purple
      bgColor = const Color(0xFFF3E5F5);
      textColor = const Color(0xFF7B1FA2);
    } else if (lowerStatus == 'service work' || lowerStatus == 'service_work') {
      borderColor = const Color(0xFF00ACC1); // Cyan
      bgColor = const Color(0xFFE0F7FA);
      textColor = const Color(0xFF00838F);
    } else if (lowerStatus == 'service call' || lowerStatus == 'service_call') {
      borderColor = const Color(0xFFD81B60); // Pink
      bgColor = const Color(0xFFFCE4EC);
      textColor = const Color(0xFFAD1457);
    } else {
      borderColor = const Color(0xFF9E9E9E); // Grey
      bgColor = const Color(0xFFF5F5F5);
      textColor = const Color(0xFF616161);
    }

    String displayStatus = statusStr.replaceAll('_', ' ');
    displayStatus = displayStatus.split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        displayStatus,
        style: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  void _showQrCodeDialog(BuildContext context) {
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
                  'create_report_success_title'.tr(),
                  style: AppFont.style(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'create_report_success_subtitle'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 16),
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
                  child: qrCodeImage != null && qrCodeImage!.isNotEmpty
                      ? Image.network(
                          qrCodeImage!,
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
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'create_report_btn_done'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
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
