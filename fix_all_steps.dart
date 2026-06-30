import 'dart:io';

void main() {
  final file = File('lib/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart');
  String content = file.readAsStringSync();

  // Step 1
  content = content.replaceFirst(
    r'''        if (widget.isServiceReport) {
          if (_submitServiceCallStep1Bloc.state
              is ServiceCallReportStep1LoadingState)''',
    r'''        await OfflineCommissioningDb.instance.saveStep(
          _commissioningReportId ?? "",
          widget.commissioningWorkId,
          1,
          {
             "complaintId": widget.commissioningWorkId,
             "technicianIds": technicianIdsMap,
          }
        );
        bool isOnline = await NetworkInfo().checkIsConnected;
        if (!isOnline) {
           appSnackBar(context, AppColor.green, "Saved offline locally");
           if (_highestSubmittedStep < 1) { _highestSubmittedStep = 1; }
           setState(() {
             _currentStep++;
             _triggerAutoFillForStep(_currentStep);
           });
           return;
        }

        if (widget.isServiceReport) {
          if (_submitServiceCallStep1Bloc.state
              is ServiceCallReportStep1LoadingState)'''
  );

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
        widget.commissioningWorkId,
        2,
        {
           "id": _commissioningReportId ?? "",
           "commissioning_work_id": widget.commissioningWorkId,
           "warranty_period_years": warrantyYears,
           "member_presents_customer_side": repNames.join(', '),
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
        widget.commissioningWorkId,
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
        widget.commissioningWorkId,
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

  // Step 5
  content = content.replaceFirst(
    r'''      if (widget.isServiceReport) {
        _submitServiceCallStep5Bloc.add(
          ServiceCallReportStep5PostEvent(''',
    r'''      await OfflineCommissioningDb.instance.saveStep(
        _commissioningReportId ?? "",
        widget.commissioningWorkId,
        5,
        {
           "isMechanicalChecklistNa": _mechNA,
           "isPipelineChecklistNa": _pipeNA,
           "isElectricalChecklistNa": _elecNA,
           "savedChecklists": savedChecklists
               .map((e) => {
                     "check_type": e.checkType,
                     "key_checklist": e.keyChecklist,
                     "value_checklist": e.valueChecklist,
                     if (e.photo != null) "photo": e.photo,
                     if (e.video != null) "video": e.video,
                   })
               .toList(),
        }
      );
      bool isOnline = await NetworkInfo().checkIsConnected;
      if (!isOnline) {
         appSnackBar(context, AppColor.green, "Saved offline locally");
         if (_highestSubmittedStep < 5) { _highestSubmittedStep = 5; }
         setState(() {
           _currentStep++;
           _triggerAutoFillForStep(_currentStep);
         });
         return;
      }

      if (widget.isServiceReport) {
        _submitServiceCallStep5Bloc.add(
          ServiceCallReportStep5PostEvent('''
  );

  // Step 6
  content = content.replaceFirst(
    r'''        if (widget.isServiceReport) {
          String? techSignaturePath = _technicianSignatureFile?.path;''',
    r'''        await OfflineCommissioningDb.instance.saveStep(
            _commissioningReportId ?? "",
            widget.commissioningWorkId,
            6,
            {
               "technicianRemarks": _technicianRemarksController.text.trim(),
               "customerRemarks": _customerRemarksController.text.trim(),
               "technicianRepresentative": _selectedTechnicianRepId ?? '',
               "customerRepresentativeName": _customerRepNameController.text.trim(),
               "technicianSignaturePath": _technicianSignatureFile?.path,
               "customerSignaturePath": _customerSignatureFile?.path,
               "workPhotosPaths": workPhotosPaths,
            }
        );
        bool isOnline = await NetworkInfo().checkIsConnected;
        if (!isOnline) {
           appSnackBar(context, AppColor.green, "Report saved offline completely!");
           if (_highestSubmittedStep < 6) { _highestSubmittedStep = 6; }
           widget.onBack();
           return;
        }

        if (widget.isServiceReport) {
          String? techSignaturePath = _technicianSignatureFile?.path;'''
  );

  file.writeAsStringSync(content);
  print('Steps 1-6 patched successfully!');
}
