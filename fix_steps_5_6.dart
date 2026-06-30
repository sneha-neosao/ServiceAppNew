import 'dart:io';

void main() {
  final file = File('lib/src/features/my_commissioning/presentation/pages/create_commissioning_report_screen.dart');
  String content = file.readAsStringSync();
  
  // Step 5
  content = content.replaceFirst(
    r'''      if (widget.isServiceReport) {
        _submitServiceCallStep5Bloc.add(
          ServiceCallReportStep5PostEvent(''',
    r'''      await OfflineCommissioningDb.instance.saveStep(
        _commissioningReportId ?? "",
        widget.commissioningWorkId ?? "",
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

  // Step 6 (first if (widget.isServiceReport) inside step 6 block)
  content = content.replaceFirst(
    r'''        if (widget.isServiceReport) {
          String? techSignaturePath = _technicianSignatureFile?.path;''',
    r'''        await OfflineCommissioningDb.instance.saveStep(
            _commissioningReportId ?? "",
            widget.commissioningWorkId ?? "",
            6,
            {
               "technicianRemarks": _technicianRemarksController.text.trim(),
               "customerRemarks": _customerRemarksController.text.trim(),
               "technicianRepresentative": _selectedTechnicianRepId ?? '',
               "customerRepresentativeName": _customerRepNameController.text.trim(),
               "technicianSignaturePath": _technicianSignatureFile?.path,
               "customerSignaturePath": _customerSignatureFile?.path,
               "workPhotosPaths": _workPhotos.map((f) => f.path).toList(),
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
  print('Replaced steps 5, 6');
}
