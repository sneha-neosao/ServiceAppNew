import 'dart:io';

void main() {
  final file = File('lib/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart');
  String content = file.readAsStringSync();

  // Make _nextStep async
  content = content.replaceFirst('void _nextStep() {', 'Future<void> _nextStep() async {');

  // Add _highestSubmittedStep to state variables
  content = content.replaceFirst(
    '  bool _hasAppliedInitialStep = false;',
    '''  bool _hasAppliedInitialStep = false;
  int _highestSubmittedStep = 1;'''
  );

  // Add _triggerAutoFillForStep method before _nextStep
  content = content.replaceFirst(
    '  Future<void> _nextStep() async {',
    '''  void _triggerAutoFillForStep(int step) {
    if (widget.isServiceReport) {
      final idToUse = _commissioningReportId ?? "";
      if (idToUse.isNotEmpty) {
        if (step == 2) {
          _serviceCallStep2AutoFillBloc.add(ServiceCallReportStep2AutoFillGetEvent(idToUse));
        } else if (step == 3) {
          _serviceCallStep3AutoFillBloc.add(ServiceCallReportStep3AutoFillGetEvent(idToUse));
        } else if (step == 4) {
          _serviceCallStep4AutoFillBloc.add(ServiceCallReportStep4AutoFillGetEvent(idToUse));
        } else if (step == 5) {
          _serviceCallStep5AutoFillBloc.add(ServiceCallReportStep5AutoFillGetEvent(idToUse));
        }
      }
    } else {
      if (_commissioningReportId != null) {
        if (step == 2) {
          _step2Bloc.add(CommissioningStep2AutoFillGetEvent(_commissioningReportId ?? ""));
        } else if (step == 3) {
          _step3Bloc.add(CommissioningStep3AutoFillGetEvent(_commissioningReportId ?? ""));
        } else if (step == 4) {
          _step4Bloc.add(CommissioningStep4AutoFillGetEvent(_commissioningReportId ?? ""));
        } else if (step == 5) {
          _step5Bloc.add(CommissioningStep5AutoFillGetEvent(_commissioningReportId ?? ""));
        } else if (step == 6) {
          _step6Bloc.add(CommissioningStep6AutoFillGetEvent(_commissioningReportId ?? ""));
        }
      }
    }
  }

  Future<void> _nextStep() async {'''
  );

  file.writeAsStringSync(content);
  print('Fixed _nextStep compilation issues!');
}
