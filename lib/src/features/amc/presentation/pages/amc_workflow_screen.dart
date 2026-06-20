import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_schedule_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_visit_details_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/create_amc_report_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/amc/bloc/amc_visit_complete_bloc/amc_visit_complete_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_visit_complete_bloc/amc_visit_complete_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_visit_complete_bloc/amc_visit_complete_state.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';

enum AmcViewState { schedule, details, createReport }

class AmcWorkflowScreen extends StatefulWidget {
  final String initialFilter;
  final String? initialVisitId;
  final String? initialTitle;
  final String? initialLocation;
  final String? initialVisitInfo;
  final bool isFromHistory;

  const AmcWorkflowScreen({
    super.key, 
    this.initialFilter = 'Today',
    this.initialVisitId,
    this.initialTitle,
    this.initialLocation,
    this.initialVisitInfo,
    this.isFromHistory = false,
  });

  @override
  State<AmcWorkflowScreen> createState() => _AmcWorkflowScreenState();
}

class _AmcWorkflowScreenState extends State<AmcWorkflowScreen> {
  AmcViewState _viewState = AmcViewState.schedule;
  int _amcReportsCreated = 0;

  String? _selectedAmcTitle;
  String? _selectedAmcLocation;
  String? _selectedAmcVisitInfo;
  String? _selectedAmcWindow;
  String? _selectedAmcVisitId;
  String? _selectedReportId;
  late AmcVisitCompleteBloc _amcVisitCompleteBloc;

  @override
  void initState() {
    super.initState();
    _amcVisitCompleteBloc = getIt<AmcVisitCompleteBloc>();
    if (widget.initialVisitId != null) {
      _viewState = AmcViewState.details;
      _selectedAmcVisitId = widget.initialVisitId;
      _selectedAmcTitle = widget.initialTitle;
      _selectedAmcLocation = widget.initialLocation;
      _selectedAmcVisitInfo = widget.initialVisitInfo;
      _selectedAmcWindow = '-';
    }
  }

  @override
  void dispose() {
    _amcVisitCompleteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _viewState == AmcViewState.schedule || (widget.isFromHistory && _viewState == AmcViewState.details),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          if (_viewState == AmcViewState.createReport) {
            _viewState = AmcViewState.details;
          } else if (_viewState == AmcViewState.details) {
            if (widget.isFromHistory) {
              Navigator.pop(context);
            } else {
              _viewState = AmcViewState.schedule;
            }
          }
        });
      },
      child: BlocProvider(
        create: (_) => _amcVisitCompleteBloc,
        child: BlocListener<AmcVisitCompleteBloc, AmcVisitCompleteState>(
          listener: (context, state) {
            if (state is AmcVisitCompleteLoadingState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is AmcVisitCompleteSuccessState) {
              Navigator.pop(context); // pop loader
              appSnackBar(context, Colors.green, state.data.message ?? 'amc_visit_marked_complete_successfully'.tr());
              if (widget.isFromHistory) {
                Navigator.pop(context);
              } else {
                setState(() {
                  _viewState = AmcViewState.schedule;
                });
              }
            } else if (state is AmcVisitCompleteFailureState) {
              Navigator.pop(context); // pop loader
              appSnackBar(context, Colors.red, state.message);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: _buildCurrentView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_viewState) {
      case AmcViewState.schedule:
        return AmcScheduleScreen(
          initialFilter: widget.initialFilter,
          onBack: () => Navigator.pop(context),
          onItemTap: (visitId, title, location, visitInfo, window) {
            setState(() {
              _selectedAmcVisitId = visitId;
              _selectedAmcTitle = title;
              _selectedAmcLocation = location;
              _selectedAmcVisitInfo = visitInfo;
              _selectedAmcWindow = window;
              _amcReportsCreated = 0;
              _selectedReportId = null;
              _viewState = AmcViewState.details;
            });
          },
        );
      case AmcViewState.details:
        return AmcVisitDetailsScreen(
          visitId: _selectedAmcVisitId ?? '',
          title: _selectedAmcTitle ?? '',
          location: _selectedAmcLocation ?? '',
          visitInfo: _selectedAmcVisitInfo ?? '',
          window: _selectedAmcWindow ?? '',
          reportsCreated: _amcReportsCreated,
          isFromHistory: widget.isFromHistory,
          onBack: () {
            if (widget.isFromHistory) {
              Navigator.pop(context);
            } else {
              setState(() => _viewState = AmcViewState.schedule);
            }
          },
          onSubmit: () => setState(() {
            _selectedReportId = null;
            _viewState = AmcViewState.createReport;
          }),
          onEditReport: (String reportId) => setState(() {
            _selectedReportId = reportId;
            _viewState = AmcViewState.createReport;
          }),
          onCompleteAmcWork: () {
            if (_selectedAmcVisitId != null) {
              _amcVisitCompleteBloc.add(SubmitAmcVisitCompleteEvent(visitId: _selectedAmcVisitId!));
            }
          },
        );
      case AmcViewState.createReport:
        return CreateAmcReportScreen(
          visitId: _selectedAmcVisitId ?? '',
          reportId: _selectedReportId,
          customerName: _selectedAmcTitle ?? '',
          siteName: _selectedAmcLocation ?? '',
          onBack: () => setState(() => _viewState = AmcViewState.details),
          onSubmit: () => setState(() {
            _amcReportsCreated++;
            _viewState = AmcViewState.details;
          }),
        );
    }
  }
}
