import 'package:flutter/material.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_schedule_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/amc_visit_details_screen.dart';
import 'package:service_app/src/features/amc/presentation/pages/create_amc_report_screen.dart';

enum AmcViewState { schedule, details, createReport }

class AmcWorkflowScreen extends StatefulWidget {
  final String initialFilter;
  const AmcWorkflowScreen({super.key, this.initialFilter = 'Today'});

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _viewState == AmcViewState.schedule,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          if (_viewState == AmcViewState.createReport) {
            _viewState = AmcViewState.details;
          } else if (_viewState == AmcViewState.details) {
            _viewState = AmcViewState.schedule;
          }
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _buildCurrentView(),
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
          onBack: () => setState(() => _viewState = AmcViewState.schedule),
          onSubmit: () => setState(() {
            _selectedReportId = null;
            _viewState = AmcViewState.createReport;
          }),
          onEditReport: (String reportId) => setState(() {
            _selectedReportId = reportId;
            _viewState = AmcViewState.createReport;
          }),
          onCompleteAmcWork: () {
            Navigator.pop(context);
          },
        );
      case AmcViewState.createReport:
        return CreateAmcReportScreen(
          visitId: _selectedAmcVisitId ?? '',
          reportId: _selectedReportId,
          onBack: () => setState(() => _viewState = AmcViewState.details),
          onSubmit: () => setState(() {
            _amcReportsCreated++;
            _viewState = AmcViewState.details;
          }),
        );
    }
  }
}
