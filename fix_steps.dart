import 'dart:io';

void main() {
  final file = File('lib/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart');
  String content = file.readAsStringSync();
  
  // Step 2
  content = content.replaceFirst(
    r'''      if (widget.isServiceReport) {
        if (_submitServiceCallStep2Bloc.state
            is ServiceCallReportStep2LoadingState)''',
    r'''      int warrantyYears = _selectedWarranty != null
          ? (int.tryParse(_selectedWarranty!.split('_').first) ?? 1)
          : 1;
      await OfflineCommissioningDb.instance.saveStep(
        _commissioningReportId ?? "",
        widget.commissioningWorkId ?? "",
        2,
        {
           "id": _commissioningReportId ?? "",
           "commissioning_work_id": widget.commissioningWorkId ?? "",
           "warranty_period_years": warrantyYears,
           "member_presents_customer_side": repNames,
           "agenda": _agendaController.text.trim()
        }
      );
      bool isOnline = await NetworkInfo().checkIsConnected;
      if (!isOnline) {
         appSnackBar(context, AppColor.green, "Saved offline locally");
         if (_highestSubmittedStep < 2) { _highestSubmittedStep = 2; }
         setState(() {
           _currentStep++;
           _triggerAutoFillForStep(_currentStep);
         });
         return;
      }

      if (widget.isServiceReport) {
        if (_submitServiceCallStep2Bloc.state
            is ServiceCallReportStep2LoadingState)'''
  );

  // Step 3
  content = content.replaceFirst(
    r'''      if (widget.isServiceReport) {
        if (_submitServiceCallStep3Bloc.state
            is ServiceCallReportStep3LoadingState)''',
    r'''      await OfflineCommissioningDb.instance.saveStep(
        _commissioningReportId ?? "",
        widget.commissioningWorkId ?? "",
        3,
        {
           "isTechnicalNa": _isTechnicalDetailsNA,
           "technicalDetails": techDetails?.toJson(),
        }
      );
      bool isOnline = await NetworkInfo().checkIsConnected;
      if (!isOnline) {
         appSnackBar(context, AppColor.green, "Saved offline locally");
         if (_highestSubmittedStep < 3) { _highestSubmittedStep = 3; }
         setState(() {
           _currentStep++;
           _triggerAutoFillForStep(_currentStep);
         });
         return;
      }

      if (widget.isServiceReport) {
        if (_submitServiceCallStep3Bloc.state
            is ServiceCallReportStep3LoadingState)'''
  );

  // Step 4
  content = content.replaceFirst(
    r'''      if (widget.isServiceReport) {
        _submitServiceCallStep4Bloc.add(
          ServiceCallReportStep4PostEvent(''',
    r'''      await OfflineCommissioningDb.instance.saveStep(
        _commissioningReportId ?? "",
        widget.commissioningWorkId ?? "",
        4,
        {
           "descriptions": descriptions.map((e) => {"sr_no": e.srNo, "description": e.description}).toList(),
        }
      );
      bool isOnline = await NetworkInfo().checkIsConnected;
      if (!isOnline) {
         appSnackBar(context, AppColor.green, "Saved offline locally");
         if (_highestSubmittedStep < 4) { _highestSubmittedStep = 4; }
         setState(() {
           _currentStep++;
           _triggerAutoFillForStep(_currentStep);
         });
         return;
      }

      if (widget.isServiceReport) {
        _submitServiceCallStep4Bloc.add(
          ServiceCallReportStep4PostEvent('''
  );

  file.writeAsStringSync(content);
  print('Replaced steps 2, 3, 4');
}
