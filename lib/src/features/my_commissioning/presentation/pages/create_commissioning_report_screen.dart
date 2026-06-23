import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/src/core/theme/app_color.dart';
import 'package:service_app/src/features/widgets/app_add_new_text_button_widget.dart';
import 'package:service_app/src/features/widgets/step_shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_step1_bloc/commissioning_step1_bloc.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_step1_autofill_bloc/commissioning_step1_autofill_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_step2_autofill_bloc/commissioning_step2_autofill_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_step2_bloc/commissioning_step2_bloc.dart';
import '../../../../remote/models/commissioning_report_step1_model/commissioning_report_step1_autofill_response.dart';
import '../../../../remote/models/commissioning_report_step2_autofill_model/commissioning_report_step2_autofill_response.dart';
import '../../../../remote/models/commissioning_report_step3_autofill_model/commissioning_report_step3_autofill_response.dart';
import '../../bloc/commissioning_step3_autofill_bloc/commissioning_step3_autofill_bloc.dart';
import '../../bloc/commissioning_step3_autofill_bloc/commissioning_step3_autofill_event.dart';
import '../../bloc/commissioning_step3_autofill_bloc/commissioning_step3_autofill_state.dart';
import '../../bloc/commissioning_step3_bloc/commissioning_step3_bloc.dart';
import '../../bloc/commissioning_step3_bloc/commissioning_step3_event.dart';
import '../../bloc/commissioning_step3_bloc/commissioning_step3_state.dart';
import '../../bloc/commissioning_step4_autofill_bloc/commissioning_step4_autofill_bloc.dart';
import '../../bloc/commissioning_step4_autofill_bloc/commissioning_step4_autofill_event.dart';
import '../../bloc/commissioning_step4_autofill_bloc/commissioning_step4_autofill_state.dart';
import '../../bloc/commissioning_step4_bloc/commissioning_step4_bloc.dart';
import '../../bloc/commissioning_step4_bloc/commissioning_step4_event.dart';
import '../../bloc/commissioning_step4_bloc/commissioning_step4_state.dart';
import '../../bloc/commissioning_step5_autofill_bloc/commissioning_step5_autofill_bloc.dart';
import '../../bloc/commissioning_step5_autofill_bloc/commissioning_step5_autofill_event.dart';
import '../../bloc/commissioning_step5_autofill_bloc/commissioning_step5_autofill_state.dart';
import '../../bloc/commissioning_step5_bloc/commissioning_step5_bloc.dart';
import '../../bloc/commissioning_step5_bloc/commissioning_step5_event.dart';
import '../../bloc/commissioning_step5_bloc/commissioning_step5_state.dart';
import '../../bloc/commissioning_work_list_bloc/commissioning_work_list_bloc.dart';
import '../../domain/usecase/commissioning_step5_usecase.dart';
import '../../../../remote/models/commissioning_report_step4_autofill_model/commissioning_report_step4_autofill_response.dart'
    hide CommissioningData, Technician;
import '../../../../remote/models/commissioning_report_step5_autofill_model/commissioning_report_step5_autofill_response.dart'
    hide SavedDescription;
import '../../bloc/commissioning_step6_autofill_bloc/commissioning_step6_autofill_bloc.dart';
import '../../bloc/commissioning_step6_autofill_bloc/commissioning_step6_autofill_event.dart';
import '../../bloc/commissioning_step6_autofill_bloc/commissioning_step6_autofill_state.dart';
import '../../bloc/commissioning_step6_bloc/commissioning_step6_bloc.dart';
import '../../bloc/commissioning_step6_bloc/commissioning_step6_event.dart';
import '../../bloc/commissioning_step6_bloc/commissioning_step6_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step1_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_bloc/service_call_report_step1_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_bloc/service_call_report_step1_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_bloc/service_call_report_step1_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_autofill_bloc/service_call_report_step1_autofill_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_autofill_bloc/service_call_report_step1_autofill_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step1_autofill_bloc/service_call_report_step1_autofill_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step2_autofill_bloc/service_call_report_step2_autofill_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step2_autofill_bloc/service_call_report_step2_autofill_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step2_autofill_bloc/service_call_report_step2_autofill_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step2_bloc/service_call_report_step2_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step2_bloc/service_call_report_step2_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step2_bloc/service_call_report_step2_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step3_bloc/service_call_report_step3_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step3_bloc/service_call_report_step3_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step3_bloc/service_call_report_step3_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step3_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step3_autofill_bloc/service_call_report_step3_autofill_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step3_autofill_bloc/service_call_report_step3_autofill_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step3_autofill_bloc/service_call_report_step3_autofill_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_autofill_bloc/service_call_report_step4_autofill_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_autofill_bloc/service_call_report_step4_autofill_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_autofill_bloc/service_call_report_step4_autofill_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step4_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_bloc/service_call_report_step4_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_bloc/service_call_report_step4_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_bloc/service_call_report_step4_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step4_bloc/service_call_report_step4_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step5_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step5_bloc/service_call_report_step5_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step5_bloc/service_call_report_step5_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step5_bloc/service_call_report_step5_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step5_autofill_bloc/service_call_report_step5_autofill_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step5_autofill_bloc/service_call_report_step5_autofill_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step5_autofill_bloc/service_call_report_step5_autofill_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/service_call_report_step2_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_servicecall_technician_bloc/assigned_servicecall_technician_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_servicecall_technician_bloc/assigned_servicecall_technician_event.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_servicecall_technician_bloc/assigned_servicecall_technician_state.dart';
import '../../bloc/assigned_technician_representative_bloc/assigned_technician_representative_bloc.dart';
import '../../bloc/assigned_technician_representative_bloc/assigned_technician_representative_event.dart';
import '../../bloc/assigned_technician_representative_bloc/assigned_technician_representative_state.dart';
import '../../../../remote/models/commissioning_report_step6_autofill_model/commissioning_report_step6_autofill_response.dart';
import '../../../../remote/models/assigned_technician_representative_model/assigned_technician_representative_response.dart';
import 'package:service_app/src/remote/models/assigned_servicecall_technician_model/assigned_servicecall_technician_response.dart'
    as service_tech_model;
import '../../bloc/commissioning_work_create_bloc/commissioning_work_create_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step6_bloc/service_call_report_step6_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step6_bloc/service_call_report_step6_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step6_bloc/service_call_report_step6_state.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step6_autofill_bloc/service_call_report_step6_autofill_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step6_autofill_bloc/service_call_report_step6_autofill_event.dart';
import 'package:service_app/src/features/service_calls/bloc/service_call_report_step6_autofill_bloc/service_call_report_step6_autofill_state.dart';

part '../../widgets/commissioning_step1_widget.dart';
part '../../widgets/commissioning_step2_widget.dart';
part '../../widgets/commissioning_step3_widget.dart';
part '../../widgets/commissioning_step4_widget.dart';
part '../../widgets/commissioning_step5_widget.dart';
part '../../widgets/commissioning_step6_widget.dart';

class CreateCommissioningReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final bool isServiceReport;
  final String commissioningWorkId;
  final String? complaintNo;
  final int initialStepNo;
  const CreateCommissioningReportScreen({
    super.key,
    required this.onBack,
    required this.commissioningWorkId,
    this.isServiceReport = false,
    this.complaintNo,
    this.initialStepNo = 0,
  });
  @override
  State<CreateCommissioningReportScreen> createState() =>
      _CreateCommissioningReportScreenState();
}

class _CreateCommissioningReportScreenState
    extends State<CreateCommissioningReportScreen> {
  late int _currentStep = widget.initialStepNo > 0 ? widget.initialStepNo : 1;
  bool _hasAppliedInitialStep = false;
  String? _commissioningReportId;
  late List<TextEditingController> _technicians;
  late List<String?> _technicianIds;
  late List<TextEditingController> _representatives;
  String? _selectedWarranty;
  bool _isTechnicalDetailsNA = false;
  int _workDescriptionRows = 5;
  String _warrantySearchQuery = '';
  // â”€â”€ Step 5: Preventive Maintenance Checklist â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // NA toggles per section
  bool _mechNA = false;
  bool _pipeNA = false;
  bool _elecNA = false;
  // Mechanical Checklist
  String? _bearingNoise;
  String? _vibration;
  String? _mechSeal;
  String? _pumpDry;
  // Pipeline / Hydraulic Checklist
  String? _nrvValve;
  String? _strainerValve;
  String? _suctionLine;
  String? _deliveryLine;
  String? _suctionDelivery;
  String? _pressureSwitch;
  // Electrical Checklist
  String? _elecFaults;
  String? _voltage;
  String? _phase;
  String? _current;
  String? _panelWiring;
  late CommissioningStep1AutoFillBloc _step1Bloc;
  late TechnicianBloc _technicianBloc;
  late CommissioningStep1Bloc _submitStep1Bloc;
  late CommissioningStep2Bloc _submitStep2Bloc;
  late CommissioningStep2AutoFillBloc _step2Bloc;
  late TextEditingController _agendaController;
  late CommissioningStep3AutoFillBloc _step3Bloc;
  late CommissioningStep3Bloc _submitStep3Bloc;
  late CommissioningStep4AutoFillBloc _step4Bloc;
  late CommissioningStep4Bloc _submitStep4Bloc;
  late CommissioningStep5AutoFillBloc _step5Bloc;
  late CommissioningStep5Bloc _submitStep5Bloc;
  late CommissioningStep6AutoFillBloc _step6Bloc;
  late CommissioningStep6Bloc _submitStep6Bloc;
  late AssignedTechnicianRepresentativeBloc _assignedTechniciansBloc;
  late AssignedServicecallTechnicianBloc _assignedServiceCallTechnicianBloc;
  late CommissioningWorkCreateBloc _createBloc;
  late ServiceCallReportStep1Bloc _submitServiceCallStep1Bloc;
  late ServiceCallReportStep1AutoFillBloc _serviceCallStep1AutoFillBloc;
  late ServiceCallReportStep2AutoFillBloc _serviceCallStep2AutoFillBloc;
  late ServiceCallReportStep3AutoFillBloc _serviceCallStep3AutoFillBloc;
  late ServiceCallReportStep4AutoFillBloc _serviceCallStep4AutoFillBloc;
  late ServiceCallReportStep5AutoFillBloc _serviceCallStep5AutoFillBloc;
  late ServiceCallReportStep2Bloc _submitServiceCallStep2Bloc;
  late ServiceCallReportStep3Bloc _submitServiceCallStep3Bloc;
  late ServiceCallReportStep4Bloc _submitServiceCallStep4Bloc;
  late ServiceCallReportStep5Bloc _submitServiceCallStep5Bloc;
  late ServiceCallReportStep6Bloc _submitServiceCallStep6Bloc;
  late ServiceCallReportStep6AutoFillBloc _serviceCallStep6AutoFillBloc;
  // Step 6 Controllers & variables
  final _technicianRemarksController = TextEditingController();
  final _customerRemarksController = TextEditingController();
  final _customerRepNameController = TextEditingController();
  final _technicianNameController = TextEditingController();
  String? _selectedTechnicianRepId;
  String? _autofilledTechRepName;
  String? _loggedInTechnicianId;
  String? _loggedInTechnicianName;
  List<AssignedTechnician> _assignedTechniciansList = [];
  List<service_tech_model.AssignedTechnician>
  _assignedServiceCallTechniciansList = [];
  File? _technicianSignatureFile;
  File? _customerSignatureFile;
  String? _existingTechnicianSignatureUrl;
  String? _existingCustomerSignatureUrl;
  final List<File> _workPhotos = [];
  List<String> _existingWorkPhotosUrls = [];
  // Step 3 Controllers
  final _pumpMakeController = TextEditingController();
  final _pumpModelController = TextEditingController();
  final _pumpSerialNumberController = TextEditingController();
  final _pumpFlowLPMController = TextEditingController();
  final _pumpFlowM3HRController = TextEditingController();
  final _pumpFlowLPSController = TextEditingController();
  final _pumpFlowUSGPMController = TextEditingController();
  final _pumpHeadMTRController = TextEditingController();
  final _driverMakeController = TextEditingController();
  final _driverSerialNumberController = TextEditingController();
  final _ratingKWController = TextEditingController();
  final _ratingHPController = TextEditingController();
  final _rpmController = TextEditingController();
  final _controlPanelMakeController = TextEditingController();
  final _panelSerialModelController = TextEditingController();
  final List<TextEditingController> _workDescriptionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final Map<String, File> _step5Media = {};
  final Map<String, String?> _step5ExistingPhotos = {};
  final Map<String, String?> _step5ExistingVideos = {};
  Future<void> _pickMedia(String key, ImageSource source, bool isVideo) async {
    final ImagePicker picker = ImagePicker();
    if (isVideo) {
      final XFile? video = await picker.pickVideo(source: source);
      if (video != null) {
        setState(() {
          _step5Media[key] = File(video.path);
        });
      }
    } else {
      final XFile? photo = await picker.pickImage(source: source);
      if (photo != null) {
        setState(() {
          _step5Media[key] = File(photo.path);
        });
      }
    }
  }

  bool _isAutoCalculatingFlow = false;
  bool _isAutoCalculatingRating = false;

  void _setupAutoCalculateListeners() {
    _pumpFlowLPMController.addListener(() => _calculateFlow('LPM'));
    _pumpFlowLPSController.addListener(() => _calculateFlow('LPS'));
    _pumpFlowM3HRController.addListener(() => _calculateFlow('M3HR'));
    _pumpFlowUSGPMController.addListener(() => _calculateFlow('USGPM'));

    // _ratingKWController.addListener(() => _calculateRating('KW'));
    // _ratingHPController.addListener(() => _calculateRating('HP'));
  }

  void _calculateFlow(String source) {
    if (_isAutoCalculatingFlow) return;
    String text = "";
    if (source == 'LPM')
      text = _pumpFlowLPMController.text;
    else if (source == 'LPS')
      text = _pumpFlowLPSController.text;
    else if (source == 'M3HR')
      text = _pumpFlowM3HRController.text;
    else if (source == 'USGPM')
      text = _pumpFlowUSGPMController.text;

    if (text.isEmpty) {
      _isAutoCalculatingFlow = true;
      if (source != 'LPM') _pumpFlowLPMController.text = "";
      if (source != 'LPS') _pumpFlowLPSController.text = "";
      if (source != 'M3HR') _pumpFlowM3HRController.text = "";
      if (source != 'USGPM') _pumpFlowUSGPMController.text = "";
      _isAutoCalculatingFlow = false;
      return;
    }

    double? value = double.tryParse(text);
    if (value == null) return;

    _isAutoCalculatingFlow = true;
    double lpm = 0, lps = 0, m3hr = 0, usgpm = 0;

    switch (source) {
      case 'LPM':
        lpm = value;
        lps = lpm / 60;
        m3hr = lpm * 0.06;
        usgpm = lpm / 3.78541;
        break;
      case 'LPS':
        lps = value;
        lpm = lps * 60;
        m3hr = lps * 3.6;
        usgpm = lps * 15.8503;
        break;
      case 'M3HR':
        m3hr = value;
        lpm = m3hr * 16.6667;
        lps = m3hr / 3.6;
        usgpm = m3hr * 4.40287;
        break;
      case 'USGPM':
        usgpm = value;
        lpm = usgpm * 3.78541;
        lps = usgpm * 0.0630902;
        m3hr = usgpm * 0.227125;
        break;
    }

    if (source != 'LPM')
      _pumpFlowLPMController.text = lpm.round().toString();
    if (source != 'LPS')
      _pumpFlowLPSController.text = lps.round().toString();
    if (source != 'M3HR')
      _pumpFlowM3HRController.text = m3hr.round().toString();
    if (source != 'USGPM')
      _pumpFlowUSGPMController.text = usgpm.round().toString();

    _isAutoCalculatingFlow = false;
  }

  void _calculateRating(String source) {
    /*
    if (_isAutoCalculatingRating) return;
    String text = source == 'KW'
        ? _ratingKWController.text
        : _ratingHPController.text;

    if (text.isEmpty) {
      _isAutoCalculatingRating = true;
      if (source != 'KW') _ratingKWController.text = "";
      if (source != 'HP') _ratingHPController.text = "";
      _isAutoCalculatingRating = false;
      return;
    }

    double? value = double.tryParse(text);
    if (value == null) return;

    _isAutoCalculatingRating = true;
    double kw = 0, hp = 0;

    if (source == 'KW') {
      kw = value;
      hp = kw / 0.746;
      if (source != 'HP')
        _ratingHPController.text = hp.round().toString();
    } else {
      hp = value;
      kw = hp * 0.746;
      if (source != 'KW')
        _ratingKWController.text = kw.round().toString();
    }

    _isAutoCalculatingRating = false;
    */
  }

  Future<void> _fetchLoggedInTechnician() async {
    final session = await SessionManager.getUserSession();
    if (session?.technician != null) {
      if (mounted) {
        setState(() {
          _loggedInTechnicianId = session!.technician!.id;
          _loggedInTechnicianName = session!.technician!.name;
          _technicianNameController.text = session!.technician!.name;
        });
      }
    } else if (session?.dealer != null) {
      if (mounted) {
        setState(() {
          _loggedInTechnicianId = session!.dealer!.id;
          _loggedInTechnicianName = session!.dealer!.name;
          _technicianNameController.text = session!.dealer!.name;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLoggedInTechnician();
    _setupAutoCalculateListeners();
    _submitStep1Bloc = getIt<CommissioningStep1Bloc>();
    _submitStep2Bloc = getIt<CommissioningStep2Bloc>();
    _step1Bloc = getIt<CommissioningStep1AutoFillBloc>();
    _serviceCallStep1AutoFillBloc = getIt<ServiceCallReportStep1AutoFillBloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
    _step2Bloc = getIt<CommissioningStep2AutoFillBloc>();
    _serviceCallStep2AutoFillBloc = getIt<ServiceCallReportStep2AutoFillBloc>();
    _submitServiceCallStep2Bloc = getIt<ServiceCallReportStep2Bloc>();
    _serviceCallStep3AutoFillBloc = getIt<ServiceCallReportStep3AutoFillBloc>();
    _serviceCallStep4AutoFillBloc = getIt<ServiceCallReportStep4AutoFillBloc>();
    _serviceCallStep5AutoFillBloc = getIt<ServiceCallReportStep5AutoFillBloc>();
    _submitServiceCallStep3Bloc = getIt<ServiceCallReportStep3Bloc>();
    _submitServiceCallStep4Bloc = getIt<ServiceCallReportStep4Bloc>();
    _submitServiceCallStep5Bloc = getIt<ServiceCallReportStep5Bloc>();
    _submitServiceCallStep6Bloc = getIt<ServiceCallReportStep6Bloc>();
    _serviceCallStep6AutoFillBloc = getIt<ServiceCallReportStep6AutoFillBloc>();
    _step3Bloc = getIt<CommissioningStep3AutoFillBloc>();
    _submitStep3Bloc = getIt<CommissioningStep3Bloc>();
    _step4Bloc = getIt<CommissioningStep4AutoFillBloc>();
    _submitStep4Bloc = getIt<CommissioningStep4Bloc>();
    _step5Bloc = getIt<CommissioningStep5AutoFillBloc>();
    _submitStep5Bloc = getIt<CommissioningStep5Bloc>();
    _step6Bloc = getIt<CommissioningStep6AutoFillBloc>();
    _submitStep6Bloc = getIt<CommissioningStep6Bloc>();
    _assignedTechniciansBloc = getIt<AssignedTechnicianRepresentativeBloc>();
    _assignedServiceCallTechnicianBloc =
        getIt<AssignedServicecallTechnicianBloc>();
    _createBloc = getIt<CommissioningWorkCreateBloc>();
    _submitServiceCallStep1Bloc = getIt<ServiceCallReportStep1Bloc>();
    _agendaController = TextEditingController();
    _technicians = [TextEditingController()];
    _technicianIds = [null];
    _representatives = [TextEditingController()];

    if (_currentStep == 1) {
      if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
        _serviceCallStep1AutoFillBloc.add(
          ServiceCallReportStep1AutoFillGetEvent(widget.commissioningWorkId),
        );
      } else {
        _step1Bloc.add(
          CommissioningStep1AutoFillGetEvent(widget.commissioningWorkId),
        );
      }
    } else if (_currentStep == 2) {
      if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
        _serviceCallStep2AutoFillBloc.add(
          ServiceCallReportStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      } else {
        _step2Bloc.add(
          CommissioningStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      }
    } else if (_currentStep == 3) {
      if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
        _serviceCallStep3AutoFillBloc.add(
          ServiceCallReportStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      } else {
        _step3Bloc.add(
          CommissioningStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      }
    } else if (_currentStep == 4) {
      if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
        _serviceCallStep4AutoFillBloc.add(
          ServiceCallReportStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      } else {
        _step4Bloc.add(
          CommissioningStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      }
    } else if (_currentStep == 5) {
      if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
        _serviceCallStep5AutoFillBloc.add(
          ServiceCallReportStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      } else {
        _step5Bloc.add(
          CommissioningStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      }
    } else if (_currentStep == 6) {
      if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
        _serviceCallStep6AutoFillBloc.add(
          ServiceCallReportStep6AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      } else {
        _step6Bloc.add(
          CommissioningStep6AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
        );
      }
    }
  }

  @override
  void dispose() {
    _step1Bloc.close();
    _technicianBloc.close();
    _submitStep1Bloc.close();
    _step6Bloc.close();
    _assignedTechniciansBloc.close();
    _assignedServiceCallTechnicianBloc.close();
    _createBloc.close();
    _submitStep2Bloc.close();
    _step2Bloc.close();
    _step3Bloc.close();
    _submitStep3Bloc.close();
    _step4Bloc.close();
    _submitStep4Bloc.close();
    _step5Bloc.close();
    _submitStep5Bloc.close();
    _step6Bloc.close();
    _submitStep6Bloc.close();
    _assignedTechniciansBloc.close();
    _submitServiceCallStep1Bloc.close();
    _submitServiceCallStep2Bloc.close();
    _submitServiceCallStep3Bloc.close();
    _submitServiceCallStep4Bloc.close();
    _submitServiceCallStep5Bloc.close();
    _submitServiceCallStep6Bloc.close();
    _serviceCallStep6AutoFillBloc.close();
    _serviceCallStep1AutoFillBloc.close();
    _serviceCallStep2AutoFillBloc.close();
    _serviceCallStep3AutoFillBloc.close();
    _serviceCallStep4AutoFillBloc.close();
    _serviceCallStep5AutoFillBloc.close();
    _technicianRemarksController.dispose();
    _customerRemarksController.dispose();
    _customerRepNameController.dispose();
    _technicianNameController.dispose();
    _agendaController.dispose();
    _pumpMakeController.dispose();
    _pumpModelController.dispose();
    _pumpSerialNumberController.dispose();
    _pumpFlowLPMController.dispose();
    _pumpFlowM3HRController.dispose();
    _pumpFlowLPSController.dispose();
    _pumpFlowUSGPMController.dispose();
    _pumpHeadMTRController.dispose();
    _driverMakeController.dispose();
    _driverSerialNumberController.dispose();
    _ratingKWController.dispose();
    _ratingHPController.dispose();
    _rpmController.dispose();
    _controlPanelMakeController.dispose();
    _panelSerialModelController.dispose();
    for (var controller in _technicians) {
      controller.dispose();
    }
    for (var controller in _representatives) {
      controller.dispose();
    }
    for (var controller in _workDescriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      List<String> technicianIdsString = [];
      List<Map<String, dynamic>> technicianIdsMap = [];
      
      final techState = _technicianBloc.state;
      List<dynamic> allTechs = [];
      if (techState is TechnicianSuccessState) {
        allTechs = techState.data.data;
      }

      for (int i = 0; i < _technicians.length; i++) {
        var controller = _technicians[i];
        if (controller.text.isNotEmpty) {
          String name = controller.text;
          String id = _technicianIds[i] ?? "";
          
          if (id.isEmpty) {
            try {
              final match = allTechs.firstWhere((t) => t.name == name);
              id = match.id;
            } catch (_) {}
          }

          technicianIdsMap.add({"id": id, "name": name});
        }
      }
      if (widget.isServiceReport) {
        if (_submitServiceCallStep1Bloc.state
            is ServiceCallReportStep1LoadingState)
          return;
        _submitServiceCallStep1Bloc.add(
          ServiceCallReportStep1PostEvent(
            ServiceCallReportStep1Params(
              complaintId: widget.commissioningWorkId,
              technicianIds: technicianIdsMap,
            ),
          ),
        );
      } else {
        if (_submitStep1Bloc.state is CommissioningStep1LoadingState) return;
        _submitStep1Bloc.add(
          CommissioningStep1GetEvent(widget.commissioningWorkId, technicianIdsMap),
        );
      }
    } else if (_currentStep == 2) {
      if (_submitStep2Bloc.state is CommissioningStep2LoadingState) return;
      List<String> repNames = [];
      for (var c in _representatives) {
        if (c.text.trim().isNotEmpty) {
          repNames.add(c.text.trim());
        }
      }
      if (widget.isServiceReport) {
        if (_submitServiceCallStep2Bloc.state
            is ServiceCallReportStep2LoadingState)
          return;
        _submitServiceCallStep2Bloc.add(
          ServiceCallReportStep2PostEvent(
            ServiceCallReportStep2Params(
              id: _commissioningReportId ?? widget.commissioningWorkId,
              memberPresentsCustomerSide: repNames.join(', '),
              agenda: _agendaController.text.trim(),
            ),
          ),
        );
      } else {
        if (_submitStep2Bloc.state is CommissioningStep2LoadingState) return;
        if (!widget.isServiceReport && _selectedWarranty == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_select_warranty'.tr(),
          );
          return;
        }
        int warrantyYears = _selectedWarranty != null
            ? (int.tryParse(_selectedWarranty!.split('_').first) ?? 1)
            : 1;
        _submitStep2Bloc.add(
          CommissioningStep2GetEvent(
            _commissioningReportId ?? widget.commissioningWorkId,
            warrantyYears,
            repNames,
            _agendaController.text.trim(),
          ),
        );
      }
    } else if (_currentStep == 3) {
      final techDetails = _isTechnicalDetailsNA
          ? null
          : TechnicalDetails(
              pumpMake: _pumpMakeController.text,
              pumpModel: _pumpModelController.text,
              pumpSerialNumber: _pumpSerialNumberController.text,
              pumpFlowLpm: _pumpFlowLPMController.text,
              pumpFlowM3hr: _pumpFlowM3HRController.text,
              pumpFlowLps: _pumpFlowLPSController.text,
              pumpFlowUsgpm: _pumpFlowUSGPMController.text,
              pumpHeadMtr: _pumpHeadMTRController.text,
              driverMake: _driverMakeController.text,
              driverSerialNumber: _driverSerialNumberController.text,
              ratingKw: _ratingKWController.text,
              ratingHp: _ratingHPController.text,
              rpm: _rpmController.text,
              controlPanelMake: _controlPanelMakeController.text,
              panelSerialModel: _panelSerialModelController.text,
            );
      if (widget.isServiceReport) {
        if (_submitServiceCallStep3Bloc.state
            is ServiceCallReportStep3LoadingState)
          return;
        _submitServiceCallStep3Bloc.add(
          ServiceCallReportStep3PostEvent(
            ServiceCallReportStep3Params(
              id: _commissioningReportId ?? widget.commissioningWorkId,
              isTechnicalNa: _isTechnicalDetailsNA,
              technicalDetails: techDetails,
            ),
          ),
        );
      } else {
        if (_submitStep3Bloc.state is CommissioningStep3LoadingState) return;
        _submitStep3Bloc.add(
          CommissioningStep3GetEvent(
            _commissioningReportId ?? widget.commissioningWorkId,
            _isTechnicalDetailsNA,
            techDetails,
          ),
        );
      }
    } else if (_currentStep == 4) {
      if (_submitStep4Bloc.state is CommissioningStep4LoadingState) return;
      List<SavedDescription> descriptions = [];
      for (int i = 0; i < _workDescriptionControllers.length; i++) {
        final text = _workDescriptionControllers[i].text.trim();
        if (text.isNotEmpty) {
          descriptions.add(SavedDescription(srNo: i + 1, description: text));
        }
      }
      // if (descriptions.isEmpty) {
      //   appSnackBar(
      //     context,
      //     const Color(0xFFF44336),
      //     "Please enter at least one work description",
      //   );
      //   return;
      // }
      if (widget.isServiceReport) {
        _submitServiceCallStep4Bloc.add(
          ServiceCallReportStep4PostEvent(
            reportId: _commissioningReportId ?? widget.commissioningWorkId,
            descriptions: descriptions
                .map((e) => {"sr_no": e.srNo, "description": e.description})
                .toList(),
          ),
        );
      } else {
        _submitStep4Bloc.add(
          CommissioningStep4GetEvent(
            _commissioningReportId ?? widget.commissioningWorkId,
            descriptions,
          ),
        );
      }
    } else if (_currentStep == 5) {
      if (_submitStep5Bloc.state is CommissioningStep5LoadingState) return;
      List<SavedChecklist> savedChecklists = [];
      // Add mechanical checklists if not NA
      if (!_mechNA) {
        if (_bearingNoise != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "mechanical",
              keyChecklist: "Bearing noise",
              valueChecklist: _bearingNoise!,
              photo: _step5Media['chk_bearing_noise'.tr()]?.path,
              video: _step5Media['chk_bearing_noise'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Bearing noise'],
              existingVideoUrl: _step5ExistingVideos['Bearing noise'],
            ),
          );
        if (_vibration != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "mechanical",
              keyChecklist: "Vibration",
              valueChecklist: _vibration!,
              photo: _step5Media['chk_vibration'.tr()]?.path,
              video: _step5Media['chk_vibration'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Vibration'],
              existingVideoUrl: _step5ExistingVideos['Vibration'],
            ),
          );
        if (_mechSeal != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "mechanical",
              keyChecklist: "Mechanical seal",
              valueChecklist: _mechSeal!,
              photo: _step5Media['chk_mech_seal'.tr()]?.path,
              video: _step5Media['chk_mech_seal'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Mechanical seal'],
              existingVideoUrl: _step5ExistingVideos['Mechanical seal'],
            ),
          );
        if (_pumpDry != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "mechanical",
              keyChecklist: "Pump not running dry",
              valueChecklist: _pumpDry!,
              photo: _step5Media['chk_pump_dry'.tr()]?.path,
              video: _step5Media['chk_pump_dry'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Pump not running dry'],
              existingVideoUrl: _step5ExistingVideos['Pump not running dry'],
            ),
          );
      }
      // Add pipeline checklists if not NA
      if (!_pipeNA) {
        if (_nrvValve != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "pipeline_hydraulic",
              keyChecklist: "NRV",
              valueChecklist: _nrvValve!,
              photo: _step5Media['chk_nrv'.tr()]?.path,
              video: _step5Media['chk_nrv'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['NRV'],
              existingVideoUrl: _step5ExistingVideos['NRV'],
            ),
          );
        if (_strainerValve != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "pipeline_hydraulic",
              keyChecklist: "Strainer",
              valueChecklist: _strainerValve!,
              photo: _step5Media['chk_strainer'.tr()]?.path,
              video: _step5Media['chk_strainer'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Strainer'],
              existingVideoUrl: _step5ExistingVideos['Strainer'],
            ),
          );
        if (_suctionLine != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "pipeline_hydraulic",
              keyChecklist: "Suction line",
              valueChecklist: _suctionLine!,
              photo: _step5Media['chk_suction_line'.tr()]?.path,
              video: _step5Media['chk_suction_line'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Suction line'],
              existingVideoUrl: _step5ExistingVideos['Suction line'],
            ),
          );
        if (_deliveryLine != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "pipeline_hydraulic",
              keyChecklist: "Delivery line",
              valueChecklist: _deliveryLine!,
              photo: _step5Media['chk_delivery_line'.tr()]?.path,
              video: _step5Media['chk_delivery_line'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Delivery line'],
              existingVideoUrl: _step5ExistingVideos['Delivery line'],
            ),
          );
        if (_suctionDelivery != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "pipeline_hydraulic",
              keyChecklist: "Suction / Delivery Valve",
              valueChecklist: _suctionDelivery!,
              photo: _step5Media['chk_suction_del_valve'.tr()]?.path,
              video: _step5Media['chk_suction_del_valve'.tr()]?.path,
              existingPhotoUrl:
                  _step5ExistingPhotos['Suction / Delivery Valve'],
              existingVideoUrl:
                  _step5ExistingVideos['Suction / Delivery Valve'],
            ),
          );
        if (_pressureSwitch != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "pipeline_hydraulic",
              keyChecklist: "Pressure switch",
              valueChecklist: _pressureSwitch!,
              photo: _step5Media['chk_pressure_switch'.tr()]?.path,
              video: _step5Media['chk_pressure_switch'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Pressure switch'],
              existingVideoUrl: _step5ExistingVideos['Pressure switch'],
            ),
          );
      }
      // Add electrical checklists if not NA
      if (!_elecNA) {
        if (_elecFaults != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "electrical",
              keyChecklist: "Electrical Faults",
              valueChecklist: _elecFaults!,
              photo: _step5Media['chk_elec_faults'.tr()]?.path,
              video: _step5Media['chk_elec_faults'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Electrical Faults'],
              existingVideoUrl: _step5ExistingVideos['Electrical Faults'],
            ),
          );
        if (_voltage != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "electrical",
              keyChecklist: "Voltage Check",
              valueChecklist: _voltage!,
              photo: _step5Media['chk_voltage'.tr()]?.path,
              video: _step5Media['chk_voltage'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Voltage Check'],
              existingVideoUrl: _step5ExistingVideos['Voltage Check'],
            ),
          );
        if (_phase != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "electrical",
              keyChecklist: "Phase Check",
              valueChecklist: _phase!,
              photo: _step5Media['chk_phase'.tr()]?.path,
              video: _step5Media['chk_phase'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Phase Check'],
              existingVideoUrl: _step5ExistingVideos['Phase Check'],
            ),
          );
        if (_current != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "electrical",
              keyChecklist: "Current Check",
              valueChecklist: _current!,
              photo: _step5Media['chk_current'.tr()]?.path,
              video: _step5Media['chk_current'.tr()]?.path,
              existingPhotoUrl: _step5ExistingPhotos['Current Check'],
              existingVideoUrl: _step5ExistingVideos['Current Check'],
            ),
          );
        if (_panelWiring != null)
          savedChecklists.add(
            SavedChecklist(
              id: "",
              checkType: "electrical",
              keyChecklist: "Control Panel Wiring",
              valueChecklist: _panelWiring!,
              photo: _step5Media['Panel Wiring Checked:']?.path,
              video: _step5Media['Panel Wiring Checked:']?.path,
              existingPhotoUrl: _step5ExistingPhotos['Control Panel Wiring'],
              existingVideoUrl: _step5ExistingVideos['Control Panel Wiring'],
            ),
          );
      }
      // Validate mechanical section
      if (!_mechNA) {
        if (_bearingNoise == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_bearing'.tr());
          return;
        }
        if (_vibration == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_vibration'.tr(),
          );
          return;
        }
        if (_mechSeal == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_mech_seal'.tr(),
          );
          return;
        }
        if (_pumpDry == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_pump_dry'.tr(),
          );
          return;
        }
      }
      // Validate pipeline section
      if (!_pipeNA) {
        if (_nrvValve == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_nrv'.tr());
          return;
        }
        if (_strainerValve == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_strainer'.tr(),
          );
          return;
        }
        if (_suctionLine == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_suction_line'.tr(),
          );
          return;
        }
        if (_deliveryLine == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_del_line'.tr(),
          );
          return;
        }
        if (_suctionDelivery == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_suction_del'.tr(),
          );
          return;
        }
        if (_pressureSwitch == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_pressure'.tr(),
          );
          return;
        }
      }
      // Validate electrical section
      if (!_elecNA) {
        if (_elecFaults == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_elec_faults'.tr(),
          );
          return;
        }
        if (_voltage == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_voltage'.tr());
          return;
        }
        if (_phase == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_phase'.tr());
          return;
        }
        if (_current == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_current'.tr());
          return;
        }
        if (_panelWiring == null) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_panel_wiring'.tr(),
          );
          return;
        }
      }
      if (widget.isServiceReport) {
        _submitServiceCallStep5Bloc.add(
          ServiceCallReportStep5PostEvent(
            reportId: _commissioningReportId ?? widget.commissioningWorkId,
            isMechanicalChecklistNa: _mechNA,
            isPipelineChecklistNa: _pipeNA,
            isElectricalChecklistNa: _elecNA,
            checklistItems: savedChecklists
                .map(
                  (e) => {
                    "check_type": e.checkType,
                    "key_checklist": e.keyChecklist,
                    "value_checklist": e.valueChecklist,
                    if (e.photo != null) "photo": e.photo,
                    if (e.video != null) "video": e.video,
                  },
                )
                .toList(),
          ),
        );
      } else {
        _submitStep5Bloc.add(
          CommissioningStep5GetEvent(
            _commissioningReportId ?? widget.commissioningWorkId,
            _mechNA,
            _pipeNA,
            _elecNA,
            savedChecklists,
          ),
        );
      }
    } else if (_currentStep == 6) {
      if (_submitStep6Bloc.state is CommissioningStep6LoadingState ||
          _submitServiceCallStep6Bloc.state
              is ServiceCallReportStep6LoadingState)
        return;
      print(
        "ðŸš€ Submitting Step 6: technicianRepresentative = '$_selectedTechnicianRepId'",
      );
      if (widget.isServiceReport) {
        String? techSignaturePath = _technicianSignatureFile?.path;
        if (techSignaturePath == null &&
            _existingTechnicianSignatureUrl != null &&
            _existingTechnicianSignatureUrl!.isNotEmpty) {
          techSignaturePath = _existingTechnicianSignatureUrl;
        }
        String? custSignaturePath = _customerSignatureFile?.path;
        if (custSignaturePath == null &&
            _existingCustomerSignatureUrl != null &&
            _existingCustomerSignatureUrl!.isNotEmpty) {
          custSignaturePath = _existingCustomerSignatureUrl;
        }
        List<String> workPhotosPaths = _workPhotos.map((f) => f.path).toList();
        if (workPhotosPaths.isEmpty && _existingWorkPhotosUrls.isNotEmpty) {
          workPhotosPaths = List.from(_existingWorkPhotosUrls);
        } else if (_existingWorkPhotosUrls.isNotEmpty) {
          workPhotosPaths.addAll(_existingWorkPhotosUrls);
        }
        // Validation
        if (_selectedTechnicianRepId == null ||
            _selectedTechnicianRepId!.isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_tech_rep'.tr(),
          );
          return;
        }
        if (techSignaturePath == null || techSignaturePath.isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_add_tech_sig'.tr(),
          );
          return;
        }
        if (_customerRepNameController.text.trim().isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_enter_cust_rep'.tr(),
          );
          return;
        }
        if (custSignaturePath == null || custSignaturePath.isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_add_cust_sig'.tr(),
          );
          return;
        }
        if (workPhotosPaths.isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_upload_photo'.tr(),
          );
          return;
        }
        _submitServiceCallStep6Bloc.add(
          ServiceCallReportStep6SubmitEvent(
            reportId: _commissioningReportId ?? widget.commissioningWorkId,
            technicianRemarks: _technicianRemarksController.text.trim(),
            customerRemarks: _customerRemarksController.text.trim(),
            technicianRepresentative: _selectedTechnicianRepId ?? '',
            customerRepresentativeName: _customerRepNameController.text.trim(),
            technicianSignaturePath: techSignaturePath,
            customerSignaturePath: custSignaturePath,
            workPhotosPaths: workPhotosPaths,
          ),
        );
      } else {
        // Validation for commissioning flow
        if (_selectedTechnicianRepId == null ||
            _selectedTechnicianRepId!.isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_sel_tech_rep'.tr(),
          );
          return;
        }
        if (_technicianSignatureFile == null &&
            (_existingTechnicianSignatureUrl == null ||
                _existingTechnicianSignatureUrl!.isEmpty)) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_add_tech_sig'.tr(),
          );
          return;
        }
        if (_customerRepNameController.text.trim().isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_enter_cust_rep'.tr(),
          );
          return;
        }
        if (_customerSignatureFile == null &&
            (_existingCustomerSignatureUrl == null ||
                _existingCustomerSignatureUrl!.isEmpty)) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_add_cust_sig'.tr(),
          );
          return;
        }
        final allWorkPhotos = [..._workPhotos, ..._existingWorkPhotosUrls];
        if (allWorkPhotos.isEmpty) {
          appSnackBar(
            context,
            const Color(0xFFF44336),
            'val_upload_photo'.tr(),
          );
          return;
        }
        _submitStep6Bloc.add(
          CommissioningStep6SubmitEvent(
            commissioning_report_id:
                _commissioningReportId ?? widget.commissioningWorkId,
            technicianRemarks: _technicianRemarksController.text.trim(),
            customerRemarks: _customerRemarksController.text.trim(),
            technicianRepresentative: _selectedTechnicianRepId ?? '',
            customerRepresentativeName: _customerRepNameController.text.trim(),
            technicianSignaturePath: _technicianSignatureFile?.path,
            customerSignaturePath: _customerSignatureFile?.path,
            workPhotosPaths: _workPhotos.map((f) => f.path).toList(),
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
        if (_currentStep == 1) {
          if (widget.isServiceReport && widget.commissioningWorkId.isNotEmpty) {
            _serviceCallStep1AutoFillBloc.add(
              ServiceCallReportStep1AutoFillGetEvent(
                widget.commissioningWorkId,
              ),
            );
          } else {
            _step1Bloc.add(
              CommissioningStep1AutoFillGetEvent(widget.commissioningWorkId),
            );
          }
        } else if (_currentStep == 2) {
          if (widget.isServiceReport) {
            final idToUse =
                _commissioningReportId ?? widget.commissioningWorkId;
            if (idToUse.isNotEmpty) {
              _serviceCallStep2AutoFillBloc.add(
                ServiceCallReportStep2AutoFillGetEvent(idToUse),
              );
            }
          } else {
            if (_commissioningReportId != null) {
              _step2Bloc.add(
                CommissioningStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
              );
            }
          }
        } else if (_currentStep == 3) {
          if (widget.isServiceReport) {
            final idToUse =
                _commissioningReportId ?? widget.commissioningWorkId;
            if (idToUse.isNotEmpty) {
              _serviceCallStep3AutoFillBloc.add(
                ServiceCallReportStep3AutoFillGetEvent(idToUse),
              );
            }
          } else {
            if (_commissioningReportId != null) {
              _step3Bloc.add(
                CommissioningStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
              );
            }
          }
        } else if (_currentStep == 4) {
          if (widget.isServiceReport) {
            final idToUse =
                _commissioningReportId ?? widget.commissioningWorkId;
            if (idToUse.isNotEmpty) {
              _serviceCallStep4AutoFillBloc.add(
                ServiceCallReportStep4AutoFillGetEvent(idToUse),
              );
            }
          } else {
            if (_commissioningReportId != null) {
              _step4Bloc.add(
                CommissioningStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
              );
            }
          }
        } else if (_currentStep == 5) {
          if (widget.isServiceReport) {
            final idToUse =
                _commissioningReportId ?? widget.commissioningWorkId;
            if (idToUse.isNotEmpty) {
              _serviceCallStep5AutoFillBloc.add(
                ServiceCallReportStep5AutoFillGetEvent(idToUse),
              );
            }
          } else {
            if (_commissioningReportId != null) {
              _step5Bloc.add(
                CommissioningStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
              );
            }
          }
        }
      });
    } else {
      widget.onBack();
    }
  }

  void _showSuccessDialog({String? qrCodeImage}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
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
                        onPressed: ()
                        {
                          Navigator.of(context).pop();
                          widget.onBack();
                        },
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
                    widget.isServiceReport ? 'service_call_report_feedback'.tr() : 'commissioning_work_report_feedback'.tr(),
                    textAlign: TextAlign.center,
                    style: AppFont.style(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F2F6)),
                    ),
                    child: qrCodeImage != null && qrCodeImage.isNotEmpty
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
                    '',
                    textAlign: TextAlign.center,
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void updateState(VoidCallback callback) {
    setState(callback);
  }
@override
  Widget build(BuildContext context) {
    return BlocListener<
      ServiceCallReportStep6AutoFillBloc,
      ServiceCallReportStep6AutoFillState
    >(
      bloc: _serviceCallStep6AutoFillBloc,
      listener: (context, state) {
        if (state is ServiceCallReportStep6AutoFillSuccessState) {
          final data = state.data.data;
          _technicianRemarksController.text = data.technicianRemarks;
          _customerRemarksController.text = data.customerRemarks;
          _customerRepNameController.text = data.customerRepresentativeName;
          if (data.technicianRepresentativeName.isNotEmpty) {
            _autofilledTechRepName = data.technicianRepresentativeName;
          }
          if (data.technicianSignature.isNotEmpty) {
            _existingTechnicianSignatureUrl = data.technicianSignature;
          }
          if (data.customerSignature.isNotEmpty) {
            _existingCustomerSignatureUrl = data.customerSignature;
          }
          if (data.savedWorkPhotos.isNotEmpty) {
            _existingWorkPhotosUrls = data.savedWorkPhotos;
          }
          setState(() {});
        }
      },
      child: BlocListener<ServiceCallReportStep3Bloc, ServiceCallReportStep3State>(
        bloc: _submitServiceCallStep3Bloc,
        listener: (context, state) {
          if (state is ServiceCallReportStep3SuccessState) {
            appSnackBar(context, const Color(0xFF4CAF50), state.data.message);
            setState(() {
              _currentStep++;
              if (_currentStep == 4 && _commissioningReportId != null) {
                _serviceCallStep4AutoFillBloc.add(
                  ServiceCallReportStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                );
              }
            });
          } else if (state is ServiceCallReportStep3FailureState) {
            appSnackBar(context, const Color(0xFFF44336), state.message);
          }
        },
        child: BlocListener<ServiceCallReportStep2Bloc, ServiceCallReportStep2State>(
          bloc: _submitServiceCallStep2Bloc,
          listener: (context, state) {
            if (state is ServiceCallReportStep2SuccessState) {
              appSnackBar(context, const Color(0xFF4CAF50), state.data.message);
              setState(() {
                _currentStep++;
                if (_currentStep == 3 && _commissioningReportId != null) {
                  _serviceCallStep3AutoFillBloc.add(
                    ServiceCallReportStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                  );
                }
              });
            } else if (state is ServiceCallReportStep2FailureState) {
              appSnackBar(context, const Color(0xFFF44336), state.message);
            }
          },
          child: BlocListener<CommissioningStep2Bloc, CommissioningStep2State>(
            bloc: _submitStep2Bloc,
            listener: (context, state) {
              if (state is CommissioningStep2SuccessState) {
                appSnackBar(
                  context,
                  const Color(0xFF4CAF50),
                  state.data.message,
                );
                setState(() {
                  _currentStep++;
                  if (_currentStep == 3 && _commissioningReportId != null) {
                    _step3Bloc.add(
                      CommissioningStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                    );
                  }
                });
              } else if (state is CommissioningStep2FailureState) {
                appSnackBar(context, const Color(0xFFF44336), state.message);
              }
            },
            child: BlocListener<CommissioningStep1Bloc, CommissioningStep1State>(
              bloc: _submitStep1Bloc,
              listener: (context, state) {
                if (state is CommissioningStep1lSuccessState) {
                  appSnackBar(
                    context,
                    const Color(0xFF4CAF50),
                    state.data.message,
                  );
                  _commissioningReportId = state.data.data.id;
                  setState(() {
                    _currentStep++;
                    if (_currentStep == 2 && _commissioningReportId != null) {
                      _step2Bloc.add(
                        CommissioningStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                      );
                    }
                  });
                } else if (state is CommissioningStep1FailureState) {
                  appSnackBar(context, const Color(0xFFF44336), state.message);
                }
              },
              child: BlocListener<ServiceCallReportStep1Bloc, ServiceCallReportStep1State>(
                bloc: _submitServiceCallStep1Bloc,
                listener: (context, state) {
                  if (state is ServiceCallReportStep1SuccessState) {
                    appSnackBar(
                      context,
                      const Color(0xFF4CAF50),
                      state.data.message,
                    );
                    _commissioningReportId = state.data.data.id;
                    // Move to step 2 for service calls if needed
                    setState(() {
                      _currentStep++;
                      if (_currentStep == 2 && _commissioningReportId != null) {
                        _serviceCallStep2AutoFillBloc.add(
                          ServiceCallReportStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                        );
                      }
                    });
                  } else if (state is ServiceCallReportStep1FailureState) {
                    appSnackBar(
                      context,
                      const Color(0xFFF44336),
                      state.message,
                    );
                  }
                },
                child: BlocListener<CommissioningStep3Bloc, CommissioningStep3State>(
                  bloc: _submitStep3Bloc,
                  listener: (context, state) {
                    if (state is CommissioningStep3SuccessState) {
                      appSnackBar(
                        context,
                        const Color(0xFF4CAF50),
                        state.data.message,
                      );
                      setState(() {
                        _currentStep++;
                        if (_currentStep == 4 &&
                            _commissioningReportId != null) {
                          _step4Bloc.add(
                            CommissioningStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        }
                      });
                    } else if (state is CommissioningStep3FailureState) {
                      appSnackBar(
                        context,
                        const Color(0xFFF44336),
                        state.message,
                      );
                    }
                  },
                  child:
                      BlocListener<
                        ServiceCallReportStep3AutoFillBloc,
                        ServiceCallReportStep3AutoFillState
                      >(
                        bloc: _serviceCallStep3AutoFillBloc,
                        listener: (context, state) {
                          if (state
                              is ServiceCallReportStep3AutoFillSuccessState) {
                            final data = state.data.data;
                            setState(() {
                              _isTechnicalDetailsNA = data.isTechnicalNa;
                              final techDetails = data.technicalDetails;
                              if (techDetails.isNotEmpty) {
                                _pumpMakeController.text =
                                    techDetails['pump_make'] ?? '';
                                _pumpModelController.text =
                                    techDetails['pump_model'] ?? '';
                                _pumpSerialNumberController.text =
                                    techDetails['pump_serial_number'] ?? '';
                                _pumpFlowLPMController.text =
                                    techDetails['pump_flow_lpm'] ?? '';
                                _pumpFlowM3HRController.text =
                                    techDetails['pump_flow_m3hr'] ?? '';
                                _pumpFlowLPSController.text =
                                    techDetails['pump_flow_lps'] ?? '';
                                _pumpFlowUSGPMController.text =
                                    techDetails['pump_flow_usgpm'] ?? '';
                                _pumpHeadMTRController.text =
                                    techDetails['pump_head_mtr'] ?? '';
                                _driverMakeController.text =
                                    techDetails['driver_make'] ?? '';
                                _driverSerialNumberController.text =
                                    techDetails['driver_serial_number'] ?? '';
                                _ratingKWController.text =
                                    techDetails['rating_kw'] ?? '';
                                _ratingHPController.text =
                                    techDetails['rating_hp'] ?? '';
                                _rpmController.text = techDetails['rpm'] ?? '';
                                _controlPanelMakeController.text =
                                    techDetails['control_panel_make'] ?? '';
                                _panelSerialModelController.text =
                                    techDetails['panel_serial_model'] ?? '';
                              } else {
                                _pumpMakeController.text = '';
                                _pumpModelController.text = '';
                                _pumpSerialNumberController.text = '';
                                _pumpFlowLPMController.text = '';
                                _pumpFlowM3HRController.text = '';
                                _pumpFlowLPSController.text = '';
                                _pumpFlowUSGPMController.text = '';
                                _pumpHeadMTRController.text = '';
                                _driverMakeController.text = '';
                                _driverSerialNumberController.text = '';
                                _ratingKWController.text = '';
                                _ratingHPController.text = '';
                                _rpmController.text = '';
                                _controlPanelMakeController.text = '';
                                _panelSerialModelController.text = '';
                              }
                            });
                          }
                        },
                        child:
                            BlocListener<
                              CommissioningStep3AutoFillBloc,
                              CommissioningStep3AutoFillState
                            >(
                              bloc: _step3Bloc,
                              listener: (context, state) {
                                if (state
                                    is CommissioningStep3AutoFillSuccessState) {
                                  final data = state.data.data;
                                  _isTechnicalDetailsNA = data.isTechnicalNa;
                                  final techDetails = data.technicalDetails;
                                  if (techDetails != null) {
                                    _pumpMakeController.text =
                                        techDetails.pumpMake ?? '';
                                    _pumpModelController.text =
                                        techDetails.pumpModel ?? '';
                                    _pumpSerialNumberController.text =
                                        techDetails.pumpSerialNumber ?? '';
                                    _pumpFlowLPMController.text =
                                        techDetails.pumpFlowLpm ?? '';
                                    _pumpFlowM3HRController.text =
                                        techDetails.pumpFlowM3hr ?? '';
                                    _pumpFlowLPSController.text =
                                        techDetails.pumpFlowLps ?? '';
                                    _pumpFlowUSGPMController.text =
                                        techDetails.pumpFlowUsgpm ?? '';
                                    _pumpHeadMTRController.text =
                                        techDetails.pumpHeadMtr ?? '';
                                    _driverMakeController.text =
                                        techDetails.driverMake ?? '';
                                    _driverSerialNumberController.text =
                                        techDetails.driverSerialNumber ?? '';
                                    _ratingKWController.text =
                                        techDetails.ratingKw ?? '';
                                    _ratingHPController.text =
                                        techDetails.ratingHp ?? '';
                                    _rpmController.text = techDetails.rpm ?? '';
                                    _controlPanelMakeController.text =
                                        techDetails.controlPanelMake ?? '';
                                    _panelSerialModelController.text =
                                        techDetails.panelSerialModel ?? '';
                                  } else {
                                    _pumpMakeController.text = '';
                                    _pumpModelController.text = '';
                                    _pumpSerialNumberController.text = '';
                                    _pumpFlowLPMController.text = '';
                                    _pumpFlowM3HRController.text = '';
                                    _pumpFlowLPSController.text = '';
                                    _pumpFlowUSGPMController.text = '';
                                    _pumpHeadMTRController.text = '';
                                    _driverMakeController.text = '';
                                    _driverSerialNumberController.text = '';
                                    _ratingKWController.text = '';
                                    _ratingHPController.text = '';
                                    _rpmController.text = '';
                                    _controlPanelMakeController.text = '';
                                    _panelSerialModelController.text = '';
                                  }
                                  setState(() {});
                                }
                              },
                              child:
                                  BlocListener<
                                    ServiceCallReportStep4Bloc,
                                    ServiceCallReportStep4State
                                  >(
                                    bloc: _submitServiceCallStep4Bloc,
                                    listener: (context, state) {
                                      if (state
                                          is ServiceCallReportStep4SuccessState) {
                                        appSnackBar(
                                          context,
                                          const Color(0xFF4CAF50),
                                          state.data.message,
                                        );
                                        setState(() {
                                          _currentStep++;
                                          if (_currentStep == 5 &&
                                              _commissioningReportId != null) {
                                            _serviceCallStep5AutoFillBloc.add(
                                              ServiceCallReportStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                                            );
                                          }
                                        });
                                      } else if (state
                                          is ServiceCallReportStep4FailureState) {
                                        appSnackBar(
                                          context,
                                          const Color(0xFFF44336),
                                          state.message,
                                        );
                                      }
                                    },
                                    child:
                                        BlocListener<
                                          CommissioningStep4Bloc,
                                          CommissioningStep4State
                                        >(
                                          bloc: _submitStep4Bloc,
                                          listener: (context, state) {
                                            if (state
                                                is CommissioningStep4SuccessState) {
                                              appSnackBar(
                                                context,
                                                const Color(0xFF4CAF50),
                                                state.data.message,
                                              );
                                              setState(() {
                                                _currentStep++;
                                                if (_currentStep == 5 &&
                                                    _commissioningReportId !=
                                                        null) {
                                                  _step5Bloc.add(
                                                    CommissioningStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                                                  );
                                                }
                                              });
                                            } else if (state
                                                is CommissioningStep4FailureState) {
                                              appSnackBar(
                                                context,
                                                const Color(0xFFF44336),
                                                state.message,
                                              );
                                            }
                                          },
                                          child:
                                              BlocListener<
                                                ServiceCallReportStep4AutoFillBloc,
                                                ServiceCallReportStep4AutoFillState
                                              >(
                                                bloc:
                                                    _serviceCallStep4AutoFillBloc,
                                                listener: (context, state) {
                                                  if (state
                                                      is ServiceCallReportStep4AutoFillSuccessState) {
                                                    final data =
                                                        state.data.data;
                                                    if (data
                                                        .savedDescriptions
                                                        .isNotEmpty) {
                                                      for (
                                                        int i = 0;
                                                        i <
                                                            data
                                                                .savedDescriptions
                                                                .length;
                                                        i++
                                                      ) {
                                                        if (i <
                                                            _workDescriptionControllers
                                                                .length) {
                                                          _workDescriptionControllers[i]
                                                              .text = data
                                                              .savedDescriptions[i]
                                                              .description;
                                                        } else {
                                                          _workDescriptionControllers.add(
                                                            TextEditingController(
                                                              text: data
                                                                  .savedDescriptions[i]
                                                                  .description,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    } else {
                                                      for (var controller
                                                          in _workDescriptionControllers) {
                                                        controller.text = '';
                                                      }
                                                    }
                                                    setState(() {});
                                                  }
                                                },
                                                child:
                                                    BlocListener<
                                                      CommissioningStep4AutoFillBloc,
                                                      CommissioningStep4AutoFillState
                                                    >(
                                                      bloc: _step4Bloc,
                                                      listener: (context, state) {
                                                        if (state
                                                            is CommissioningStep4AutoFillSuccessState) {
                                                          final data =
                                                              state.data.data;
                                                          if (data
                                                              .savedDescriptions
                                                              .isNotEmpty) {
                                                            for (
                                                              int i = 0;
                                                              i <
                                                                  data
                                                                      .savedDescriptions
                                                                      .length;
                                                              i++
                                                            ) {
                                                              if (i <
                                                                  _workDescriptionControllers
                                                                      .length) {
                                                                _workDescriptionControllers[i]
                                                                    .text = data
                                                                    .savedDescriptions[i]
                                                                    .description;
                                                              } else {
                                                                _workDescriptionControllers.add(
                                                                  TextEditingController(
                                                                    text: data
                                                                        .savedDescriptions[i]
                                                                        .description,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          } else {
                                                            for (var controller
                                                                in _workDescriptionControllers) {
                                                              controller.text =
                                                                  '';
                                                            }
                                                          }
                                                          setState(() {});
                                                        }
                                                      },
                                                      child:
                                                          BlocListener<
                                                            ServiceCallReportStep5Bloc,
                                                            ServiceCallReportStep5State
                                                          >(
                                                            bloc:
                                                                _submitServiceCallStep5Bloc,
                                                            listener: (context, state) {
                                                              if (state
                                                                  is ServiceCallReportStep5SuccessState) {
                                                                appSnackBar(
                                                                  context,
                                                                  const Color(
                                                                    0xFF4CAF50,
                                                                  ),
                                                                  state
                                                                      .data
                                                                      .message,
                                                                );
                                                                setState(() {
                                                                  _currentStep++;
                                                                  if (_currentStep ==
                                                                          6 &&
                                                                      _commissioningReportId !=
                                                                          null) {
                                                                    _assignedServiceCallTechnicianBloc.add(
                                                                      AssignedServicecallTechnicianGetEvent(
                                                                        _commissioningReportId!,
                                                                      ),
                                                                    );
                                                                    _serviceCallStep6AutoFillBloc.add(
                                                                      ServiceCallReportStep6AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                                                                    );
                                                                  }
                                                                });
                                                              } else if (state
                                                                  is ServiceCallReportStep5FailureState) {
                                                                appSnackBar(
                                                                  context,
                                                                  const Color(
                                                                    0xFFF44336,
                                                                  ),
                                                                  state.message,
                                                                );
                                                              }
                                                            },
                                                            child:
                                                                BlocListener<
                                                                  CommissioningStep5Bloc,
                                                                  CommissioningStep5State
                                                                >(
                                                                  bloc:
                                                                      _submitStep5Bloc,
                                                                  listener:
                                                                      (
                                                                        context,
                                                                        state,
                                                                      ) {
                                                                        if (state
                                                                            is CommissioningStep5SuccessState) {
                                                                          appSnackBar(
                                                                            context,
                                                                            const Color(
                                                                              0xFF4CAF50,
                                                                            ),
                                                                            state.data.message,
                                                                          );
                                                                          setState(() {
                                                                            _currentStep++;
                                                                            if (_currentStep ==
                                                                                    6 &&
                                                                                _commissioningReportId !=
                                                                                    null) {
                                                                              _step6Bloc.add(
                                                                                CommissioningStep6AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                                                                              );
                                                                              _assignedTechniciansBloc.add(
                                                                                AssignedTechnicianRepresentativeGetEvent(
                                                                                  _commissioningReportId!,
                                                                                ),
                                                                              );
                                                                            }
                                                                          });
                                                                        } else if (state
                                                                            is CommissioningStep5FailureState) {
                                                                          appSnackBar(
                                                                            context,
                                                                            const Color(
                                                                              0xFFF44336,
                                                                            ),
                                                                            state.message,
                                                                          );
                                                                        }
                                                                      },
                                                                  child:
                                                                      BlocListener<
                                                                        CommissioningStep5AutoFillBloc,
                                                                        CommissioningStep5AutoFillState
                                                                      >(
                                                                        bloc:
                                                                            _step5Bloc,
                                                                        listener:
                                                                            (
                                                                              context,
                                                                              state,
                                                                            ) {
                                                                              if (state
                                                                                  is CommissioningStep5AutoFillSuccessState) {
                                                                                final data = state.data.data;
                                                                                _mechNA = data.isMechanicalChecklistNa;
                                                                                _pipeNA = data.isPipelineChecklistNa;
                                                                                _elecNA = data.isElectricalChecklistNa;
                                                                                _bearingNoise = null;
                                                                                _vibration = null;
                                                                                _mechSeal = null;
                                                                                _pumpDry = null;
                                                                                _nrvValve = null;
                                                                                _strainerValve = null;
                                                                                _suctionLine = null;
                                                                                _deliveryLine = null;
                                                                                _suctionDelivery = null;
                                                                                _pressureSwitch = null;
                                                                                _elecFaults = null;
                                                                                _voltage = null;
                                                                                _phase = null;
                                                                                _current = null;
                                                                                _panelWiring = null;
                                                                                for (var check in data.savedChecklists) {
                                                                                  final key = check.keyChecklist;
                                                                                  final val = check.valueChecklist;
                                                                                  _step5ExistingPhotos[key] = check.photo;
                                                                                  _step5ExistingVideos[key] = check.video;
                                                                                  if (key ==
                                                                                      "Bearing noise")
                                                                                    _bearingNoise = val;
                                                                                  else if (key ==
                                                                                      "Vibration")
                                                                                    _vibration = val;
                                                                                  else if (key ==
                                                                                      "Mechanical seal")
                                                                                    _mechSeal = val;
                                                                                  else if (key ==
                                                                                      "Pump not running dry")
                                                                                    _pumpDry = val;
                                                                                  else if (key ==
                                                                                      "NRV")
                                                                                    _nrvValve = val;
                                                                                  else if (key ==
                                                                                      "Strainer")
                                                                                    _strainerValve = val;
                                                                                  else if (key ==
                                                                                      "Suction line")
                                                                                    _suctionLine = val;
                                                                                  else if (key ==
                                                                                      "Delivery line")
                                                                                    _deliveryLine = val;
                                                                                  else if (key ==
                                                                                      "Suction / Delivery Valve")
                                                                                    _suctionDelivery = val;
                                                                                  else if (key ==
                                                                                      "Pressure switch")
                                                                                    _pressureSwitch = val;
                                                                                  else if (key ==
                                                                                      "Electrical Faults")
                                                                                    _elecFaults = val;
                                                                                  else if (key ==
                                                                                      "Voltage Check")
                                                                                    _voltage = val;
                                                                                  else if (key ==
                                                                                      "Phase Check")
                                                                                    _phase = val;
                                                                                  else if (key ==
                                                                                      "Current Check")
                                                                                    _current = val;
                                                                                  else if (key ==
                                                                                      "Control Panel Wiring")
                                                                                    _panelWiring = val;
                                                                                }
                                                                                setState(
                                                                                  () {},
                                                                                );
                                                                              }
                                                                            },
                                                                        child:
                                                                            BlocListener<
                                                                              ServiceCallReportStep5AutoFillBloc,
                                                                              ServiceCallReportStep5AutoFillState
                                                                            >(
                                                                              bloc: _serviceCallStep5AutoFillBloc,
                                                                              listener:
                                                                                  (
                                                                                    context,
                                                                                    state,
                                                                                  ) {
                                                                                    if (state
                                                                                        is ServiceCallReportStep5AutoFillSuccessState) {
                                                                                      final data = state.data.data;
                                                                                      _mechNA = data.isMechanicalChecklistNa;
                                                                                      _pipeNA = data.isPipelineChecklistNa;
                                                                                      _elecNA = data.isElectricalChecklistNa;
                                                                                      _bearingNoise = null;
                                                                                      _vibration = null;
                                                                                      _mechSeal = null;
                                                                                      _pumpDry = null;
                                                                                      _nrvValve = null;
                                                                                      _strainerValve = null;
                                                                                      _suctionLine = null;
                                                                                      _deliveryLine = null;
                                                                                      _suctionDelivery = null;
                                                                                      _pressureSwitch = null;
                                                                                      _elecFaults = null;
                                                                                      _voltage = null;
                                                                                      _phase = null;
                                                                                      _current = null;
                                                                                      _panelWiring = null;
                                                                                      for (var check in data.savedChecklists) {
                                                                                        final key = check.keyChecklist;
                                                                                        final val = check.valueChecklist;
                                                                                        _step5ExistingPhotos[key] = check.photo;
                                                                                        _step5ExistingVideos[key] = check.video;
                                                                                        if (key ==
                                                                                            "Bearing noise")
                                                                                          _bearingNoise = val;
                                                                                        else if (key ==
                                                                                            "Vibration")
                                                                                          _vibration = val;
                                                                                        else if (key ==
                                                                                            "Mechanical seal")
                                                                                          _mechSeal = val;
                                                                                        else if (key ==
                                                                                            "Pump not running dry")
                                                                                          _pumpDry = val;
                                                                                        else if (key ==
                                                                                            "NRV")
                                                                                          _nrvValve = val;
                                                                                        else if (key ==
                                                                                            "Strainer")
                                                                                          _strainerValve = val;
                                                                                        else if (key ==
                                                                                            "Suction line")
                                                                                          _suctionLine = val;
                                                                                        else if (key ==
                                                                                            "Delivery line")
                                                                                          _deliveryLine = val;
                                                                                        else if (key ==
                                                                                            "Suction / Delivery Valve")
                                                                                          _suctionDelivery = val;
                                                                                        else if (key ==
                                                                                            "Pressure switch")
                                                                                          _pressureSwitch = val;
                                                                                        else if (key ==
                                                                                            "Electrical Faults")
                                                                                          _elecFaults = val;
                                                                                        else if (key ==
                                                                                            "Voltage Check")
                                                                                          _voltage = val;
                                                                                        else if (key ==
                                                                                            "Phase Check")
                                                                                          _phase = val;
                                                                                        else if (key ==
                                                                                            "Current Check")
                                                                                          _current = val;
                                                                                        else if (key ==
                                                                                            "Control Panel Wiring")
                                                                                          _panelWiring = val;
                                                                                      }
                                                                                      setState(
                                                                                        () {},
                                                                                      );
                                                                                    }
                                                                                  },
                                                                              child:
                                                                                  BlocListener<
                                                                                    ServiceCallReportStep6Bloc,
                                                                                    ServiceCallReportStep6State
                                                                                  >(
                                                                                    bloc: _submitServiceCallStep6Bloc,
                                                                                    listener:
                                                                                        (
                                                                                          context,
                                                                                          state,
                                                                                        ) {
                                                                                          if (state
                                                                                              is ServiceCallReportStep6SuccessState) {
                                                                                            appSnackBar(
                                                                                              context,
                                                                                              const Color(
                                                                                                0xFF4CAF50,
                                                                                              ),
                                                                                              state.data.message,
                                                                                            );
                                                                                            // If ServiceCallStep6Response is ever updated to include data, it would be passed here
                                                                                            _showSuccessDialog(
                                                                                              qrCodeImage: state.data.data.qrCodeImage,
                                                                                            );
                                                                                          } else if (state
                                                                                              is ServiceCallReportStep6FailureState) {
                                                                                            appSnackBar(
                                                                                              context,
                                                                                              const Color(
                                                                                                0xFFF44336,
                                                                                              ),
                                                                                              state.message,
                                                                                            );
                                                                                          }
                                                                                        },
                                                                                    child:
                                                                                        BlocListener<
                                                                                          CommissioningStep6Bloc,
                                                                                          CommissioningStep6State
                                                                                        >(
                                                                                          bloc: _submitStep6Bloc,
                                                                                          listener:
                                                                                              (
                                                                                                context,
                                                                                                state,
                                                                                              ) {
                                                                                                if (state
                                                                                                    is CommissioningStep6SuccessState) {
                                                                                                  appSnackBar(
                                                                                                    context,
                                                                                                    const Color(
                                                                                                      0xFF4CAF50,
                                                                                                    ),
                                                                                                    state.data.message,
                                                                                                  );
                                                                                                  _showSuccessDialog(
                                                                                                    qrCodeImage: state.data.data.qrCodeImage,
                                                                                                  );
                                                                                                } else if (state
                                                                                                    is CommissioningStep6FailureState) {
                                                                                                  appSnackBar(
                                                                                                    context,
                                                                                                    const Color(
                                                                                                      0xFFF44336,
                                                                                                    ),
                                                                                                    state.message,
                                                                                                  );
                                                                                                }
                                                                                              },
                                                                                          child: Scaffold(
                                                                                            backgroundColor: Colors.white,
                                                                                            body: SafeArea(
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.fromLTRB(
                                                                                                      20,
                                                                                                      20,
                                                                                                      20,
                                                                                                      10,
                                                                                                    ),
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              width: 44,
                                                                                                              height: 44,
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: Colors.white,
                                                                                                                borderRadius: BorderRadius.circular(
                                                                                                                  12,
                                                                                                                ),
                                                                                                                border: Border.all(
                                                                                                                  color: const Color(
                                                                                                                    0xFFE5E7EB,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                boxShadow: [
                                                                                                                  BoxShadow(
                                                                                                                    color: Colors.black.withOpacity(
                                                                                                                      0.04,
                                                                                                                    ),
                                                                                                                    blurRadius: 8,
                                                                                                                    offset: const Offset(
                                                                                                                      0,
                                                                                                                      2,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                              child: IconButton(
                                                                                                                icon: const Icon(
                                                                                                                  Icons.arrow_back,
                                                                                                                  size: 20,
                                                                                                                  color: Color(
                                                                                                                    0xFF5C616E,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                onPressed: widget.onBack,
                                                                                                              ),
                                                                                                            ),
                                                                                                            const SizedBox(
                                                                                                              width: 16,
                                                                                                            ),
                                                                                                            Container(
                                                                                                              width: 4,
                                                                                                              height: 24,
                                                                                                              decoration: BoxDecoration(
                                                                                                                color: const Color(
                                                                                                                  0xFF0B68B9,
                                                                                                                ),
                                                                                                                borderRadius: BorderRadius.circular(
                                                                                                                  2,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            const SizedBox(
                                                                                                              width: 12,
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: Text(
                                                                                                                widget.isServiceReport
                                                                                                                    ? 'service_report'.tr()
                                                                                                                    : 'commissioning_report'.tr(),
                                                                                                                style: AppFont.style(
                                                                                                                  fontSize: 17,
                                                                                                                  fontWeight: FontWeight.w900,
                                                                                                                  color: const Color(
                                                                                                                    0xFF0D121F,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        const SizedBox(
                                                                                                          height: 20,
                                                                                                        ),
                                                                                                        // Progress Bar
                                                                                                        Row(
                                                                                                          children: List.generate(
                                                                                                            6,
                                                                                                            (
                                                                                                              index,
                                                                                                            ) {
                                                                                                              bool isActive =
                                                                                                                  index <
                                                                                                                  _currentStep;
                                                                                                              return Expanded(
                                                                                                                child: Container(
                                                                                                                  height: 4,
                                                                                                                  margin: EdgeInsets.only(
                                                                                                                    right:
                                                                                                                        index ==
                                                                                                                            5
                                                                                                                        ? 0
                                                                                                                        : 8,
                                                                                                                  ),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: isActive
                                                                                                                        ? const Color(
                                                                                                                            0xFF1565C0,
                                                                                                                          )
                                                                                                                        : const Color(
                                                                                                                            0xFFF1F2F6,
                                                                                                                          ),
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      2,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              );
                                                                                                            },
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  const Divider(
                                                                                                    height: 1,
                                                                                                    thickness: 1,
                                                                                                    color: Color(
                                                                                                      0xFFF1F2F6,
                                                                                                    ),
                                                                                                  ),
                                                                                                  // â”€â”€ Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                                                                                                  Expanded(
                                                                                                    child: SingleChildScrollView(
                                                                                                      padding: const EdgeInsets.symmetric(
                                                                                                        horizontal: 20,
                                                                                                        vertical: 10,
                                                                                                      ),
                                                                                                      child: _buildBodyContent(),
                                                                                                    ),
                                                                                                  ),
                                                                                                  // â”€â”€ Footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                                                                                                  Container(
                                                                                                    padding: const EdgeInsets.symmetric(
                                                                                                      horizontal: 20,
                                                                                                      vertical: 24,
                                                                                                    ),
                                                                                                    decoration: const BoxDecoration(
                                                                                                      color: Colors.white,
                                                                                                      border: Border(
                                                                                                        top: BorderSide(
                                                                                                          color: Color(
                                                                                                            0xFFF1F2F6,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        if (_currentStep >
                                                                                                            1)
                                                                                                          GestureDetector(
                                                                                                            onTap: _previousStep,
                                                                                                            child: Row(
                                                                                                              children: [
                                                                                                                const Icon(
                                                                                                                  Icons.arrow_back,
                                                                                                                  size: 18,
                                                                                                                  color: Color(
                                                                                                                    0xFFA5ABB7,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                const SizedBox(
                                                                                                                  width: 8,
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  'create_report_btn_back'.tr(),
                                                                                                                  style: AppFont.style(
                                                                                                                    fontSize: 14,
                                                                                                                    fontWeight: FontWeight.w800,
                                                                                                                    color: const Color(
                                                                                                                      0xFFA5ABB7,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          )
                                                                                                        else
                                                                                                          TextButton(
                                                                                                            onPressed: widget.onBack,
                                                                                                            child: Text(
                                                                                                              'cancel'.tr(),
                                                                                                              style: AppFont.style(
                                                                                                                fontSize: 14,
                                                                                                                fontWeight: FontWeight.w800,
                                                                                                                color: const Color(
                                                                                                                  0xFFA5ABB7,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        const Spacer(),
                                                                                                        GestureDetector(
                                                                                                          onTap: _nextStep,
                                                                                                          child:
                                                                                                              BlocBuilder<
                                                                                                                ServiceCallReportStep1Bloc,
                                                                                                                ServiceCallReportStep1State
                                                                                                              >(
                                                                                                                bloc: _submitServiceCallStep1Bloc,
                                                                                                                builder:
                                                                                                                    (
                                                                                                                      context,
                                                                                                                      serviceCallStep1State,
                                                                                                                    ) {
                                                                                                                      return BlocBuilder<
                                                                                                                        ServiceCallReportStep2Bloc,
                                                                                                                        ServiceCallReportStep2State
                                                                                                                      >(
                                                                                                                        bloc: _submitServiceCallStep2Bloc,
                                                                                                                        builder:
                                                                                                                            (
                                                                                                                              context,
                                                                                                                              serviceCallStep2State,
                                                                                                                            ) {
                                                                                                                              return BlocBuilder<
                                                                                                                                  ServiceCallReportStep3Bloc,
                                                                                                                                  ServiceCallReportStep3State
                                                                                                                              >(
                                                                                                                                  bloc: _submitServiceCallStep3Bloc,
                                                                                                                                  builder:
                                                                                                                                      (
                                                                                                                                      context,
                                                                                                                                      serviceCallStep3State,) {
                                                                                                                                    return BlocBuilder<
                                                                                                                                        ServiceCallReportStep4Bloc,
                                                                                                                                        ServiceCallReportStep4State
                                                                                                                                    >(
                                                                                                                                        bloc: _submitServiceCallStep4Bloc,
                                                                                                                                        builder:
                                                                                                                                            (
                                                                                                                                            context,
                                                                                                                                            serviceCallStep4State,) {
                                                                                                                                          return BlocBuilder<
                                                                                                                                              ServiceCallReportStep5Bloc,
                                                                                                                                              ServiceCallReportStep5State
                                                                                                                                          >(
                                                                                                                                            bloc: _submitServiceCallStep5Bloc,
                                                                                                                                            builder:
                                                                                                                                                (
                                                                                                                                                context,
                                                                                                                                                serviceCallStep5State,) {
                                                                                                                                              return BlocBuilder<
                                                                                                                                                  CommissioningStep2Bloc,
                                                                                                                                                  CommissioningStep2State
                                                                                                                                              >(
                                                                                                                                                bloc: _submitStep2Bloc,
                                                                                                                                                builder:
                                                                                                                                                    (
                                                                                                                                                    context,
                                                                                                                                                    submitStep2State,) {
                                                                                                                                                  return BlocBuilder<
                                                                                                                                                      CommissioningStep1Bloc,
                                                                                                                                                      CommissioningStep1State
                                                                                                                                                  >(
                                                                                                                                                    bloc: _submitStep1Bloc,
                                                                                                                                                    builder:
                                                                                                                                                        (
                                                                                                                                                        context,
                                                                                                                                                        submitState,) {
                                                                                                                                                      return BlocBuilder<
                                                                                                                                                          CommissioningStep3Bloc,
                                                                                                                                                          CommissioningStep3State
                                                                                                                                                      >(
                                                                                                                                                        bloc: _submitStep3Bloc,
                                                                                                                                                        builder:
                                                                                                                                                            (
                                                                                                                                                            context,
                                                                                                                                                            submitStep3State,) {
                                                                                                                                                          return BlocBuilder<
                                                                                                                                                              CommissioningStep4Bloc,
                                                                                                                                                              CommissioningStep4State
                                                                                                                                                          >(
                                                                                                                                                            bloc: _submitStep4Bloc,
                                                                                                                                                            builder:
                                                                                                                                                                (
                                                                                                                                                                context,
                                                                                                                                                                submitStep4State,) {
                                                                                                                                                              return BlocBuilder<
                                                                                                                                                                  CommissioningStep5Bloc,
                                                                                                                                                                  CommissioningStep5State
                                                                                                                                                              >(
                                                                                                                                                                bloc: _submitStep5Bloc,
                                                                                                                                                                builder:
                                                                                                                                                                    (
                                                                                                                                                                    context,
                                                                                                                                                                    submitStep5State,) {
                                                                                                                                                                  return BlocBuilder<
                                                                                                                                                                      CommissioningStep6Bloc,
                                                                                                                                                                      CommissioningStep6State
                                                                                                                                                                  >(
                                                                                                                                                                    bloc: _submitStep6Bloc,
                                                                                                                                                                    builder:
                                                                                                                                                                        (
                                                                                                                                                                        context,
                                                                                                                                                                        submitStep6State,) {
                                                                                                                                                                       return BlocBuilder<
                                                                                                                                                                           ServiceCallReportStep6Bloc,
                                                                                                                                                                           ServiceCallReportStep6State
                                                                                                                                                                       >(
                                                                                                                                                                         bloc: _submitServiceCallStep6Bloc,
                                                                                                                                                                         builder:
                                                                                                                                                                             (
                                                                                                                                                                             context,
                                                                                                                                                                             serviceCallStep6State,) {
                                                                                                                                                                           return BlocBuilder<
                                                                                                                                                                               ServiceCallReportStep6AutoFillBloc,
                                                                                                                                                                               ServiceCallReportStep6AutoFillState
                                                                                                                                                                           >(
                                                                                                                                                                             bloc: _serviceCallStep6AutoFillBloc,
                                                                                                                                                                             builder:
                                                                                                                                                                                 (
                                                                                                                                                                                 context,
                                                                                                                                                                                 serviceCallStep6AutoFillState,) {
                                                                                                                                                                          bool isSubmitting =
                                                                                                                                                                              (_currentStep ==
                                                                                                                                                                                  1 &&
                                                                                                                                                                                  submitState
                                                                                                                                                                                  is CommissioningStep1LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      1 &&
                                                                                                                                                                                      serviceCallStep1State
                                                                                                                                                                                      is ServiceCallReportStep1LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      2 &&
                                                                                                                                                                                      submitStep2State
                                                                                                                                                                                      is CommissioningStep2LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      2 &&
                                                                                                                                                                                      serviceCallStep2State
                                                                                                                                                                                      is ServiceCallReportStep2LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      3 &&
                                                                                                                                                                                      submitStep3State
                                                                                                                                                                                      is CommissioningStep3LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      3 &&
                                                                                                                                                                                      serviceCallStep3State
                                                                                                                                                                                      is ServiceCallReportStep3LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      4 &&
                                                                                                                                                                                      submitStep4State
                                                                                                                                                                                      is CommissioningStep4LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      4 &&
                                                                                                                                                                                      serviceCallStep4State
                                                                                                                                                                                      is ServiceCallReportStep4LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      5 &&
                                                                                                                                                                                      submitStep5State
                                                                                                                                                                                      is CommissioningStep5LoadingState) ||
                                                                                                                                                                                  (_currentStep ==
                                                                                                                                                                                      5 &&
                                                                                                                                                                                      serviceCallStep5State
                                                                                                                                                                                      is ServiceCallReportStep5LoadingState) ||
                                                                                                                                                                                   (_currentStep ==
                                                                                                                                                                                       6 &&
                                                                                                                                                                                       submitStep6State
                                                                                                                                                                                       is CommissioningStep6LoadingState) ||
                                                                                                                                                                                   (_currentStep ==
                                                                                                                                                                                       6 &&
                                                                                                                                                                                       serviceCallStep6State
                                                                                                                                                                                       is ServiceCallReportStep6LoadingState) ||
                                                                                                                                                                                   (_currentStep ==
                                                                                                                                                                                       6 &&
                                                                                                                                                                                       serviceCallStep6AutoFillState
                                                                                                                                                                                       is ServiceCallReportStep6AutoFillLoadingState);
                                                                                                                                                                          return Container(
                                                                                                                                                                            height: 44,
                                                                                                                                                                            padding: const EdgeInsets
                                                                                                                                                                                .symmetric(
                                                                                                                                                                              horizontal: 32,
                                                                                                                                                                            ),
                                                                                                                                                                            decoration: BoxDecoration(
                                                                                                                                                                              color: const Color(
                                                                                                                                                                                0xFF1565C0,
                                                                                                                                                                              ),
                                                                                                                                                                              borderRadius: BorderRadius
                                                                                                                                                                                  .circular(
                                                                                                                                                                                10,
                                                                                                                                                                              ),
                                                                                                                                                                              boxShadow: [
                                                                                                                                                                                BoxShadow(
                                                                                                                                                                                  color:
                                                                                                                                                                                  const Color(
                                                                                                                                                                                    0xFF1565C0,
                                                                                                                                                                                  )
                                                                                                                                                                                      .withValues(
                                                                                                                                                                                    alpha: 0.2,
                                                                                                                                                                                  ),
                                                                                                                                                                                  blurRadius: 15,
                                                                                                                                                                                  offset: const Offset(
                                                                                                                                                                                    0,
                                                                                                                                                                                    8,
                                                                                                                                                                                  ),
                                                                                                                                                                                ),
                                                                                                                                                                              ],
                                                                                                                                                                            ),
                                                                                                                                                                            child: Row(
                                                                                                                                                                              mainAxisSize: MainAxisSize
                                                                                                                                                                                  .min,
                                                                                                                                                                              children: [
                                                                                                                                                                                if (_currentStep ==
                                                                                                                                                                                    6 &&
                                                                                                                                                                                    !isSubmitting)
                                                                                                                                                                                  const Icon(
                                                                                                                                                                                    Icons
                                                                                                                                                                                        .check_box_outlined,
                                                                                                                                                                                    size: 20,
                                                                                                                                                                                    color: Colors
                                                                                                                                                                                        .white,
                                                                                                                                                                                  )
                                                                                                                                                                                else
                                                                                                                                                                                  const SizedBox
                                                                                                                                                                                      .shrink(),
                                                                                                                                                                                if (_currentStep ==
                                                                                                                                                                                    6 &&
                                                                                                                                                                                    !isSubmitting)
                                                                                                                                                                                  const SizedBox(
                                                                                                                                                                                    width: 12,
                                                                                                                                                                                  )
                                                                                                                                                                                else
                                                                                                                                                                                  const SizedBox
                                                                                                                                                                                      .shrink(),
                                                                                                                                                                                if (isSubmitting)
                                                                                                                                                                                  const SizedBox(
                                                                                                                                                                                    width: 20,
                                                                                                                                                                                    height: 20,
                                                                                                                                                                                    child: CircularProgressIndicator(
                                                                                                                                                                                      color: Colors
                                                                                                                                                                                          .white,
                                                                                                                                                                                      strokeWidth: 2.5,
                                                                                                                                                                                    ),
                                                                                                                                                                                  )
                                                                                                                                                                                else
                                                                                                                                                                                  Text(
                                                                                                                                                                                    _currentStep ==
                                                                                                                                                                                        6
                                                                                                                                                                                        ? (widget.isServiceReport
                                                                                                                                                                                            ? 'service_calls_btn_submit'
                                                                                                                                                                                                .tr()
                                                                                                                                                                                            : 'commissioning_submit_report'
                                                                                                                                                                                                .tr())
                                                                                                                                                                                        : 'create_report_btn_next'
                                                                                                                                                                                        .tr(),
                                                                                                                                                                                    style: AppFont
                                                                                                                                                                                        .style(
                                                                                                                                                                                      fontSize: 12,
                                                                                                                                                                                      fontWeight: FontWeight
                                                                                                                                                                                          .w800,
                                                                                                                                                                                      color: Colors
                                                                                                                                                                                          .white,
                                                                                                                                                                                    ),
                                                                                                                                                                                  ),
                                                                                                                                                                                if (_currentStep <
                                                                                                                                                                                    6 &&
                                                                                                                                                                                    !isSubmitting) ...[
                                                                                                                                                                                  const SizedBox(
                                                                                                                                                                                    width: 12,
                                                                                                                                                                                  ),
                                                                                                                                                                                  const Icon(
                                                                                                                                                                                    Icons
                                                                                                                                                                                        .arrow_forward,
                                                                                                                                                                                    size: 18,
                                                                                                                                                                                    color: Colors
                                                                                                                                                                                        .white,
                                                                                                                                                                                  ),
                                                                                                                                                                                ],
                                                                                                                                                                              ],
                                                                                                                                                                            ),
                                                                                                                                                                          );
                                                                                                                                                                        },
                                                                                                                                                                      );
                                                                                                                                                                         },
                                                                                                                                                                       );
                                                                                                                                                                    },
                                                                                                                                                                  );
                                                                                                                                                                },
                                                                                                                                                              );
                                                                                                                                                            },
                                                                                                                                                          );
                                                                                                                                                        },
                                                                                                                                                      );
                                                                                                                                                    },
                                                                                                                                                  );
                                                                                                                                                },
                                                                                                                                              ); // BlocBuilder 2
                                                                                                                                            },
                                                                                                                                          ); // BlocBuilder 1
                                                                                                                                        });
                                                                                                                                  }); // GestureDetector
                                                                                                                            });}))], // Row children
                                                                                                    ), // Row
                                                                                                  ), // Container
                                                                                                ], // Column children
                                                                                              ), // Column
                                                                                            ), // SafeArea
                                                                                          ), // Scaffold
                                                                                        ), // Service Call Step 6 Submit
                                                                                  ), // Step 6 Submit
                                                                            ), // Service Call Step 5 AutoFill
                                                                      ), // Step 5 AutoFill
                                                                ), // Step 5 Submit
                                                          ), // Service Call Step 5 Listener
                                                    ), // Step 4 AutoFill
                                              ), // Service Call Step 4 AutoFill
                                        ), // Step 4 Submit
                                  ), // Service Call Step 4 Submit
                            ), // Step 3 AutoFill
                      ), // Service Call Step 3 AutoFill
                ), // Step 3 Submit
              ), // Service Call Step 1 Listener
            ), // Service Call Step 3 Listener
          ), // Step 1 Submit
        ), // Step 2 Submit
      ), // Step 2 Service Call Submit
    ); // Service Call Step 6 AutoFill Submit
  }

  Widget _buildBodyContent() {
    switch (_currentStep) {
      case 1:
        if (widget.isServiceReport) {
          return BlocConsumer<
            ServiceCallReportStep1AutoFillBloc,
            ServiceCallReportStep1AutoFillState
          >(
            bloc: _serviceCallStep1AutoFillBloc,
            listener: (context, state) {
              if (state is ServiceCallReportStep1AutoFillSuccessState) {
                _commissioningReportId = state.data.data.id;
                setState(() {
                  if (state.data.data.assignedTechnicians.isNotEmpty) {
                    _technicians.clear();
                    _technicianIds.clear();
                    for (var t in state.data.data.assignedTechnicians) {
                      _technicians.add(TextEditingController(text: t.name));
                      _technicianIds.add(t.id);
                    }
                  }

                  // Navigate to the correct step using step_no passed from the list.
                  // Only do this once (on first load), not when going back to step 1.
                  if (!_hasAppliedInitialStep) {
                    _hasAppliedInitialStep = true;
                    final targetStep = widget.initialStepNo > 0 && widget.initialStepNo <= 6
                        ? widget.initialStepNo
                        : 1;
                    if (targetStep > 1 && _currentStep == 1) {
                      _currentStep = targetStep;

                      if (_commissioningReportId != null) {
                        if (_currentStep == 2) {
                          _serviceCallStep2AutoFillBloc.add(
                            ServiceCallReportStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 3) {
                          _serviceCallStep3AutoFillBloc.add(
                            ServiceCallReportStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 4) {
                          _serviceCallStep4AutoFillBloc.add(
                            ServiceCallReportStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 5) {
                          _serviceCallStep5AutoFillBloc.add(
                            ServiceCallReportStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 6) {
                          _serviceCallStep6AutoFillBloc.add(
                            ServiceCallReportStep6AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                          _assignedServiceCallTechnicianBloc.add(
                            AssignedServicecallTechnicianGetEvent(_commissioningReportId!),
                          );
                        }
                      }
                    }
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is ServiceCallReportStep1AutoFillLoadingState ||
                  state is ServiceCallReportStep1AutoFillInitialState) {
                return const StepShimmer(step: 1);
              }
              // Since _buildStep1 expects CommissioningWorkData, and ServiceCallData has different fields,
              // we might need to handle this. But wait, _buildStep1 takes 'data' as dynamic or specific type?
              // Let's pass the data as it is.
              final data = state is ServiceCallReportStep1AutoFillSuccessState
                  ? state.data.data
                  : null;
              return Step1Widget(parent: this, data: data);
            },
          );
        } else {
          return BlocConsumer<
            CommissioningStep1AutoFillBloc,
            CommissioningStep1AutoFillState
          >(
            bloc: _step1Bloc,
            listener: (context, state) {
              if (state is CommissioningStep1AutoFillSuccessState) {
                _commissioningReportId = state.data.data.id;
                setState(() {
                  if (state.data.data.assignedTechnicians.isNotEmpty) {
                    _technicians.clear();
                    _technicianIds.clear();
                    for (var t in state.data.data.assignedTechnicians) {
                      _technicians.add(TextEditingController(text: t.name));
                      _technicianIds.add(t.id);
                    }
                  }

                  // Navigate to the correct step using step_no passed from the list.
                  // Only do this once (on first load), not when going back to step 1.
                  if (!_hasAppliedInitialStep) {
                    _hasAppliedInitialStep = true;
                    final targetStep = widget.initialStepNo > 0 && widget.initialStepNo <= 6
                        ? widget.initialStepNo
                        : 1;
                    if (targetStep > 1 && _currentStep == 1) {
                      _currentStep = targetStep;

                      if (_commissioningReportId != null) {
                        if (_currentStep == 2) {
                          _step2Bloc.add(
                            CommissioningStep2AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 3) {
                          _step3Bloc.add(
                            CommissioningStep3AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 4) {
                          _step4Bloc.add(
                            CommissioningStep4AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 5) {
                          _step5Bloc.add(
                            CommissioningStep5AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                        } else if (_currentStep == 6) {
                          _step6Bloc.add(
                            CommissioningStep6AutoFillGetEvent(_commissioningReportId ?? widget.commissioningWorkId),
                          );
                          _assignedTechniciansBloc.add(
                            AssignedTechnicianRepresentativeGetEvent(_commissioningReportId!),
                          );
                        }
                      }
                    }
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is CommissioningStep1AutoFillLoadingState ||
                  state is CommissioningStep1AutoFillInitialState) {
                return const StepShimmer(step: 1);
              }
              final data = state is CommissioningStep1AutoFillSuccessState
                  ? state.data.data
                  : null;
              return Step1Widget(parent: this, data: data);
            },
          );
        }
      case 2:
        if (widget.isServiceReport) {
          return BlocConsumer<
            ServiceCallReportStep2AutoFillBloc,
            ServiceCallReportStep2AutoFillState
          >(
            bloc: _serviceCallStep2AutoFillBloc,
            listener: (context, state) {
              if (state is ServiceCallReportStep2AutoFillSuccessState) {
                setState(() {
                  if (state.data.data.memberPresentsCustomerSide.isNotEmpty) {
                    _representatives.clear();
                    // Let's assume it's a comma separated string or single string
                    _representatives.add(
                      TextEditingController(
                        text: state.data.data.memberPresentsCustomerSide,
                      ),
                    );
                  }
                  if (state.data.data.agenda.isNotEmpty) {
                    _agendaController.text = state.data.data.agenda;
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is ServiceCallReportStep2AutoFillLoadingState ||
                  state is ServiceCallReportStep2AutoFillInitialState) {
                return const StepShimmer(step: 2);
              }
              return Step2Widget(parent: this);
            },
          );
        } else {
          return BlocConsumer<
            CommissioningStep2AutoFillBloc,
            CommissioningStep2AutoFillState
          >(
            bloc: _step2Bloc,
            listener: (context, state) {
              if (state is CommissioningStep2AutoFillSuccessState) {
                setState(() {
                  if (state.data.data.memberPresentsCustomerSide.isNotEmpty) {
                    _representatives.clear();
                    _representatives.addAll(
                      state.data.data.memberPresentsCustomerSide.map(
                        (t) => TextEditingController(text: t),
                      ),
                    );
                  }
                  if (state.data.data.warrantyPeriodYears > 0) {
                    _selectedWarranty =
                        '${state.data.data.warrantyPeriodYears}_year';
                  }
                  if (state.data.data.agenda.isNotEmpty) {
                    _agendaController.text = state.data.data.agenda;
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is CommissioningStep2AutoFillLoadingState ||
                  state is CommissioningStep2AutoFillInitialState) {
                return const StepShimmer(step: 2);
              }
              return Step2Widget(parent: this);
            },
          );
        }
      case 3:
        if (widget.isServiceReport) {
          return BlocBuilder<
            ServiceCallReportStep3AutoFillBloc,
            ServiceCallReportStep3AutoFillState
          >(
            bloc: _serviceCallStep3AutoFillBloc,
            builder: (context, state) {
              if (state is ServiceCallReportStep3AutoFillLoadingState ||
                  state is ServiceCallReportStep3AutoFillInitialState) {
                return const StepShimmer(step: 3);
              }
              return Step3Widget(parent: this);
            },
          );
        } else {
          return BlocBuilder<
            CommissioningStep3AutoFillBloc,
            CommissioningStep3AutoFillState
          >(
            bloc: _step3Bloc,
            builder: (context, state) {
              if (state is CommissioningStep3AutoFillLoadingState ||
                  state is CommissioningStep3AutoFillInitialState) {
                return const StepShimmer(step: 3);
              }
              return Step3Widget(parent: this);
            },
          );
        }
      case 4:
        if (widget.isServiceReport) {
          return BlocBuilder<
            ServiceCallReportStep4AutoFillBloc,
            ServiceCallReportStep4AutoFillState
          >(
            bloc: _serviceCallStep4AutoFillBloc,
            builder: (context, state) {
              if (state is ServiceCallReportStep4AutoFillLoadingState ||
                  state is ServiceCallReportStep4AutoFillInitialState) {
                return const StepShimmer(step: 4);
              }
              return Step4Widget(parent: this);
            },
          );
        } else {
          return BlocBuilder<
            CommissioningStep4AutoFillBloc,
            CommissioningStep4AutoFillState
          >(
            bloc: _step4Bloc,
            builder: (context, state) {
              if (state is CommissioningStep4AutoFillLoadingState ||
                  state is CommissioningStep4AutoFillInitialState) {
                return const StepShimmer(step: 4);
              }
              return Step4Widget(parent: this);
            },
          );
        }
      case 5:
        if (widget.isServiceReport) {
          return BlocBuilder<
            ServiceCallReportStep5AutoFillBloc,
            ServiceCallReportStep5AutoFillState
          >(
            bloc: _serviceCallStep5AutoFillBloc,
            builder: (context, state) {
              if (state is ServiceCallReportStep5AutoFillLoadingState ||
                  state is ServiceCallReportStep5AutoFillInitialState) {
                return const StepShimmer(step: 5);
              }
              return Step5Widget(parent: this);
            },
          );
        } else {
          return BlocBuilder<
            CommissioningStep5AutoFillBloc,
            CommissioningStep5AutoFillState
          >(
            bloc: _step5Bloc,
            builder: (context, state) {
              if (state is CommissioningStep5AutoFillLoadingState ||
                  state is CommissioningStep5AutoFillInitialState) {
                return const StepShimmer(step: 5);
              }
              return Step5Widget(parent: this);
            },
          );
        }
      case 6:
        if (widget.isServiceReport) {
          return BlocConsumer<
            AssignedServicecallTechnicianBloc,
            AssignedServicecallTechnicianState
          >(
            bloc: _assignedServiceCallTechnicianBloc,
            listener: (context, techState) {
              if (techState is AssignedServicecallTechnicianSuccessState) {
                setState(() {
                  _assignedServiceCallTechniciansList = techState.data.data;
                  print(
                    "ðŸ‘¤ Service Call Assigned technicians loaded: ${_assignedServiceCallTechniciansList.map((t) => '${t.name} (assignId: ${t.assignId}, technicianId: ${t.technicianId})').toList()}",
                  );
                  if (_assignedServiceCallTechniciansList.isNotEmpty) {
                    final matchedSession = _loggedInTechnicianId != null ? _assignedServiceCallTechniciansList.where((t) => t.technicianId == _loggedInTechnicianId).firstOrNull : null;
                    if (matchedSession != null) {
                      _selectedTechnicianRepId = matchedSession.assignId;
                    } else if (_autofilledTechRepName != null) {
                      final matched = _assignedServiceCallTechniciansList
                          .firstWhere(
                            (t) =>
                                t.name.toLowerCase() ==
                                _autofilledTechRepName!.toLowerCase(),
                            orElse: () =>
                                _assignedServiceCallTechniciansList.first,
                          );
                      _selectedTechnicianRepId = matched.assignId;
                    }
                  }
                });
              }
            },
            builder: (context, techState) {
              // Service report step 6 autofill is not fully implemented yet, but we handle the loading
              if (techState is AssignedServicecallTechnicianLoadingState) {
                return const StepShimmer(step: 6);
              }
              return Step6Widget(parent: this);
            },
          );
        } else {
          return BlocConsumer<
            AssignedTechnicianRepresentativeBloc,
            AssignedTechnicianRepresentativeState
          >(
            bloc: _assignedTechniciansBloc,
            listener: (context, techState) {
              if (techState is AssignedTechnicianRepresentativeSuccessState) {
                setState(() {
                  _assignedTechniciansList = techState.data.data;
                  print(
                    "ðŸ‘¤ Assigned technicians loaded: ${_assignedTechniciansList.map((t) => '${t.name} (assignId: ${t.assignId}, technicianId: ${t.technicianId})').toList()}",
                  );
                  if (_assignedTechniciansList.isNotEmpty) {
                    final matchedSession = _loggedInTechnicianId != null ? _assignedTechniciansList.where((t) => t.technicianId == _loggedInTechnicianId).firstOrNull : null;
                    if (matchedSession != null) {
                      _selectedTechnicianRepId = matchedSession.assignId;
                    } else if (_autofilledTechRepName != null) {
                      final matched = _assignedTechniciansList.firstWhere(
                        (t) =>
                            t.name.toLowerCase() ==
                            _autofilledTechRepName!.toLowerCase(),
                        orElse: () => _assignedTechniciansList.first,
                      );
                      _selectedTechnicianRepId = matched.assignId;
                      print(
                        "ðŸŽ¯ _selectedTechnicianRepId set via _autofilledTechRepName to: $_selectedTechnicianRepId",
                      );
                    }
                  }
                });
              }
            },
            builder: (context, techState) {
              return BlocConsumer<
                CommissioningStep6AutoFillBloc,
                CommissioningStep6AutoFillState
              >(
                bloc: _step6Bloc,
                listener: (context, step6State) {
                  if (step6State is CommissioningStep6AutoFillSuccessState) {
                    final data = step6State.data.data;
                    setState(() {
                      if (data.technicianRemarks.isNotEmpty) {
                        _technicianRemarksController.text =
                            data.technicianRemarks;
                      }
                      if (data.customerRemarks.isNotEmpty) {
                        _customerRemarksController.text = data.customerRemarks;
                      }
                      if (data.customerRepresentativeName.isNotEmpty) {
                        _customerRepNameController.text =
                            data.customerRepresentativeName;
                      }
                      if (data.technicianRepresentativeName.isNotEmpty) {
                        _autofilledTechRepName =
                            data.technicianRepresentativeName;
                        print(
                          "ðŸ“‹ Autofilled tech rep name: $_autofilledTechRepName",
                        );
                        if (_assignedTechniciansList.isNotEmpty) {
                          final matched = _assignedTechniciansList.firstWhere(
                            (t) =>
                                t.name.toLowerCase() ==
                                data.technicianRepresentativeName.toLowerCase(),
                            orElse: () => _assignedTechniciansList.first,
                          );
                          _selectedTechnicianRepId = matched.assignId;
                          print(
                            "ðŸŽ¯ _selectedTechnicianRepId set via autofill match to: $_selectedTechnicianRepId",
                          );
                        }
                      }
                      _existingTechnicianSignatureUrl =
                          data.technicianSignature;
                      _existingCustomerSignatureUrl = data.customerSignature;
                      _existingWorkPhotosUrls = data.savedWorkPhotos;
                    });
                  }
                },
                builder: (context, step6State) {
                  if (techState
                          is AssignedTechnicianRepresentativeLoadingState ||
                      step6State is CommissioningStep6AutoFillLoadingState) {
                    return const StepShimmer(step: 6);
                  }
                  return Step6Widget(parent: this);
                },
              );
            },
          );
        }
      default:
        return const Center(child: Text("Coming Soon"));
    }
  }

  void _showTechnicianBottomSheet(
    BuildContext context,
    List<dynamic> validItems,
    TextEditingController controller,
    int index,
  ) {
    String lastSearch = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filteredItems = lastSearch.isEmpty
                ? validItems
                : validItems
                    .where((item) => item.name
                        .toLowerCase()
                        .contains(lastSearch.toLowerCase()))
                    .toList();

            return SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(ctx).size.height * 0.5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        onChanged: (val) {
                          setModalState(() {
                            lastSearch = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: AppFont.style(
                            fontSize: 14,
                            color: const Color(0xFFA5ABB7),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFF1565C0)),
                          ),
                        ),
                        style: AppFont.style(
                          fontSize: 14,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, i) {
                            final item = filteredItems[i];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  controller.text = item.name;
                                  _technicianIds[index] = item.id;
                                });
                                Navigator.pop(ctx);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                child: Text(
                                  item.name,
                                  style: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF0D121F),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
        ),
        Text(
          ':',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable Step Builders (Placeholder logic for Steps 2-6)
  

  

  Widget _buildTechField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF5C616E),
                  ),
                ),
                // const TextSpan(
                //   text: ' *',
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w900,
                //     color: Colors.red,
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0D121F),
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF1F2F6)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF1565C0), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechMultiField(
    String label,
    List<String> units,
    List<TextEditingController> controllers,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF5C616E),
                  ),
                ),
                // const TextSpan(
                //   text: ' *',
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w900,
                //     color: Colors.red,
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: List.generate(units.length, (index) {
              final unit = units[index];
              final controller = controllers[index];
              return FractionallySizedBox(
                widthFactor: units.length == 1 ? 1.0 : 0.45,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit,
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                    ),
                    const SizedBox(height: 2),
                    TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d*'),
                        ),
                      ],
                      style: AppFont.style(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0D121F),
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF1F2F6)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1565C0),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  

  Widget _buildWorkDescriptionField(
    int number,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              '$number.',
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFA5ABB7),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: controller,
                    minLines: 2,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                    decoration: InputDecoration(
                      hintText: 'commissioning_work_description_hint'.tr(),
                      hintStyle: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFA5ABB7),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: SpeechToTextMicButton(controller: controller),
                  ),
                  // const Positioned(
                  //   bottom: 8,
                  //   right: 8,
                  //   child: Icon(
                  //     Icons.signal_cellular_4_bar,
                  //     size: 12,
                  //     color: Color(0xFFA5ABB7),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  

  // â”€â”€ Checklist section wrapper (header + NA + items with disable support) â”€â”€â”€
  Widget _buildCheckSection({
    required IconData icon,
    required String title,
    required bool isNA,
    required VoidCallback onNATap,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF0D121F)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
            ),
            // NA checkbox
            GestureDetector(
              onTap: onNATap,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isNA
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: isNA ? const Color(0xFF1565C0) : Colors.white,
                    ),
                    child: isNA
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'commissioning_na_paren'.tr(),
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 12),
        // Items â€” disabled when NA is checked
        IgnorePointer(
          ignoring: isNA,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isNA ? 0.38 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
          ),
        ),
      ],
    );
  }

  // â”€â”€ Single checklist item: label + radio-style option boxes â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildCheckItem({
    required String label,
    required String? selected,
    required List<String> options,
    required List<String> labels,
    required ValueChanged<String> onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF5C616E),
                  ),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(options.length, (i) {
              final isSelected = selected == options[i];
              return Padding(
                padding: EdgeInsets.only(
                  right: i < options.length - 1 ? 20 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    onSelect(options[i]);
                    if (options[i] != 'not_ok') {
                      setState(() {
                        _step5Media.remove(label);
                      });
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Checkbox
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1565C0)
                                : const Color(0xFFCDD0D8),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        labels[i],
                        style: AppFont.style(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF7A8699),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaActionBtn({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF1565C0)),
            const SizedBox(width: 6),
            Text(
              text,
              style: AppFont.style(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  Future<void> _showImagePickerOption(
    BuildContext context,
    Function(File) onImageSelected,
  ) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('commissioning_gallery'.tr()),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? file = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file != null) {
                    onImageSelected(File(file.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('commissioning_camera'.tr()),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? file = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (file != null) {
                    onImageSelected(File(file.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSignatureDrawingPad(
    BuildContext context,
    Function(File) onSignatureDrawn,
  ) async {
    final SignatureController signatureController = SignatureController(
      penStrokeWidth: 4,
      penColor: const Color(0xFF0D121F),
      exportBackgroundColor: Colors.white,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'commissioning_draw_signature'.tr(),
                        style: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Signature(
                        controller: signatureController,
                        height: 200,
                        backgroundColor: const Color(0xFFF9FAFB),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            signatureController.clear();
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFCDD0D8)),
                            ),
                            child: Center(
                              child: Text(
                                'commissioning_clear'.tr(),
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (signatureController.isEmpty) {
                              return;
                            }
                            final bytes = await signatureController
                                .toPngBytes();
                            if (bytes != null) {
                              final tempDir = await getTemporaryDirectory();
                              final file = File(
                                '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                              );
                              await file.writeAsBytes(bytes);
                              onSignatureDrawn(file);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'commissioning_done'.tr(),
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        signatureController.dispose();
      });
    });
  }

  Widget _buildRemarksBox(
    String placeholder,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            minLines: 4,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SpeechToTextMicButton(controller: controller),
          ),
          const Positioned(
            bottom: 8,
            right: 8,
            child: Icon(
              Icons.signal_cellular_4_bar,
              size: 12,
              color: Color(0xFFA5ABB7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureBox({
    required String label,
    required String placeholder,
    required File? signatureFile,
    required String? existingUrl,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: label.contains('*')
              ? RichText(
                  text: TextSpan(
                    text: label.replaceAll('*', '').trimRight(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8E9BAE),
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  label,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8E9BAE),
                  ),
                ),
        ),
        const SizedBox(width: 8),
        const Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap:
                (signatureFile == null &&
                    (existingUrl == null || existingUrl.isEmpty))
                ? onTap
                : null,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Stack(
                children: [
                  if (signatureFile != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(signatureFile, fit: BoxFit.contain),
                      ),
                    )
                  else if (existingUrl != null && existingUrl.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          existingUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFFA5ABB7),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            placeholder,
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFCDD0D8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (signatureFile != null ||
                      (existingUrl != null && existingUrl.isNotEmpty))
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onClear,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderStep(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFont.style(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Icon(Icons.construction, size: 100, color: Color(0xFFF1F2F6)),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppFont.style(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFA5ABB7),
      ),
    );
  }

  Widget _buildAddNewButton(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: AppFont.style(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1565C0),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA5ABB7),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
      
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(10)));
      
    Path dashPath = Path();
    double dashWidth = 6.0;
    double dashSpace = 4.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
