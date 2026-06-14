import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step1_bloc/service_work_report_step1_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step1_bloc/service_work_report_step1_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step1_bloc/service_work_report_step1_state.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step1_autofill_bloc/service_work_report_step1_autofill_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step1_autofill_bloc/service_work_report_step1_autofill_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step1_autofill_bloc/service_work_report_step1_autofill_state.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step2_bloc/service_work_report_step2_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step2_bloc/service_work_report_step2_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step2_bloc/service_work_report_step2_state.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step2_usecase.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step2_autofill_bloc/service_work_report_step2_autofill_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step2_autofill_bloc/service_work_report_step2_autofill_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step2_autofill_bloc/service_work_report_step2_autofill_state.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step3_autofill_bloc/service_work_report_step3_autofill_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step3_autofill_bloc/service_work_report_step3_autofill_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step3_autofill_bloc/service_work_report_step3_autofill_state.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step3_usecase.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step3_bloc/service_work_report_step3_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step3_bloc/service_work_report_step3_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step3_bloc/service_work_report_step3_state.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step4_bloc/service_work_report_step4_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step4_bloc/service_work_report_step4_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step4_bloc/service_work_report_step4_state.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step4_autofill_bloc/service_work_report_step4_autofill_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step4_autofill_bloc/service_work_report_step4_autofill_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_step4_autofill_bloc/service_work_report_step4_autofill_state.dart';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step4_usecase.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_technicians_bloc/service_work_report_technicians_bloc.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_technicians_bloc/service_work_report_technicians_event.dart';
import 'package:service_app/src/features/reports/bloc/service_work_report_technicians_bloc/service_work_report_technicians_state.dart';
import 'package:service_app/src/features/reports/bloc/delete_service_work_report_bloc/delete_service_work_report_bloc.dart';
import 'package:service_app/src/features/reports/bloc/delete_service_work_report_bloc/delete_service_work_report_event.dart';
import 'package:service_app/src/features/reports/bloc/delete_service_work_report_bloc/delete_service_work_report_state.dart';
import 'package:service_app/src/remote/models/service_work_report_step3_model/service_work_report_step3_response.dart';
import 'dart:convert';
import 'package:service_app/src/features/reports/domain/usecases/service_work_report_step1_usecase.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:service_app/src/features/widgets/step_shimmer.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:signature/signature.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class CreateReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String? complaintId;
  const CreateReportScreen({super.key, required this.onBack, this.complaintId});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  int _currentStep = 1;

  bool _isCustomerDropdownOpen = false;
  bool _isSiteDropdownOpen = false;
  bool _isCustomerAddNew =
      false; // true = show text field, false = show dropdown
  bool _isSiteAddNew = false; // true = show text field, false = show dropdown
  String _selectedCustomer = 'Select Customer';
  String _selectedSite = 'Select Site';
  String? _selectedCustomerId;
  String? _selectedSiteId;
  String? _reportId;
  String? _complaintId;

  final TextEditingController _newCustomerController = TextEditingController();
  final TextEditingController _newSiteController = TextEditingController();

  final List<String> _customersList = [];

  final List<String> _sitesList = [];

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late TechnicianBloc _technicianBloc;

  final List<TextEditingController> _technicians = [TextEditingController()];
  final List<String?> _technicianIds = [null];

  bool _isAutoCalculatingFlow = false;
  bool _isAutoCalculatingRating = false;

  void _setupAutoCalculateListeners() {
    _pumpFlowLpmCtrl.addListener(() => _calculateFlow('LPM'));
    _pumpFlowLpsCtrl.addListener(() => _calculateFlow('LPS'));
    _pumpFlowM3hrCtrl.addListener(() => _calculateFlow('M3HR'));
    _pumpFlowUsgpmCtrl.addListener(() => _calculateFlow('USGPM'));

    _ratingKwCtrl.addListener(() => _calculateRating('KW'));
    _ratingHpCtrl.addListener(() => _calculateRating('HP'));
  }

  void _calculateFlow(String source) {
    if (_isAutoCalculatingFlow) return;
    String text = "";
    if (source == 'LPM')
      text = _pumpFlowLpmCtrl.text;
    else if (source == 'LPS')
      text = _pumpFlowLpsCtrl.text;
    else if (source == 'M3HR')
      text = _pumpFlowM3hrCtrl.text;
    else if (source == 'USGPM')
      text = _pumpFlowUsgpmCtrl.text;

    if (text.isEmpty) {
      _isAutoCalculatingFlow = true;
      if (source != 'LPM') _pumpFlowLpmCtrl.text = "";
      if (source != 'LPS') _pumpFlowLpsCtrl.text = "";
      if (source != 'M3HR') _pumpFlowM3hrCtrl.text = "";
      if (source != 'USGPM') _pumpFlowUsgpmCtrl.text = "";
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
      _pumpFlowLpmCtrl.text = lpm.round().toString();
    if (source != 'LPS')
      _pumpFlowLpsCtrl.text = lps.round().toString();
    if (source != 'M3HR')
      _pumpFlowM3hrCtrl.text = m3hr.round().toString();
    if (source != 'USGPM')
      _pumpFlowUsgpmCtrl.text = usgpm.round().toString();

    _isAutoCalculatingFlow = false;
  }

  void _calculateRating(String source) {
    if (_isAutoCalculatingRating) return;
    String text = source == 'KW' ? _ratingKwCtrl.text : _ratingHpCtrl.text;

    if (text.isEmpty) {
      _isAutoCalculatingRating = true;
      if (source != 'KW') _ratingKwCtrl.text = "";
      if (source != 'HP') _ratingHpCtrl.text = "";
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
        _ratingHpCtrl.text = hp.round().toString();
    } else {
      hp = value;
      kw = hp * 0.746;
      if (source != 'KW')
        _ratingKwCtrl.text = kw.round().toString();
    }

    _isAutoCalculatingRating = false;
  }

  late ServiceWorkReportStep1Bloc _serviceWorkReportStep1Bloc;
  late ServiceWorkReportStep1AutofillBloc _serviceWorkReportStep1AutofillBloc;
  late ServiceWorkReportStep2Bloc _serviceWorkReportStep2Bloc;
  late ServiceWorkReportStep2AutofillBloc _serviceWorkReportStep2AutofillBloc;
  late ServiceWorkReportStep3Bloc _serviceWorkReportStep3Bloc;
  late ServiceWorkReportStep3AutofillBloc _serviceWorkReportStep3AutofillBloc;
  late ServiceWorkReportStep4Bloc _serviceWorkReportStep4Bloc;
  late ServiceWorkReportStep4AutofillBloc _serviceWorkReportStep4AutofillBloc;
  late ServiceWorkReportTechniciansBloc _serviceWorkReportTechniciansBloc;
  late DeleteServiceWorkReportBloc _deleteServiceWorkReportBloc;

  String? _loggedInTechnicianAssignId;

  String _loggedInTechnicianId = '';
  String _loggedInTechnicianName = '';
  String _loggedInDealerName = '';
  final TextEditingController _technicianNameController = TextEditingController();

  Future<void> _fetchLoggedInTechnician() async {
    final session = await SessionManager.getUserSession();
    if (session != null) {
      if (mounted) {
        setState(() {
          if (session.technician != null) {
            _loggedInTechnicianId = session.technician!.id;
            _loggedInTechnicianName = session.technician!.name;
            _technicianNameController.text = session.technician!.name;
          } else if (session.dealer != null) {
            _loggedInTechnicianId = session.dealer!.id;
            _loggedInTechnicianName = session.dealer!.name;
            _technicianNameController.text = session.dealer!.name;
          }
          if (session.dealer != null) {
            _loggedInDealerName = session.dealer!.name;
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLoggedInTechnician();
    if (widget.complaintId != null) {
      _complaintId = widget.complaintId;
    }
    _setupAutoCalculateListeners();
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
    _serviceWorkReportStep1Bloc = getIt<ServiceWorkReportStep1Bloc>();
    _serviceWorkReportStep1AutofillBloc = getIt<ServiceWorkReportStep1AutofillBloc>();
    _serviceWorkReportStep2Bloc = getIt<ServiceWorkReportStep2Bloc>();
    _serviceWorkReportStep2AutofillBloc = getIt<ServiceWorkReportStep2AutofillBloc>();
    _serviceWorkReportStep3Bloc = getIt<ServiceWorkReportStep3Bloc>();
    _serviceWorkReportStep3AutofillBloc = getIt<ServiceWorkReportStep3AutofillBloc>();
    _serviceWorkReportStep4Bloc = getIt<ServiceWorkReportStep4Bloc>();
    _serviceWorkReportStep4AutofillBloc = getIt<ServiceWorkReportStep4AutofillBloc>();
    _serviceWorkReportTechniciansBloc = getIt<ServiceWorkReportTechniciansBloc>();
    _deleteServiceWorkReportBloc = getIt<DeleteServiceWorkReportBloc>();

    if (_complaintId != null) {
      _serviceWorkReportStep1AutofillBloc.add(GetServiceWorkReportStep1AutofillEvent(_complaintId!));
    }
  }

  // Dynamic list of member name fields – starts with one empty field
  final List<TextEditingController> _memberControllers = [
    TextEditingController(),
  ];
  // Mic toggle state for agenda field
  final TextEditingController _agendaController = TextEditingController();

  // ── Step 2: Technical Details ───────────────────────────────────────────────
  bool _isTechnicalNA = false;
  final TextEditingController _pumpMakeCtrl = TextEditingController();
  final TextEditingController _pumpModelCtrl = TextEditingController();
  final TextEditingController _pumpSerialCtrl = TextEditingController();
  final TextEditingController _pumpFlowLpmCtrl = TextEditingController();
  final TextEditingController _pumpFlowM3hrCtrl = TextEditingController();
  final TextEditingController _pumpFlowLpsCtrl = TextEditingController();
  final TextEditingController _pumpFlowUsgpmCtrl = TextEditingController();
  final TextEditingController _pumpHeadMtrCtrl = TextEditingController();
  final TextEditingController _driverMakeCtrl = TextEditingController();
  final TextEditingController _driverSerialCtrl = TextEditingController();
  final TextEditingController _ratingKwCtrl = TextEditingController();
  final TextEditingController _ratingHpCtrl = TextEditingController();
  final TextEditingController _rpmCtrl = TextEditingController();
  final TextEditingController _panelMakeCtrl = TextEditingController();
  final TextEditingController _panelSerialCtrl = TextEditingController();
  // Work Description – 3 rows initially
  final List<TextEditingController> _workDescControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void _addMemberField() {
    setState(() {
      _memberControllers.add(TextEditingController());
    });
  }

  void _removeMemberField(int index) {
    setState(() {
      _memberControllers[index].dispose();
      _memberControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    _serviceWorkReportStep1Bloc.close();
    _serviceWorkReportStep2Bloc.close();
    _serviceWorkReportStep2AutofillBloc.close();
    _serviceWorkReportStep3Bloc.close();
    _serviceWorkReportStep3AutofillBloc.close();
    _serviceWorkReportStep4Bloc.close();
    _serviceWorkReportTechniciansBloc.close();
    _deleteServiceWorkReportBloc.close();
    _technicianBloc.close();
    for (final c in _technicians) c.dispose();
    _technicianIds.clear();
    _customerBloc.close();
    _sitesBloc.close();
    for (final c in _memberControllers) c.dispose();
    _agendaController.dispose();
    _newCustomerController.dispose();
    _newSiteController.dispose();
    // step 2
    _pumpMakeCtrl.dispose();
    _pumpModelCtrl.dispose();
    _pumpSerialCtrl.dispose();
    _pumpFlowLpmCtrl.dispose();
    _pumpFlowM3hrCtrl.dispose();
    _pumpFlowLpsCtrl.dispose();
    _pumpFlowUsgpmCtrl.dispose();
    _pumpHeadMtrCtrl.dispose();
    _driverMakeCtrl.dispose();
    _driverSerialCtrl.dispose();
    _ratingKwCtrl.dispose();
    _ratingHpCtrl.dispose();
    _rpmCtrl.dispose();
    _panelMakeCtrl.dispose();
    _panelSerialCtrl.dispose();
    for (final c in _workDescControllers) c.dispose();
    // step 4
    _remarksTechCtrl.dispose();
    _remarksCustomerCtrl.dispose();
    _customerRepNameCtrl.dispose();
    _technicianNameController.dispose();
    super.dispose();
  }

  // ── Step 3: Preventive Maintenance Checklist ──────────────────────────────
  // NA toggles per section
  bool _mechNA = false;
  bool _pipeNA = false;
  bool _elecNA = false;

  // Mechanical Checklist  (null = unset, 'ok' / 'not_ok' / 'normal' / 'high')
  String? _bearingNoise;
  String? _vibration; // 'normal' | 'high'
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

  // ── Step 4: Remarks + Photos + Recorded By ─────────────────────────────
  final TextEditingController _remarksTechCtrl = TextEditingController();
  final TextEditingController _remarksCustomerCtrl = TextEditingController();
  final TextEditingController _customerRepNameCtrl = TextEditingController();
  final List<XFile> _pickedPhotos = [];
  List<String> _existingWorkPhotosUrls = [];
  final ImagePicker _imagePicker = ImagePicker();

  File? _technicianSignatureFile;
  String? _existingTechnicianSignatureUrl;

  File? _customerSignatureFile;
  String? _existingCustomerSignatureUrl;

  Future<void> _pickPhoto() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _pickedPhotos.add(file));
    }
  }

  void _removePhoto(int index) {
    setState(() => _pickedPhotos.removeAt(index));
  }

  void _nextStep() {
    if (_currentStep == 1) {
      List<Map<String, String>> techs = [];
      var techState = _technicianBloc.state;
      if (techState is TechnicianSuccessState) {
        for (int i = 0; i < _technicians.length; i++) {
          var ctrl = _technicians[i];
          if (ctrl.text.isNotEmpty) {
            String name = ctrl.text;
            String id = _technicianIds[i] ?? "";

            if (id.isEmpty) {
              try {
                final match = techState.data.data.firstWhere((e) => e.name == name);
                id = match.id;
              } catch (_) {}
            }
            techs.add({
              "id": id,
              "name": name,
            });
          }
        }
      }

      if (techs.isEmpty) {
        appSnackBar(context, const Color(0xFFF44336), "Please add at least one technician");
        return;
      }

      if (_selectedCustomerId == null) {
        appSnackBar(context, const Color(0xFFF44336), "Please select customer");
        return;
      }
      if (_selectedSiteId == null) {
        appSnackBar(context, const Color(0xFFF44336), "Please select site");
        return;
      }

      _serviceWorkReportStep1Bloc.add(
        PostServiceWorkReportStep1Event(
          ServiceWorkReportStep1Params(
            customerId: _selectedCustomerId!,
            siteId: _selectedSiteId!,
            technicianIds: techs,
            memberPresentsCustomerSide:
                _memberControllers.map((e) => e.text).where((e) => e.isNotEmpty).join(", "),
            agenda: _agendaController.text,
          ),
        ),
      );
    } else if (_currentStep == 2) {
      if (_reportId == null) {
        appSnackBar(context, const Color(0xFFF44336), "Missing report ID. Please save step 1 first.");
        return;
      }
      List<Map<String, dynamic>> descList = [];
      for (int i = 0; i < _workDescControllers.length; i++) {
        if (_workDescControllers[i].text.isNotEmpty) {
          descList.add({
            "sr_no": i,
            "description": _workDescControllers[i].text,
          });
        }
      }

      Map<String, dynamic> techDetails = {};
      if (!_isTechnicalNA) {
        techDetails = {
          "pump_make": _pumpMakeCtrl.text,
          "pump_model": _pumpModelCtrl.text,
          "pump_serial": _pumpSerialCtrl.text,
          "pump_flow": {
            "lpm": _pumpFlowLpmCtrl.text,
            "lps": _pumpFlowLpsCtrl.text,
            "m3_hr": _pumpFlowM3hrCtrl.text,
            "usgpm": _pumpFlowUsgpmCtrl.text,
          },
          "pump_head_mtr": _pumpHeadMtrCtrl.text,
          "driver_make": _driverMakeCtrl.text,
          "driver_serial": _driverSerialCtrl.text,
          "rating_kw": _ratingKwCtrl.text,
          "rating_hp": _ratingHpCtrl.text,
          "rpm": _rpmCtrl.text,
          "panel_make": _panelMakeCtrl.text,
          "panel_serial": _panelSerialCtrl.text,
        };
      }

      _serviceWorkReportStep2Bloc.add(
        PostServiceWorkReportStep2Event(
          ServiceWorkReportStep2Params(
            id: _reportId!,
            isTechnicalNa: _isTechnicalNA,
            technicalDetails: jsonEncode(techDetails),
            descriptions: descList,
          ),
        ),
      );
    } else if (_currentStep == 3) {
      if (_reportId == null) return;

      // Validate mechanical section
      if (!_mechNA) {
        if (_bearingNoise == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_bearing'.tr());
          return;
        }
        if (_vibration == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_vibration'.tr());
          return;
        }
        if (_mechSeal == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_mech_seal'.tr());
          return;
        }
        if (_pumpDry == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_pump_dry'.tr());
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
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_strainer'.tr());
          return;
        }
        if (_suctionLine == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_suction_line'.tr());
          return;
        }
        if (_deliveryLine == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_del_line'.tr());
          return;
        }
        if (_suctionDelivery == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_suction_del'.tr());
          return;
        }
        if (_pressureSwitch == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_pressure'.tr());
          return;
        }
      }

      // Validate electrical section
      if (!_elecNA) {
        if (_elecFaults == null) {
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_elec_faults'.tr());
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
          appSnackBar(context, const Color(0xFFF44336), 'val_sel_panel_wiring'.tr());
          return;
        }
      }

      List<ServiceWorkChecklistItem> checklistItems = [];
      void addChecklistIfNotNull(String? value, String checkType, String key) {
        if (value != null) {
          checklistItems.add(ServiceWorkChecklistItem(
            checkType: checkType,
            keyChecklist: key,
            valueChecklist: value,
          ));
        }
      }

      // Mechanical
      addChecklistIfNotNull(_bearingNoise, "mechanical", "Bearing Noise / Abnormal Sound Checked");
      addChecklistIfNotNull(_vibration, "mechanical", "Vibration Checked");
      addChecklistIfNotNull(_mechSeal, "mechanical", "Mechanical Seal / Gland Leakage Checked");
      addChecklistIfNotNull(_pumpDry, "mechanical", "Pump Not Running Dry");

      // Pipeline
      addChecklistIfNotNull(_nrvValve, "pipeline", "NRV / Butterfly Valve / Gate Valve Condition Checked");
      addChecklistIfNotNull(_strainerValve, "pipeline", "Strainer / Foot Valve Condition Checked");
      addChecklistIfNotNull(_suctionLine, "pipeline", "Suction Line (Air Leakage & Water Leakage Checked)");
      addChecklistIfNotNull(_deliveryLine, "pipeline", "Delivery Line (Air Leakage & Water Leakage Checked)");
      addChecklistIfNotNull(_suctionDelivery, "pipeline", "Suction / Delivery Valve Condition Checked");
      addChecklistIfNotNull(_pressureSwitch, "pipeline", "Pressure Switch / Pressure Transmitter Checked");

      // Electrical
      addChecklistIfNotNull(_elecFaults, "electrical", "Electrical Faults Checked");
      addChecklistIfNotNull(_voltage, "electrical", "Voltage Checked");
      addChecklistIfNotNull(_phase, "electrical", "Phase Checked");
      addChecklistIfNotNull(_current, "electrical", "Current Checked");
      addChecklistIfNotNull(_panelWiring, "electrical", "Control Panel Wiring Checked");

      _serviceWorkReportStep3Bloc.add(
        PostServiceWorkReportStep3Event(
          ServiceWorkReportStep3Params(
            id: _reportId!,
            isMechanicalChecklistNa: _mechNA,
            isPipelineChecklistNa: _pipeNA,
            isElectricalChecklistNa: _elecNA,
            checklistItems: checklistItems,
          ),
        ),
      );
    } else if (_currentStep == 4) {
      if (_reportId == null) {
        appSnackBar(context, const Color(0xFFF44336), "Missing report ID.");
        return;
      }
      if (_technicianNameController.text.trim().isEmpty) {
        appSnackBar(context, const Color(0xFFF44336), "Technician Representative name is required");
        return;
      }
      if (_customerRepNameCtrl.text.trim().isEmpty) {
        appSnackBar(context, const Color(0xFFF44336), "Customer Representative name is required");
        return;
      }
      if (_customerSignatureFile == null && (_existingCustomerSignatureUrl == null || _existingCustomerSignatureUrl!.isEmpty)) {
        appSnackBar(context, const Color(0xFFF44336), "Customer Signature is required");
        return;
      }
      if (_technicianSignatureFile == null && (_existingTechnicianSignatureUrl == null || _existingTechnicianSignatureUrl!.isEmpty)) {
        appSnackBar(context, const Color(0xFFF44336), "Technician Signature is required");
        return;
      }

      List<String> allWorkPhotos = _pickedPhotos.map((e) => e.path).toList();
      allWorkPhotos.addAll(_existingWorkPhotosUrls);

      _serviceWorkReportStep4Bloc.add(
        PostServiceWorkReportStep4Event(
          params: ServiceWorkReportStep4Params(
            id: _reportId!,
            customerRepresentativeName: _customerRepNameCtrl.text.trim(),
            customerRemarks: _remarksCustomerCtrl.text.trim(),
            technicianRemarks: _remarksTechCtrl.text.trim(),
            technicianRepresentative: _loggedInTechnicianAssignId ?? _loggedInTechnicianId,
            workPhotosPaths: allWorkPhotos,
            customerSignaturePath: _customerSignatureFile?.path ?? _existingCustomerSignatureUrl,
            technicianSignaturePath: _technicianSignatureFile?.path ?? _existingTechnicianSignatureUrl,
          ),
        ),
      );
    } else if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      if (_currentStep == 1 && _complaintId != null) {
        _serviceWorkReportStep1AutofillBloc.add(GetServiceWorkReportStep1AutofillEvent(_complaintId!));
      }
      if (_currentStep == 2 && _reportId != null) {
        _serviceWorkReportStep2AutofillBloc.add(GetServiceWorkReportStep2AutofillEvent(_reportId!));
      }
      if (_currentStep == 3 && _reportId != null) {
        _serviceWorkReportStep3AutofillBloc.add(GetServiceWorkReportStep3AutofillEvent(_reportId!));
      }
    } else {
      _handleBack();
    }
  }

  Future<void> _handleBack() async {
    final step4State = _serviceWorkReportStep4Bloc.state;
    if (step4State is ServiceWorkReportStep4Loaded) {
      widget.onBack();
      return;
    }

    if (_reportId != null) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                          color: Color(0xFFFFF1F0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          color: Color(0xFFFF4D4F),
                          size: 32,
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // ── Title ───────────────────────────────────────────────────────
                      Text(
                        'Delete Draft Report?',
                        style: AppFont.style(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D121F),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Subtitle ────────────────────────────────────────────────────
                      Text(
                        'Are you sure you want to go back?\nThis draft report will be permanently\ndeleted.',
                        textAlign: TextAlign.center,
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5C616E),
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
                                onPressed: () => Navigator.pop(context, false),
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFF6F6F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: AppFont.style(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0D121F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Delete Now Button
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: BlocConsumer<DeleteServiceWorkReportBloc, DeleteServiceWorkReportState>(
                                bloc: _deleteServiceWorkReportBloc,
                                listener: (context, state) {
                                  if (state is DeleteServiceWorkReportSuccess) {
                                    Navigator.pop(context, true);
                                  } else if (state is DeleteServiceWorkReportFailure) {
                                    appSnackBar(context, Colors.red, state.message);
                                    Navigator.pop(context, true); // Go back anyway to exit draft
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading = state is DeleteServiceWorkReportLoading;
                                  return ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            _deleteServiceWorkReportBloc.add(
                                              DeleteDraftServiceWorkReportEvent(_reportId!),
                                            );
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE30000),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      disabledBackgroundColor: const Color(0xFFE30000).withOpacity(0.6),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Delete Now',
                                            style: AppFont.style(
                                              fontSize: 14,
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
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFFB0B8C8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (confirm == true) {
        widget.onBack();
      }
    } else {
      widget.onBack();
    }
  }

  void _showSuccessDialog({String qrCodeUrl = ""}) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                      onPressed: () {
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
                  'Service Call Report Feedback',
                  textAlign: TextAlign.center,
                  style: AppFont.style(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
                const SizedBox(height: 8),
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
                  child: qrCodeUrl.isNotEmpty
                      ? Image.network(
                          qrCodeUrl,
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
                  'Scan for Customer Feedback',
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
        );
      },
    );
  }

  String _getStepInfo() {
    switch (_currentStep) {
      case 1:
        return 'create_report_step_info'.tr();
      case 2:
        return 'create_report_step_info_2'.tr();
      case 3:
        return 'create_report_step_info_3'.tr();
      case 4:
        return 'create_report_step_info_4'.tr();
      default:
        return 'STEP $_currentStep OF 4';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServiceWorkReportStep1Bloc, ServiceWorkReportStep1State>(
          bloc: _serviceWorkReportStep1Bloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep1Success) {
              setState(() {
                _reportId = state.data.data.id;
                if (state.data.data.complaintId.isNotEmpty) {
                  _complaintId = state.data.data.complaintId;
                }
                _currentStep++;
              });
              if (_complaintId != null) {
                _serviceWorkReportStep1AutofillBloc.add(GetServiceWorkReportStep1AutofillEvent(_complaintId!));
              }
              // Trigger step2 autofill after moving to step 2
              if (_reportId != null) {
                _serviceWorkReportStep2AutofillBloc.add(GetServiceWorkReportStep2AutofillEvent(_reportId!));
              }
            } else if (state is ServiceWorkReportStep1Failure) {
              appSnackBar(context, const Color(0xFFF44336), state.message);
            }
          },
        ),
        BlocListener<ServiceWorkReportStep2Bloc, ServiceWorkReportStep2State>(
          bloc: _serviceWorkReportStep2Bloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep2Success) {
              setState(() {
                _currentStep++;
              });
              if (_reportId != null) {
                _serviceWorkReportStep3AutofillBloc.add(GetServiceWorkReportStep3AutofillEvent(_reportId!));
              }
            } else if (state is ServiceWorkReportStep2Failure) {
              appSnackBar(context, const Color(0xFFF44336), state.error);
            }
          },
        ),
        BlocListener<ServiceWorkReportStep2AutofillBloc, ServiceWorkReportStep2AutofillState>(
          bloc: _serviceWorkReportStep2AutofillBloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep2AutofillSuccess) {
              final data = state.data.data;
              setState(() {
                _isTechnicalNA = data.isTechnicalNa;
                // Pre-fill work descriptions
                _workDescControllers.clear();
                for (var desc in data.savedDescriptions) {
                  _workDescControllers.add(TextEditingController(text: desc.description));
                }
                // Always show at least 3 rows
                while (_workDescControllers.length < 3) {
                  _workDescControllers.add(TextEditingController());
                }
              });
            } else if (state is ServiceWorkReportStep2AutofillFailure) {
              // Silent fail - just keep existing data
            }
          },
        ),
        BlocListener<ServiceWorkReportStep3Bloc, ServiceWorkReportStep3State>(
          bloc: _serviceWorkReportStep3Bloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep3Success) {
              setState(() {
                _currentStep++;
              });
              if (_reportId != null) {
                _serviceWorkReportTechniciansBloc.add(FetchServiceWorkReportTechniciansEvent(_reportId!));
                _serviceWorkReportStep4AutofillBloc.add(GetServiceWorkReportStep4AutofillEvent(_reportId!));
              }
            } else if (state is ServiceWorkReportStep3Failure) {
              appSnackBar(context, const Color(0xFFF44336), state.error);
            }
          },
        ),
        BlocListener<ServiceWorkReportStep4Bloc, ServiceWorkReportStep4State>(
          bloc: _serviceWorkReportStep4Bloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep4Loaded) {
              appSnackBar(context, const Color(0xFF4CAF50), state.response.message ?? 'Report submitted successfully');
              _showSuccessDialog(qrCodeUrl: state.response.data.qrCodeImage);
            } else if (state is ServiceWorkReportStep4Error) {
              appSnackBar(context, const Color(0xFFF44336), state.message);
            }
          },
        ),
        BlocListener<ServiceWorkReportStep3AutofillBloc, ServiceWorkReportStep3AutofillState>(
          bloc: _serviceWorkReportStep3AutofillBloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep3AutofillSuccess) {
              final data = state.data.data;
              setState(() {
                _mechNA = data.isMechanicalChecklistNa;
                _pipeNA = data.isPipelineChecklistNa;
                _elecNA = data.isElectricalChecklistNa;

                if (_reportId != null) {
                  _serviceWorkReportTechniciansBloc.add(FetchServiceWorkReportTechniciansEvent(_reportId!));
                }

                for (var item in data.savedChecklists) {
                  if (item.checkType == "mechanical") {
                    if (item.keyChecklist == "Bearing Noise / Abnormal Sound Checked") _bearingNoise = item.valueChecklist;
                    if (item.keyChecklist == "Vibration Checked") _vibration = item.valueChecklist;
                    if (item.keyChecklist == "Mechanical Seal / Gland Leakage Checked") _mechSeal = item.valueChecklist;
                    if (item.keyChecklist == "Pump Not Running Dry") _pumpDry = item.valueChecklist;
                  } else if (item.checkType == "pipeline") {
                    if (item.keyChecklist == "NRV / Butterfly Valve / Gate Valve Condition Checked") _nrvValve = item.valueChecklist;
                    if (item.keyChecklist == "Strainer / Foot Valve Condition Checked") _strainerValve = item.valueChecklist;
                    if (item.keyChecklist == "Suction Line (Air Leakage & Water Leakage Checked)") _suctionLine = item.valueChecklist;
                    if (item.keyChecklist == "Delivery Line (Air Leakage & Water Leakage Checked)") _deliveryLine = item.valueChecklist;
                    if (item.keyChecklist == "Suction / Delivery Valve Condition Checked") _suctionDelivery = item.valueChecklist;
                    if (item.keyChecklist == "Pressure Switch / Pressure Transmitter Checked") _pressureSwitch = item.valueChecklist;
                  } else if (item.checkType == "electrical") {
                    if (item.keyChecklist == "Electrical Faults Checked") _elecFaults = item.valueChecklist;
                    if (item.keyChecklist == "Voltage Checked") _voltage = item.valueChecklist;
                    if (item.keyChecklist == "Phase Checked") _phase = item.valueChecklist;
                    if (item.keyChecklist == "Current Checked") _current = item.valueChecklist;
                    if (item.keyChecklist == "Control Panel Wiring Checked") _panelWiring = item.valueChecklist;
                  }
                }
              });
            }
          },
        ),
        BlocListener<ServiceWorkReportStep4AutofillBloc, ServiceWorkReportStep4AutofillState>(
          bloc: _serviceWorkReportStep4AutofillBloc,
          listener: (context, state) {
            if (state is ServiceWorkReportStep4AutofillSuccess) {
              final data = state.data.data;
              setState(() {
                _remarksTechCtrl.text = data.technicianRemarks;
                _remarksCustomerCtrl.text = data.customerRemarks;
                _customerRepNameCtrl.text = data.customerRepresentativeName;

                if (data.technicianSignature.isNotEmpty) {
                  _existingTechnicianSignatureUrl = data.technicianSignature;
                }
                if (data.customerSignature.isNotEmpty) {
                  _existingCustomerSignatureUrl = data.customerSignature;
                }
                if (data.savedWorkPhotos.isNotEmpty) {
                  _existingWorkPhotosUrls = data.savedWorkPhotos;
                }
              });
            }
          },
        ),
        BlocListener<ServiceWorkReportTechniciansBloc, ServiceWorkReportTechniciansState>(
          bloc: _serviceWorkReportTechniciansBloc,
          listener: (context, state) {
            if (state is ServiceWorkReportTechniciansLoaded) {
              try {
                final match = state.response.data.firstWhere(
                  (tech) => tech.technicianId == _loggedInTechnicianId,
                );
                _loggedInTechnicianAssignId = match.assignId;
              } catch (_) {
                // If not found, ignore
              }
            }
          },
        ),
        BlocListener<CustomerBloc, CustomerState>(
          bloc: _customerBloc,
          listener: (context, state) {
            if (state is CustomerSuccessState) {
              if ((_selectedCustomerId == null || _selectedCustomerId!.isEmpty) && _selectedCustomer != 'Select Customer') {
                final matches = state.data.data.where((x) => x.name == _selectedCustomer);
                if (matches.isNotEmpty) {
                  setState(() {
                    _selectedCustomerId = matches.first.id;
                  });
                  _sitesBloc.add(SitesGetEvent(customer_id: matches.first.id));
                }
              }
            }
          },
        ),
        BlocListener<SitesBloc, SitesState>(
          bloc: _sitesBloc,
          listener: (context, state) {
            if (state is SitesSuccessState) {
              if ((_selectedSiteId == null || _selectedSiteId!.isEmpty) && _selectedSite != 'Select Site') {
                final matches = state.data.data.where((x) => x.name == _selectedSite);
                if (matches.isNotEmpty) {
                  setState(() {
                    _selectedSiteId = matches.first.id;
                  });
                }
              }
            }
          },
        ),
      ],
      child: BlocBuilder<ServiceWorkReportStep4Bloc, ServiceWorkReportStep4State>(
        bloc: _serviceWorkReportStep4Bloc,
        builder: (context, step4State) {
          return BlocBuilder<ServiceWorkReportStep3Bloc, ServiceWorkReportStep3State>(
            bloc: _serviceWorkReportStep3Bloc,
            builder: (context, step3State) {
          return BlocBuilder<ServiceWorkReportStep2Bloc, ServiceWorkReportStep2State>(
            bloc: _serviceWorkReportStep2Bloc,
            builder: (context, step2State) {
          return BlocBuilder<ServiceWorkReportStep1Bloc, ServiceWorkReportStep1State>(
            bloc: _serviceWorkReportStep1Bloc,
            builder: (context, state) {
              return Stack(
                children: [
                  PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (didPop, _) {
                      if (!didPop) _handleBack();
                    },
                    child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
            // ── Progress & Header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
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
                          onPressed: _handleBack,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B68B9),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Service / Work Report',
                          style: AppFont.style(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Step Indicators
                  Row(
                    children: List.generate(4, (index) {
                      bool isActive = index < _currentStep;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF1565C0)
                                : const Color(0xFFF1F2F6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

            // ── Form Body ─────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildBodyContent(),
              ),
            ),

            // ── Bottom Buttons ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F2F6))),
              ),
              child: Row(
                children: [
                  if (_currentStep > 1)
                    GestureDetector(
                      onTap: _previousStep,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Color(0xFFA5ABB7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'create_report_btn_back'.tr(),
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFA5ABB7),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _handleBack,
                      child: Text(
                        'create_report_btn_cancel'.tr(),
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (state is ServiceWorkReportStep1Loading) return;
                      if (step2State is ServiceWorkReportStep2Loading) return;
                      if (step3State is ServiceWorkReportStep3Loading) return;
                      if (step4State is ServiceWorkReportStep4Loading) return;
                      _nextStep();
                    },
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1565C0,
                            ).withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Builder(
                        builder: (context) {
                          bool isLoading = (_currentStep == 1 && state is ServiceWorkReportStep1Loading) ||
                              (_currentStep == 2 && step2State is ServiceWorkReportStep2Loading) ||
                              (_currentStep == 3 && step3State is ServiceWorkReportStep3Loading) ||
                              (_currentStep == 4 && step4State is ServiceWorkReportStep4Loading);
                              
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_currentStep == 4 && !isLoading)
                                const Icon(
                                  Icons.check_box_outlined,
                                  size: 20,
                                  color: Colors.white,
                                )
                              else
                                const SizedBox.shrink(),
                              if (_currentStep == 4 && !isLoading)
                                const SizedBox(width: 12)
                              else
                                const SizedBox.shrink(),
                              if (isLoading)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              else
                                Text(
                                  _currentStep == 4
                                      ? 'create_report_btn_submit'.tr()
                                      : 'create_report_btn_next'.tr(),
                                  style: AppFont.style(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              if (_currentStep < 4 && !isLoading) ...[
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),)
              ]),
      ),
    ),
  ),
  ]);
            },
          );
        },
      );
        },
      );
        },
      ),
    );
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

  Widget _buildBodyContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return BlocBuilder<ServiceWorkReportStep2AutofillBloc, ServiceWorkReportStep2AutofillState>(
          bloc: _serviceWorkReportStep2AutofillBloc,
          builder: (context, autofillState) {
            if (autofillState is ServiceWorkReportStep2AutofillLoading) {
              return const StepShimmer(step: 1);
            }
            return _buildStep2();
          },
        );
      case 3:
        return BlocBuilder<ServiceWorkReportStep3AutofillBloc, ServiceWorkReportStep3AutofillState>(
          bloc: _serviceWorkReportStep3AutofillBloc,
          builder: (context, autofillState) {
            if (autofillState is ServiceWorkReportStep3AutofillLoading) {
              return const StepShimmer(step: 1);
            }
            return _buildStep3();
          },
        );
      case 4:
        return BlocBuilder<ServiceWorkReportStep4AutofillBloc, ServiceWorkReportStep4AutofillState>(
          bloc: _serviceWorkReportStep4AutofillBloc,
          builder: (context, autofillState) {
            if (autofillState is ServiceWorkReportStep4AutofillLoading) {
              return const StepShimmer(step: 1);
            }
            return _buildStep4();
          },
        );
      default:
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Text(
              "Coming Soon",
              style: AppFont.style(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFA5ABB7),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildStep1() {
    return BlocConsumer<ServiceWorkReportStep1AutofillBloc, ServiceWorkReportStep1AutofillState>(
      bloc: _serviceWorkReportStep1AutofillBloc,
      listener: (context, state) {
        if (state is ServiceWorkReportStep1AutofillSuccess) {
          final data = state.data.data;
          setState(() {
            _selectedCustomerId = data.customerId;
            _selectedCustomer = data.customerName.isNotEmpty ? data.customerName : 'Select Customer';
            _selectedSiteId = data.siteId;
            _selectedSite = data.siteName.isNotEmpty ? data.siteName : 'Select Site';
            
            if (data.memberPresentsCustomerSide.isNotEmpty) {
              final members = data.memberPresentsCustomerSide.split(',');
              _memberControllers.clear();
              for (var member in members) {
                if (member.trim().isNotEmpty) {
                  _memberControllers.add(TextEditingController(text: member.trim()));
                }
              }
            }
            if (_memberControllers.isEmpty) {
              _memberControllers.add(TextEditingController());
            }

            if (data.agenda.isNotEmpty) {
              _agendaController.text = data.agenda;
            }

            if (data.assignedTechnicians.isNotEmpty) {
              _technicians.clear();
              _technicianIds.clear();
              for (var tech in data.assignedTechnicians) {
                _technicians.add(TextEditingController(text: tech.name));
                _technicianIds.add(tech.id);
              }
            }
            if (_technicians.isEmpty) {
              _technicians.add(TextEditingController());
              _technicianIds.add(null);
            }
          });

          if ((_selectedCustomerId == null || _selectedCustomerId!.isEmpty) && _selectedCustomer != 'Select Customer') {
            final custState = _customerBloc.state;
            if (custState is CustomerSuccessState) {
              final matches = custState.data.data.where((x) => x.name == _selectedCustomer);
              if (matches.isNotEmpty) {
                setState(() {
                  _selectedCustomerId = matches.first.id;
                });
              }
            }
          }

          if (_selectedCustomerId != null && _selectedCustomerId!.isNotEmpty) {
            _sitesBloc.add(SitesGetEvent(customer_id: _selectedCustomerId!));
            
            if ((_selectedSiteId == null || _selectedSiteId!.isEmpty) && _selectedSite != 'Select Site') {
              final sitesState = _sitesBloc.state;
              if (sitesState is SitesSuccessState) {
                final siteMatches = sitesState.data.data.where((x) => x.name == _selectedSite);
                if (siteMatches.isNotEmpty) {
                  setState(() {
                    _selectedSiteId = siteMatches.first.id;
                  });
                }
              }
            }
          }
        } else if (state is ServiceWorkReportStep1AutofillFailure) {
          appSnackBar(context, const Color(0xFFF44336), state.message);
        }
      },
      builder: (context, autofillState) {
        if (autofillState is ServiceWorkReportStep1AutofillLoading ||
            (autofillState is ServiceWorkReportStep1AutofillInitial && _complaintId != null)) {
          return const StepShimmer(step: 1);
        }
        
        String currentDealer = '';
        if (autofillState is ServiceWorkReportStep1AutofillSuccess && autofillState.data.data.dealerName.isNotEmpty) {
          currentDealer = autofillState.data.data.dealerName;
        }
        
        final dealerToShow = _loggedInDealerName.isNotEmpty
            ? _loggedInDealerName
            : (currentDealer.isNotEmpty
                ? currentDealer
                : 'commissioning_dealer_name_fallback'.tr());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Service Provider Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F2F6)),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFFA5ABB7),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'create_report_service_provider'.tr(),
                    //   style: AppFont.style(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w800,
                    //     color: const Color(0xFFA5ABB7),
                    //   ),
                    // ),
                    Text(
                      dealerToShow,
                      style: AppFont.style(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'create_report_date'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                  Text(
                    '28/05/2026',
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Technician Names
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_tech_name'.tr(), isMandatory: true),
            GestureDetector(
              onTap: () {
                setState(() {
                  _technicians.add(TextEditingController());
                  _technicianIds.add(null);
                });
              },
              child: _buildAddListItemButton('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._technicians.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<TechnicianBloc, TechnicianState>(
                    bloc: _technicianBloc,
                    builder: (context, state) {
                      bool isLoading = state is TechnicianLoadingState;
                      List<dynamic> validItems = [];
                      if (state is TechnicianSuccessState) {
                        validItems = List.from(state.data.data);
                      }
                      final otherSelected = _technicians
                          .where((c) => c != controller && c.text.isNotEmpty)
                          .map((c) => c.text)
                          .toSet();
                      validItems.removeWhere(
                        (item) => otherSelected.contains(item.id),
                      );
                      if (controller.text.isNotEmpty &&
                          !validItems.any((e) => e.id == controller.text)) {
                        if (state is TechnicianSuccessState) {
                          try {
                            final match = state.data.data.firstWhere(
                              (e) => e.id == controller.text,
                            );
                            validItems.add(match);
                          } catch (_) {}
                        }
                      }
                      return Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: controller,
                            onChanged: (val) {
                              _technicianIds[idx] = ''; // Manual input, clear ID
                            },
                            decoration: InputDecoration(
                              hintText: 'commissioning_select_technician'.tr(),
                              hintStyle: AppFont.style(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFA5ABB7),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFF1565C0)),
                              ),
                              suffixIcon: isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF1565C0),
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color(0xFFA5ABB7),
                                      ),
                                      onPressed: () {
                                        _showTechnicianBottomSheet(
                                          context,
                                          validItems,
                                          controller,
                                          idx,
                                        );
                                      },
                                    ),
                            ),
                            style: AppFont.style(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (_technicians.length > 1) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        var removed = _technicians.removeAt(idx);
                        _technicianIds.removeAt(idx);
                        removed.dispose();
                      });
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD6D6)),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE53935),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 4),

        // Customer Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_customer_name'.tr(), isMandatory: true),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCustomerAddNew = !_isCustomerAddNew;
                  // Reset dropdown when switching modes
                  _isCustomerDropdownOpen = false;
                  _newCustomerController.clear();
                });
              },
              child: _isCustomerAddNew
                  ? _buildSelectExistingButton()
                  : _buildAddNewButton('create_report_add_new'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isCustomerAddNew) ...[
          // ── Add New mode: text field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _newCustomerController,
              autofocus: true,
              style: AppFont.style(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: 'Enter new customer name',
                hintStyle: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ] else ...[
          // ── Select Existing mode: dropdown
          BlocBuilder<CustomerBloc, CustomerState>(
            bloc: _customerBloc,
            builder: (context, state) {
              bool isLoading = state is CustomerLoadingState;
              if (state is CustomerSuccessState) {
                _customersList.clear();
                final apiNames = state.data.data.map((e) => e.name).toList();
                _customersList.addAll(apiNames);
              }

              List<String> validItems = List.from(_customersList);
              if (_selectedCustomer != 'Select Customer' &&
                  !validItems.contains(_selectedCustomer)) {
                validItems.add(_selectedCustomer);
              }

              return SearchableDropdown<String>(
                items: validItems,
                value: _selectedCustomer == 'Select Customer'
                    ? null
                    : _selectedCustomer,
                hintText: 'Select Customer',
                itemAsString: (item) => item,
                isLoading: isLoading,
                filterFn: (item, filter) => true,
                onSearchChanged: (v) {
                  _customerBloc.add(
                    CustomerGetEvent(search: v, page: 1, pageSize: 10),
                  );
                },
                onLoadMore: (lastSearch) {
                  if (state is CustomerSuccessState && state.data.data.length >= 10) {
                    _customerBloc.add(
                      CustomerGetEvent(search: lastSearch, page: 2, pageSize: 10),
                    );
                  }
                },
                onChanged: (val) {
                  setState(() {
                    _selectedCustomer = val ?? 'Select Customer';
                    if (val == null) {
                      _selectedCustomerId = null;
                    }
                  });
                  if (state is CustomerSuccessState && val != null) {
                    final cList = state.data.data.where((x) => x.name == val);
                    if (cList.isNotEmpty) {
                      _selectedCustomerId = cList.first.id;
                      _sitesBloc.add(SitesGetEvent(customer_id: cList.first.id));
                    }
                  }
                },
              );
            },
          ),
        ],

        const SizedBox(height: 4),

        // Site Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_site_name'.tr(), isMandatory: true),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSiteAddNew = !_isSiteAddNew;
                  // Reset dropdown when switching modes
                  _isSiteDropdownOpen = false;
                  _newSiteController.clear();
                });
              },
              child: _isSiteAddNew
                  ? _buildSelectExistingButton()
                  : _buildAddNewButton('create_report_add_new'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isSiteAddNew) ...[
          // ── Add New mode: text field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _newSiteController,
              autofocus: true,
              style: AppFont.style(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: 'Enter new site name',
                hintStyle: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ] else ...[
          // ── Select Existing mode: dropdown
          BlocBuilder<SitesBloc, SitesState>(
            bloc: _sitesBloc,
            builder: (context, state) {
              bool isLoading = state is SitesLoadingState;
              if (state is SitesSuccessState) {
                _sitesList.clear();
                final apiNames = state.data.data.map((e) => e.name).toList();
                _sitesList.addAll(apiNames);
              }

              List<String> validItems = List.from(_sitesList);
              if (_selectedSite != 'Select Site' &&
                  !validItems.contains(_selectedSite)) {
                validItems.add(_selectedSite);
              }

              return SearchableDropdown<String>(
                items: validItems,
                value: _selectedSite == 'Select Site' ? null : _selectedSite,
                hintText: 'Select Site',
                itemAsString: (item) => item,
                isLoading: isLoading,
                filterFn: (item, filter) => true,
                onSearchChanged: _selectedCustomer != 'Select Customer'
                    ? (v) {
                  String? customerId = _selectedCustomerId;
                  if ((customerId == null || customerId.isEmpty) && _customerBloc.state is CustomerSuccessState) {
                    final list =
                    (_customerBloc.state as CustomerSuccessState)
                        .data
                        .data
                        .where((x) => x.name == _selectedCustomer);
                    if (list.isNotEmpty) customerId = list.first.id;
                  }
                  if (customerId != null && customerId.isNotEmpty) {
                    _sitesBloc.add(
                      SitesGetEvent(
                        customer_id: customerId,
                        search: v,
                        page: 1,
                        pageSize: 10,
                      ),
                    );
                  }
                }
                    : null,
                onLoadMore: _selectedCustomer != 'Select Customer'
                    ? (lastSearch) {
                  // Only fetch page 2 if we actually have a full page 1
                  if (state is SitesSuccessState && state.data.data.length >= 10) {
                    String? customerId2 = _selectedCustomerId;
                    if ((customerId2 == null || customerId2.isEmpty) && _customerBloc.state is CustomerSuccessState) {
                      final list2 =
                      (_customerBloc.state as CustomerSuccessState)
                          .data
                          .data
                          .where((x) => x.name == _selectedCustomer);
                      if (list2.isNotEmpty) customerId2 = list2.first.id;
                    }
                    if (customerId2 != null && customerId2.isNotEmpty) {
                      _sitesBloc.add(
                        SitesGetEvent(
                          customer_id: customerId2,
                          search: lastSearch,
                          page: 2,
                          pageSize: 10,
                        ),
                      );
                    }
                  }
                }
                    : null,
                onChanged: (val) {
                  setState(() {
                    _selectedSite = val ?? 'Select Site';
                    if (val == null) {
                      _selectedSiteId = null;
                    }
                  });
                  if (state is SitesSuccessState && val != null) {
                    final sList = state.data.data.where((x) => x.name == val);
                    if (sList.isNotEmpty) {
                      _selectedSiteId = sList.first.id;
                    }
                  }
                },
              );
            }
          ),
        ],

        // const SizedBox(height: 32),
        //
        // // Complaint No
        // Row(
        //   children: [
        //     _buildLabel('create_report_complaint_no'.tr()),
        //     const SizedBox(width: 40),
        //     Text(
        //       ':    -',
        //       style: AppFont.style(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w900,
        //         color: const Color(0xFF0D121F),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 4),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 4),

        // Member Presents
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel('create_report_member_presents'.tr()),
            GestureDetector(
              onTap: _addMemberField,
              child: _buildAddListItemButton('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Render one row per controller
        ...List.generate(_memberControllers.length, (index) {
          final ctrl = _memberControllers[index];
          final isFirst = index == 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ctrl,
                            style: AppFont.style(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0D121F),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Member name',
                              hintStyle: AppFont.style(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFA5ABB7),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        SpeechToTextMicButton(controller: ctrl),
                      ],
                    ),
                  ),
                ),
                if (!isFirst) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _removeMemberField(index),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD6D6)),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE53935),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 4),

        // Agenda / Purpose
        _buildLabel('Agenda / Purpose Of Visit'),
        const SizedBox(height: 16),
        Container(
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F2F6)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _agendaController,
                  maxLines: null,
                  style: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D121F),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Agenda / Purpose Of Visit',
                    hintStyle: AppFont.style(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFA5ABB7),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SpeechToTextMicButton(controller: _agendaController),
              ),
            ],
          ),
        ),

        const SizedBox(height: 60),
      ],
    );
      },
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Technical Details header ────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Technical Details',
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isTechnicalNA = !_isTechnicalNA),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isTechnicalNA
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: _isTechnicalNA
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                    ),
                    child: _isTechnicalNA
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'NA',
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── All fields wrapped: inactive + non-tappable when NA is checked ──────
        IgnorePointer(
          ignoring: _isTechnicalNA,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _isTechnicalNA ? 0.38 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Pump Make ──────────────────────────────────────────────
                _buildTechLabel('Pump Make'),
                _buildUnderlineField(_pumpMakeCtrl),
                const SizedBox(height: 20),

                // ── Pump Model ─────────────────────────────────────────────
                _buildTechLabel('Pump Model'),
                _buildUnderlineField(_pumpModelCtrl),
                const SizedBox(height: 20),

                // ── Pump Serial Number ─────────────────────────────────────
                _buildTechLabel('Pump Serial Number'),
                _buildUnderlineField(_pumpSerialCtrl),
                const SizedBox(height: 20),

                // ── Pump Flow (2×2 grid) ───────────────────────────────────
                _buildTechLabel('Pump Flow'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildUnitField(_pumpFlowLpmCtrl, 'LPM')),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUnitField(_pumpFlowM3hrCtrl, 'M3/HR'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildUnitField(_pumpFlowLpsCtrl, 'LPS')),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUnitField(_pumpFlowUsgpmCtrl, 'USGPM'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Pump Head ──────────────────────────────────────────────
                _buildTechLabel('Pump Head'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildUnitField(_pumpHeadMtrCtrl, 'MTR'),
                    ),
                    const Spacer(flex: 5),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 24),

                // ── Driver Make ────────────────────────────────────────────
                _buildTechLabel('Driver Make'),
                _buildUnderlineField(_driverMakeCtrl),
                const SizedBox(height: 20),

                // ── Driver Serial Number ───────────────────────────────────
                _buildTechLabel('Driver Serial Number'),
                _buildUnderlineField(_driverSerialCtrl),
                const SizedBox(height: 20),

                // ── Rating (KW / HP) ───────────────────────────────────────
                _buildTechLabel('Rating (KW/HP)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildUnitField(_ratingKwCtrl, 'KW')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildUnitField(_ratingHpCtrl, 'HP')),
                  ],
                ),
                const SizedBox(height: 20),

                // ── RPM ────────────────────────────────────────────────────
                _buildTechLabel('RPM'),
                _buildUnderlineField(_rpmCtrl),
                const SizedBox(height: 32),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),
                const SizedBox(height: 24),

                // ── Control Panel Make ─────────────────────────────────────
                _buildTechLabel('Control Panel Make'),
                _buildUnderlineField(_panelMakeCtrl),
                const SizedBox(height: 20),

                // ── Panel Serial / Model ───────────────────────────────────
                _buildTechLabel('Panel Serial / Model'),
                _buildUnderlineField(_panelSerialCtrl),
                const SizedBox(height: 40),

                // ── Work Description ───────────────────────────────────────
                Center(
                  child: Text(
                    'Work Description',
                    style: AppFont.style(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                ...List.generate(_workDescControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, right: 8),
                          child: Text(
                            '${index + 1}.',
                            style: AppFont.style(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFA5ABB7),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Focus(
                            child: Builder(
                              builder: (ctx) {
                                final hasFocus = Focus.of(ctx).hasFocus;
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    10,
                                    10,
                                    10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F9FB),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: hasFocus
                                          ? const Color(0xFF1565C0)
                                          : const Color(0xFFF1F2F6),
                                      width: hasFocus ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              _workDescControllers[index],
                                          minLines: 3,
                                          maxLines: null,
                                          style: AppFont.style(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0D121F),
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Enter Work Description',
                                            hintStyle: AppFont.style(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFA5ABB7),
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      SpeechToTextMicButton(
                                        controller: _workDescControllers[index],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTechLabel(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(text),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildUnderlineField(
    TextEditingController ctrl, {
    String hint = '',
    bool isNumeric = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))]
          : null,
      style: AppFont.style(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF0D121F),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFont.style(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFA5ABB7),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF1F2F6)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1565C0), width: 1.5),
        ),
      ),
    );
  }

  // ── Unit field: input + unit label inside ───────────────────────
  Widget _buildUnitField(TextEditingController ctrl, String unit) {
    return Column(
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
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          style: AppFont.style(
            fontSize: 15,
            fontWeight: FontWeight.w900,
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
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ─────────────────────────────────────────────────────────────
        Text(
          'Preventive Maintenance Checklist\n(Check & Tick if Found OK / NOT OK)',
          textAlign: TextAlign.center,
          style: AppFont.style(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 28),

        // ── Mechanical Checklist ───────────────────────────────────────────────
        _buildCheckSection(
          icon: Icons.settings_outlined,
          title: 'Mechanical Checklist',
          isNA: _mechNA,
          onNATap: () => setState(() => _mechNA = !_mechNA),
          items: [
            _buildCheckItem(
              label: 'Bearing Noise / Abnormal Sound Checked:',
              selected: _bearingNoise,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _bearingNoise = v),
            ),
            _buildCheckItem(
              label: 'Vibration Checked:',
              selected: _vibration,
              options: const ['normal', 'high'],
              labels: const ['NORMAL', 'HIGH'],
              onSelect: (v) => setState(() => _vibration = v),
            ),
            _buildCheckItem(
              label: 'Mechanical Seal / Gland Leakage Checked:',
              selected: _mechSeal,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _mechSeal = v),
            ),
            _buildCheckItem(
              label: 'Pump Not Running Dry:',
              selected: _pumpDry,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _pumpDry = v),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── Pipeline / Hydraulic Checklist ────────────────────────────────────
        _buildCheckSection(
          icon: Icons.water_drop_outlined,
          title: 'Pipeline / Hydraulic Checklist',
          isNA: _pipeNA,
          onNATap: () => setState(() => _pipeNA = !_pipeNA),
          items: [
            _buildCheckItem(
              label: 'NRV / Butterfly Valve / Gate Valve Condition Checked:',
              selected: _nrvValve,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _nrvValve = v),
            ),
            _buildCheckItem(
              label: 'Strainer / Foot Valve Condition Checked:',
              selected: _strainerValve,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _strainerValve = v),
            ),
            _buildCheckItem(
              label: 'Suction Line (Air Leakage & Water Leakage Checked):',
              selected: _suctionLine,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _suctionLine = v),
            ),
            _buildCheckItem(
              label: 'Delivery Line (Air Leakage & Water Leakage Checked):',
              selected: _deliveryLine,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _deliveryLine = v),
            ),
            _buildCheckItem(
              label: 'Suction / Delivery Valve Condition Checked:',
              selected: _suctionDelivery,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _suctionDelivery = v),
            ),
            _buildCheckItem(
              label: 'Pressure Switch / Pressure Transmitter Checked:',
              selected: _pressureSwitch,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _pressureSwitch = v),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── Electrical Checklist ───────────────────────────────────────────────
        _buildCheckSection(
          icon: Icons.bolt_outlined,
          title: 'Electrical Checklist',
          isNA: _elecNA,
          onNATap: () => setState(() => _elecNA = !_elecNA),
          items: [
            _buildCheckItem(
              label: 'Electrical Faults Checked:',
              selected: _elecFaults,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _elecFaults = v),
            ),
            _buildCheckItem(
              label: 'Voltage Checked:',
              selected: _voltage,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _voltage = v),
            ),
            _buildCheckItem(
              label: 'Phase Checked:',
              selected: _phase,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _phase = v),
            ),
            _buildCheckItem(
              label: 'Current Checked:',
              selected: _current,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _current = v),
            ),
            _buildCheckItem(
              label: 'Control Panel Wiring Checked:',
              selected: _panelWiring,
              options: const ['ok', 'not_ok'],
              labels: const ['OK', 'NOT OK'],
              onSelect: (v) => setState(() => _panelWiring = v),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  // ── Checklist section wrapper (header + NA + items with disable support) ───
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
                  fontSize: 15,
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
                    'NA',
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

        // Items — disabled when NA is checked
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

  // ── Single checklist item: label + radio-style option boxes ───────────────
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
                    color: const Color(0xFF3A4152),
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
                  onTap: () => onSelect(options[i]),
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
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : const Color(0xFF6B7280),
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

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Remarks (Technician Side) ─────────────────────────────────
        Text(
          'Remarks (Technician Side) :',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        _buildRemarksBox(
          controller: _remarksTechCtrl,
          hint: 'Enter Technician Remarks',
        ),

        const SizedBox(height: 28),

        // ── Remarks (Customer Side) ──────────────────────────────────
        Text(
          'Remarks (Customer Side) :',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7180),
          ),
        ),
        const SizedBox(height: 10),
        _buildRemarksBox(
          controller: _remarksCustomerCtrl,
          hint: 'Enter Customer Remarks',
        ),

        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),

        // ── Recorded By ────────────────────────────────────────────
        Text(
          'Recorded By:',
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),

        // Technician Rep
        Text(
          'commissioning_tech_rep'.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'commissioning_name'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
            const SizedBox(width: 8),
            Expanded(
              child: SearchableDropdown<String>(
                items: _technicianNameController.text.isNotEmpty ? [_technicianNameController.text] : [],
                itemAsString: (t) => t,
                value: _technicianNameController.text.isNotEmpty ? _technicianNameController.text : null,
                onChanged: (val) {},
                hintText: 'commissioning_select_technician'.tr(),
                readOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSignatureBox(
          label: 'commissioning_sign_star'.tr(),
          placeholder: 'commissioning_tap_sign'.tr(),
          signatureFile: _technicianSignatureFile,
          existingUrl: _existingTechnicianSignatureUrl,
          onTap: () {
            _showSignatureDrawingPad(context, (file) {
              setState(() {
                _technicianSignatureFile = file;
              });
            });
          },
          onClear: () {
            setState(() {
              _technicianSignatureFile = null;
              _existingTechnicianSignatureUrl = null;
            });
          },
        ),

        const SizedBox(height: 36),

        // Customer Rep
        Text(
          'commissioning_customer_rep'.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        // Editable name field
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'commissioning_name'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _customerRepNameCtrl,
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'commissioning_enter_name'.tr(),
                  hintStyle: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA5ABB7),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD8DCE6)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF1565C0),
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSignatureBox(
          label: 'commissioning_sign_star'.tr(),
          placeholder: 'commissioning_tap_sign'.tr(),
          signatureFile: _customerSignatureFile,
          existingUrl: _existingCustomerSignatureUrl,
          onTap: () {
            _showSignatureDrawingPad(context, (file) {
              setState(() {
                _customerSignatureFile = file;
              });
            });
          },
          onClear: () {
            setState(() {
              _customerSignatureFile = null;
              _existingCustomerSignatureUrl = null;
            });
          },
        ),

        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),

        // ── Upload / Capture Work Photos ──────────────────────────────
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'commissioning_upload_work_photos'.tr(),
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Photo grid: thumbnails + Add Photo tile
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Render existing network photos
            ..._existingWorkPhotosUrls.map((url) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _existingWorkPhotosUrls.remove(url);
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            // Existing photo thumbnails
            ..._pickedPhotos.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(file.path),
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            // Add Photo tile
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    _pickedPhotos.add(file);
                  });
                }
              },
              child: CustomPaint(
                painter: _DashedBorderPainter(color: const Color(0xFFCDD0D8)),
                child: Container(
                  width: 110,
                  height: 110,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 28, color: Color(0xFFA5ABB7)),
                      const SizedBox(height: 6),
                      Text(
                        'Upload',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  setState(() {
                    _pickedPhotos.add(file);
                  });
                }
              },
              child: CustomPaint(
                painter: _DashedBorderPainter(color: const Color(0xFFCDD0D8)),
                child: Container(
                  width: 110,
                  height: 110,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFFA5ABB7)),
                      const SizedBox(height: 6),
                      Text(
                        'Capture',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildRemarksBox({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 4,
              maxLines: null,
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0D121F),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA5ABB7),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SpeechToTextMicButton(controller: controller),
        ],
      ),
    );
  }
  Widget _buildLabel(String text, {bool isMandatory = false}) {
    return _buildSectionTitle(text, isMandatory: isMandatory);
  }

  Widget _buildSectionTitle(String title, {bool isMandatory = false}) {
    return Row(
      children: [
        Text(
          title,
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF5C6672),
          ),
        ),
        if (isMandatory)
          Text(
            ' *',
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE53935),
            ),
          ),
      ],
    );
  }

  Widget _buildAddNewButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 16, color: Color(0xFF1565C0)),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddListItemButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, size: 16, color: Color(0xFF1565C0)),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectExistingButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.list, size: 16, color: Color(0xFF1565C0)),
          const SizedBox(width: 4),
          Text(
            'Select Existing',
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureBox({
    required String label,
    required String placeholder,
    File? signatureFile,
    String? existingUrl,
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
            onTap: (signatureFile == null &&
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
                              appSnackBar(
                                  context,
                                  const Color(0xFFF44336),
                                  'commissioning_please_draw_signature'.tr());
                              return;
                            }
                            final bytes = await signatureController.toPngBytes();
                            if (bytes != null) {
                              final tempDir = await getTemporaryDirectory();
                              final file = File(
                                '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
                              );
                              await file.writeAsBytes(bytes);
                              onSignatureDrawn(file);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
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
