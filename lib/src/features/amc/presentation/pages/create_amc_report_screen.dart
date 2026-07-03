import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:service_app/src/core/network/network_checker.dart';
import 'package:service_app/src/core/database/offline_amc_reports_db.dart';
import 'package:service_app/src/features/offline/domain/services/offline_amc_sync_service.dart';
import 'package:service_app/src/features/widgets/app_alert_dialogue_widget.dart';
import 'package:service_app/src/core/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/src/features/widgets/app_add_new_text_button_widget.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step1_usecase.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step1_bloc/amc_report_step1_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step1_bloc/amc_report_step1_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step1_bloc/amc_report_step1_state.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step1_autofill_bloc/amc_report_step1_autofill_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step1_autofill_bloc/amc_report_step1_autofill_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step1_autofill_bloc/amc_report_step1_autofill_state.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_autofill_bloc/amc_report_step2_autofill_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_assigned_technicians_bloc/amc_assigned_technicians_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_assigned_technicians_bloc/amc_assigned_technicians_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_assigned_technicians_bloc/amc_assigned_technicians_state.dart';
import 'package:service_app/src/remote/models/amc_report_model/amc_assigned_technicians_response.dart';
import 'dart:convert';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/features/widgets/step_shimmer.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_bloc/amc_report_step2_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_bloc/amc_report_step2_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_bloc/amc_report_step2_state.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step3_bloc/amc_report_step3_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step3_bloc/amc_report_step3_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step3_bloc/amc_report_step3_state.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_autofill_bloc/amc_report_step2_autofill_bloc.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_autofill_bloc/amc_report_step2_autofill_event.dart';
import 'package:service_app/src/features/amc/bloc/amc_report_step2_autofill_bloc/amc_report_step2_autofill_state.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step2_usecase.dart';
import 'package:service_app/src/features/amc/domain/usecase/post_amc_report_step3_usecase.dart';
import 'package:service_app/src/core/theme/app_color.dart';
class CreateAmcReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final String visitId;
  final String? reportId;
  final String customerName;
  final String siteName;
  final int initialStepNo;

  const CreateAmcReportScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
    required this.visitId,
    this.reportId,
    this.customerName = '',
    this.siteName = '',
    this.initialStepNo = 0,
  });

  @override
  State<CreateAmcReportScreen> createState() => _CreateAmcReportScreenState();
}

class _CreateAmcReportScreenState extends State<CreateAmcReportScreen> {
  int _currentStep = 1;
  bool _isLoading = false;
  bool _isAutofillLoading = false;
  bool _hasFetchedStep2Autofill = false;

  String _dealerName = '';
  String _customerName = '';
  String _siteName = '';

  late final AmcReportStep1Bloc _step1Bloc;
  late final AmcReportStep1AutofillBloc _step1AutofillBloc;
  late final AmcReportStep2Bloc _step2Bloc;
  late final AmcReportStep2AutofillBloc _step2AutofillBloc;
  late final AmcReportStep3Bloc _step3Bloc;
  late final TechnicianBloc _technicianBloc;
  late final AmcAssignedTechniciansBloc _assignedTechniciansBloc;

  String? _currentReportId;

  // Step 2 variables
  bool _mechNA = false;
  bool _pipeNA = false;
  bool _elecNA = false;
  bool _operationNA = false;
  List<String> _mechanicalSelected = [];
  List<String> _pipelineSelected = [];
  List<String> _electricalSelected = [];
  List<String> _operationSelected = [];
  String? _vibrationSelected;

  final List<TextEditingController> _technicians = [TextEditingController()];
  final List<String?> _technicianIds = [null];
  final List<TextEditingController> _memberPresentsControllers = [TextEditingController()];
  final TextEditingController _agendaController = TextEditingController();

  // Step 3 variables
  final _technicianRemarksController = TextEditingController();
  final _customerRemarksController = TextEditingController();
  final _customerRepNameController = TextEditingController();
  String? _selectedTechnicianRepId;
  String? _loggedInTechnicianId;
  String _loggedInDealerName = '';
  File? _technicianSignatureFile;
  File? _customerSignatureFile;
  String? _existingTechnicianSignatureUrl;
  String? _existingCustomerSignatureUrl;
  final List<File> _workPhotos = [];
  List<String> _existingWorkPhotosUrls = [];

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStepNo > 0 ? widget.initialStepNo : 1;
    _loadSession();
    _currentReportId = widget.reportId;
    _step1Bloc = getIt<AmcReportStep1Bloc>();
    _step1AutofillBloc = getIt<AmcReportStep1AutofillBloc>();
    _step2Bloc = getIt<AmcReportStep2Bloc>();
    _step2AutofillBloc = getIt<AmcReportStep2AutofillBloc>();
    _step3Bloc = getIt<AmcReportStep3Bloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
    _assignedTechniciansBloc = getIt<AmcAssignedTechniciansBloc>();

    _initCurrentStep();
  }

  @override
  void dispose() {
    for (var c in _memberPresentsControllers) {
      c.dispose();
    }
    _agendaController.dispose();
    _technicianRemarksController.dispose();
    _customerRemarksController.dispose();
    _customerRepNameController.dispose();
    _technicianBloc.close();
    _step1Bloc.close();
    _step1AutofillBloc.close();
    _step2AutofillBloc.close();
    _assignedTechniciansBloc.close();
    _step2Bloc.close();
    _step3Bloc.close();
    for (var c in _technicians) {
      c.dispose();
    }
    _technicianIds.clear();
    super.dispose();
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onSubmit();
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
                    'amc_report_feedback'.tr(),
                    textAlign: TextAlign.center,
                    style: AppFont.style(
                      fontSize: 20,
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
                    'Report submitted successfully!',
                    textAlign: TextAlign.center,
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5C6672),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      'ok'.tr(),
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
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

  Future<void> _loadSession() async {
    final session = await SessionManager.getUserSession();
    if (session != null) {
      if (mounted) {
        setState(() {
          if (session.technician != null) {
            _loggedInTechnicianId = session.technician!.id;
          } else if (session.dealer != null) {
            _loggedInTechnicianId = session.dealer!.id;
          }
          if (session.dealer != null) {
            _loggedInDealerName = session.dealer!.name;
          }
        });
      }
    }
  }

  Future<void> _initCurrentStep() async {
    int step = await OfflineAmcReportsDb.instance.getInitialStep(widget.visitId);
    await _loadStepDataFromDb();
    if (mounted) {
      setState(() {
        _currentStep = step;
      });
      final report = await OfflineAmcReportsDb.instance.getReportByWorkId(widget.visitId);
      if (report != null && report['report_id'] != null) {
        _currentReportId = report['report_id'];
      }
      if (_currentStep == 1) {
        if (report == null) {
          _step1AutofillBloc.add(GetAmcReportStep1AutofillEvent(widget.visitId));
        }
      }
    }
  }

  Future<void> _loadStepDataFromDb() async {
    final report = await OfflineAmcReportsDb.instance.getReportByWorkId(widget.visitId);
    if (report == null) return;

    if (mounted) {
      setState(() {
        // Step 1
        if (report['step1'] != null) {
          try {
            final Map<String, dynamic> step1 = jsonDecode(report['step1']);
            if (step1['technicianIds'] != null) {
              final List<dynamic> techs = step1['technicianIds'];
              _technicians.clear();
              _technicianIds.clear();
              for (var t in techs) {
                _technicians.add(TextEditingController(text: t['name']?.toString() ?? ''));
                _technicianIds.add(t['id']?.toString());
              }
              if (_technicians.isEmpty) {
                _technicians.add(TextEditingController());
                _technicianIds.add(null);
              }
            }
            if (step1['memberPresentsCustomerSide'] != null) {
              final String members = step1['memberPresentsCustomerSide'].toString();
              if (members.isNotEmpty) {
                _memberPresentsControllers.clear();
                for (var m in members.split(', ')) {
                  _memberPresentsControllers.add(TextEditingController(text: m));
                }
              }
            }
            if (step1['agenda'] != null) {
              _agendaController.text = step1['agenda'].toString();
            }
          } catch (e) {
            print("Error parsing AMC step1: $e");
          }
        }

        // Step 2
        if (report['step2'] != null) {
          try {
            final Map<String, dynamic> step2 = jsonDecode(report['step2']);
            _mechNA = step2['isMechanicalChecklistNa'] == true;
            _pipeNA = step2['isPipelineHydraulicChecklistNa'] == true;
            _elecNA = step2['isElectricalChecklistNa'] == true;
            _operationNA = step2['operationChecklistNa'] == true;

            List<String> mapToList(String? jsonStr) {
              if (jsonStr == null || jsonStr.isEmpty) return [];
              try {
                final map = jsonDecode(jsonStr) as Map<String, dynamic>;
                return map.keys.toList();
              } catch (_) {
                return [];
              }
            }

            _mechanicalSelected = mapToList(step2['mechanicalChecklist']);
            _pipelineSelected = mapToList(step2['pipelineHydraulicChecklist']);
            _electricalSelected = mapToList(step2['electricalChecklist']);
            _operationSelected = mapToList(step2['operationChecklist']);

            if (!_mechNA && step2['mechanicalChecklist'] != null) {
              try {
                final map = jsonDecode(step2['mechanicalChecklist']) as Map<String, dynamic>;
                final vibrationKey = map.keys.firstWhere(
                  (k) => k.toLowerCase().contains('vibration'),
                  orElse: () => '',
                );
                if (vibrationKey.isNotEmpty) {
                  _vibrationSelected = map[vibrationKey]?.toString().toUpperCase();
                }
              } catch (_) {}
            }
          } catch (e) {
            print("Error parsing AMC step2: $e");
          }
        }

        // Step 3
        if (report['step3'] != null) {
          try {
            final Map<String, dynamic> step3 = jsonDecode(report['step3']);
            _technicianRemarksController.text = step3['technicianRemarks']?.toString() ?? '';
            _customerRemarksController.text = step3['customerRemarks']?.toString() ?? '';
            _customerRepNameController.text = step3['customerRepresentativeName']?.toString() ?? '';
            _selectedTechnicianRepId = step3['technicianRepresentative']?.toString();

            if (step3['technicianSignaturePath'] != null) {
              final path = step3['technicianSignaturePath'].toString();
              if (path.isNotEmpty) {
                _technicianSignatureFile = File(path);
              }
            }
            if (step3['customerSignaturePath'] != null) {
              final path = step3['customerSignaturePath'].toString();
              if (path.isNotEmpty) {
                _customerSignatureFile = File(path);
              }
            }
            if (step3['workPhotosPaths'] != null) {
              final List<dynamic> paths = step3['workPhotosPaths'];
              _workPhotos.clear();
              for (var p in paths) {
                if (p.toString().isNotEmpty) {
                  _workPhotos.add(File(p.toString()));
                }
              }
            }
          } catch (e) {
            print("Error parsing AMC step3: $e");
          }
        }
      });
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
                          hintText: 'search'.tr(),
                          hintStyle: AppFont.style(
                            fontSize: 12,
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
                          fontSize: 12,
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
                                FocusManager.instance.primaryFocus?.unfocus();
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
                                    fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AmcReportStep1Bloc, AmcReportStep1State>(
          bloc: _step1Bloc,
          listener: (context, state) {
            if (state is AmcReportStep1LoadingState) {
              setState(() => _isLoading = true);
            } else {
              setState(() => _isLoading = false);
            }

            if (state is AmcReportStep1SuccessState) {
              _currentReportId = state.data.data.id;
              
              final List<Map<String, dynamic>> selectedTechs = [];
              for (int i = 0; i < _technicians.length; i++) {
                var controller = _technicians[i];
                if (controller.text.isNotEmpty) {
                  selectedTechs.add({"id": _technicianIds[i] ?? "", "name": controller.text});
                }
              }

              OfflineAmcReportsDb.instance.saveStep(
                _currentReportId ?? "",
                widget.visitId,
                1,
                {
                  "technicianIds": selectedTechs,
                  "memberPresentsCustomerSide": _memberPresentsControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).join(", "),
                  "agenda": _agendaController.text,
                },
                reportState: 'online',
              );

              _assignedTechniciansBloc.add(GetAmcAssignedTechniciansEvent(_currentReportId!));

              setState(() => _currentStep++);
              if (_currentReportId != null && !_hasFetchedStep2Autofill) {
                _hasFetchedStep2Autofill = true;
                _step2AutofillBloc.add(GetAmcReportStep2AutofillEvent(_currentReportId!));
              }
              appSnackBar(
                context, AppColor.green,
                state.data.message,
              );
            } else if (state is AmcReportStep1FailureState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
        BlocListener<AmcReportStep1AutofillBloc, AmcReportStep1AutofillState>(
          bloc: _step1AutofillBloc,
          listener: (context, state) {
            if (state is AmcReportStep1AutofillLoadingState) {
              setState(() => _isAutofillLoading = true);
            } else {
              setState(() => _isAutofillLoading = false);
            }

            if (state is AmcReportStep1AutofillSuccessState) {
              setState(() {
                _dealerName = state.data.data.dealerName;
                _customerName = state.data.data.customerName;
                _siteName = state.data.data.siteName;
              });
              if (state.data.data.memberPresentsCustomerSide.isNotEmpty) {
                _memberPresentsControllers.clear();
                for (var name in state.data.data.memberPresentsCustomerSide.split(',')) {
                  if (name.trim().isNotEmpty) {
                    _memberPresentsControllers.add(TextEditingController(text: name.trim()));
                  }
                }
                if (_memberPresentsControllers.isEmpty) {
                  _memberPresentsControllers.add(TextEditingController());
                }
              } else {
                _memberPresentsControllers.first.text = '';
              }
              _agendaController.text = state.data.data.agenda;
              if (widget.reportId != null) {
                if (state.data.data.assignedTechnicians.isNotEmpty) {
                  _technicians.clear();
                  _technicianIds.clear();
                  for (var tech in state.data.data.assignedTechnicians) {
                    _technicians.add(TextEditingController(text: tech.name));
                    _technicianIds.add(tech.id);
                  }
                }
              }
              if (_technicians.isEmpty) {
                _technicians.add(TextEditingController());
                _technicianIds.add(null);
              }

              if (widget.reportId != null && _currentReportId == null && state.data.data.id.isNotEmpty) {
                _currentReportId = state.data.data.id;
              }

            } else if (state is AmcReportStep1AutofillFailureState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
        BlocListener<AmcReportStep2Bloc, AmcReportStep2State>(
          bloc: _step2Bloc,
          listener: (context, state) {
            if (state is AmcReportStep2LoadingState) {
              setState(() => _isLoading = true);
            } else {
              setState(() => _isLoading = false);
            }

            if (state is AmcReportStep2SuccessState) {
              setState(() => _currentStep++);
              if (_currentReportId != null) {
                _assignedTechniciansBloc.add(GetAmcAssignedTechniciansEvent(_currentReportId!));
              }
              appSnackBar(
                context, AppColor.green,
                state.data.message,
              );
            } else if (state is AmcReportStep2ErrorState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
        BlocListener<AmcReportStep2AutofillBloc, AmcReportStep2AutofillState>(
          bloc: _step2AutofillBloc,
          listener: (context, state) {
            if (state is AmcReportStep2AutofillLoadingState) {
              setState(() => _isAutofillLoading = true);
            } else {
              setState(() => _isAutofillLoading = false);
            }

            if (state is AmcReportStep2AutofillSuccessState) {
              setState(() {
                _mechNA = state.data.data.isMechanicalChecklistNa;
                _pipeNA = state.data.data.isPipelineHydraulicChecklistNa;
                _elecNA = state.data.data.isElectricalChecklistNa;
                _operationNA = state.data.data.operationChecklistNa;

                List<String> decodeMapToList(String s) {
                  if (s.isEmpty) return [];
                  try {
                    Map<String, dynamic> map = jsonDecode(s);
                    List<String> list = [];
                    map.forEach((key, value) {
                      if (key == 'vibration_check'.tr()) return; // Handled separately
                      if (value == 'ok'.tr()) {
                        list.add('$key :');
                      }
                    });
                    return list;
                  } catch (_) {
                    return [];
                  }
                }

                try {
                  if (state.data.data.mechanicalChecklist.isNotEmpty) {
                    Map<String, dynamic> map = jsonDecode(state.data.data.mechanicalChecklist);
                    if (map.containsKey('vibration_check'.tr())) {
                      _vibrationSelected = map['vibration_check'.tr()].toString().toUpperCase();
                    }
                  }
                } catch (_) {}
                _mechanicalSelected = decodeMapToList(state.data.data.mechanicalChecklist);

                _pipelineSelected = decodeMapToList(state.data.data.pipelineHydraulicChecklist);
                _electricalSelected = decodeMapToList(state.data.data.electricalChecklist);
                _operationSelected = decodeMapToList(state.data.data.operationChecklist);
              });
            } else if (state is AmcReportStep2AutofillFailureState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
        BlocListener<AmcReportStep3Bloc, AmcReportStep3State>(
          bloc: _step3Bloc,
          listener: (context, state) {
            if (state is AmcReportStep3LoadingState) {
              setState(() => _isLoading = true);
            } else {
              setState(() => _isLoading = false);
            }

            if (state is AmcReportStep3SuccessState) {
              appSnackBar(context, AppColor.green, state.data.message);
              OfflineAmcReportsDb.instance.deleteReport(_currentReportId ?? "");
              widget.onSubmit();
            } else if (state is AmcReportStep3ErrorState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
        BlocListener<AmcAssignedTechniciansBloc, AmcAssignedTechniciansState>(
          bloc: _assignedTechniciansBloc,
          listener: (context, state) async {
            if (state is AmcAssignedTechniciansSuccessState) {
              final assignedList = state.data.data;
              if (assignedList.isEmpty) return;

              final loggedInTech = assignedList.firstWhere(
                (tech) => tech.technicianId == _loggedInTechnicianId,
                orElse: () => assignedList.first,
              );

              if (loggedInTech.assignId.isNotEmpty) {
                await OfflineAmcReportsDb.instance.updateAssignId(
                  widget.visitId,
                  _currentReportId ?? '',
                  loggedInTech.assignId,
                );
                setState(() {
                  _selectedTechnicianRepId = loggedInTech.assignId;
                });
                print('✅ AMC assign_id saved to DB: ${loggedInTech.assignId}');
              }
            } else if (state is AmcAssignedTechniciansFailureState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
        BlocListener<TechnicianBloc, TechnicianState>(
          bloc: _technicianBloc,
          listener: (context, state) {
            if (state is TechnicianFailureState) {
              appSnackBar(context, AppColor.bright_red, state.message);
            }
          },
        ),
      ],
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────────
        _buildHeader(),

        // ── Progress Bar ──────────────────────────────────────────────────
        _buildProgress(),

        // ── Scrollable Body ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _currentStep == 1
                ? _buildStep1()
                : _currentStep == 2
                ? _buildStep2()
                : _buildStep3(),
          ),
        ),

        // ── Bottom Navigation ─────────────────────────────────────────────
        _buildBottomNav(),
      ],
    ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
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
              onPressed: widget.onBack,
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
              'amc_report_title'.tr(),
              style: AppFont.style(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        Expanded(child: Container(height: 4, color: const Color(0xFF1565C0))),
        const SizedBox(width: 2),
        Expanded(
          child: Container(
            height: 4,
            color: _currentStep >= 2
                ? const Color(0xFF1565C0)
                : const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Container(
            height: 4,
            color: _currentStep >= 3
                ? const Color(0xFF1565C0)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    if (_isAutofillLoading) {
      return const StepShimmer(step: 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header Row ────────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Container(
            //   width: 44,
            //   height: 44,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFF9FAFB),
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: const Color(0xFFE5E7EB)),
            //   ),
            //   child: const Icon(
            //     Icons.business_outlined,
            //     color: Color(0xFFCDD0D8),
            //   ),
            // ),
            // const SizedBox(width: 12),
            // Expanded(
            //   child: BlocBuilder<AmcReportStep1AutofillBloc, AmcReportStep1AutofillState>(
            //     bloc: _step1AutofillBloc,
            //     builder: (context, state) {
            //       String currentDealer = '';
            //       if (state is AmcReportStep1AutofillSuccessState && state.data.data.dealerName.isNotEmpty) {
            //         currentDealer = state.data.data.dealerName;
            //       }
            //
            //       final dealerToShow = _loggedInDealerName.isNotEmpty
            //           ? _loggedInDealerName
            //           : (currentDealer.isNotEmpty
            //               ? currentDealer
            //               : 'commissioning_dealer_name_fallback'.tr());
            //
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           if (dealerToShow.isNotEmpty)
            //             Text(
            //               dealerToShow,
            //               style: AppFont.style(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w900,
            //                 color: const Color(0xFF0D121F),
            //               ),
            //             ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'amc_report_date_label'.tr(),
                  style: AppFont.style(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7A8699),
                  ),
                ),
                Text(
                  DateFormat('d MMMM yyyy', context.locale.languageCode).format(DateTime.now()),
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
              ],
            ),
          ],
        ),


        const SizedBox(height: 32),

        // ── Technician Name(s) ─────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('amc_report_technician_names'.tr(), isMandatory: true),
            AppAddNewTextButtonWidget(
              onPressed: () {
                setState(() {
                  _technicians.add(TextEditingController());
                  _technicianIds.add(null);
                });
              },
            )
          ],
        ),
        const SizedBox(height: 16),
        ..._technicians.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
                                fontSize: 14,
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
                              fontSize: 14,
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

        const SizedBox(height: 32),

        // ── Customer Info Rows ─────────────────────────────────────────────
        BlocBuilder<AmcReportStep1AutofillBloc, AmcReportStep1AutofillState>(
          bloc: _step1AutofillBloc,
          builder: (context, state) {
            String currentCustomer = widget.customerName;
            String currentSite = widget.siteName;
            
            if (state is AmcReportStep1AutofillSuccessState) {
              if (state.data.data.customerName.isNotEmpty) currentCustomer = state.data.data.customerName;
              if (state.data.data.siteName.isNotEmpty) currentSite = state.data.data.siteName;
            }
            
            return Column(
              children: [
                if (currentCustomer.isNotEmpty) ...[
                  _buildInfoRow('amc_report_customer_name'.tr(), currentCustomer),
                  const SizedBox(height: 24),
                ],
                if (currentSite.isNotEmpty)
                  _buildInfoRow('amc_report_site_name'.tr(), currentSite),
              ],
            );
          },
        ),

        const SizedBox(height: 32),

        // ── Member Presents ───────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('amc_report_member_presents'.tr()),
            AppAddNewTextButtonWidget(
              onPressed: () {
                setState(() {
                  _memberPresentsControllers.add(TextEditingController());
                });
              },
            )
          ],
        ),
        const SizedBox(height: 12),
        ..._memberPresentsControllers.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'amc_report_member_presents_hint'.tr(),
                    showMic: true,
                    controller: controller,
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                if (_memberPresentsControllers.length > 1) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        var removed = _memberPresentsControllers.removeAt(idx);
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

        const SizedBox(height: 32),

        // ── Agenda / Purpose ──────────────────────────────────────────────
        _buildSectionTitle('amc_report_agenda'.tr()),
        const SizedBox(height: 12),
        _buildTextArea('amc_report_agenda_hint'.tr(), controller: _agendaController),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStep2() {
    if (_isAutofillLoading) {
      return const StepShimmer(step: 2);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'amc_report_checklist_title'.tr(),
          style: AppFont.style(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),

        _buildChecklistCard('checklist_mech_title'.tr(), Icons.settings_outlined, [
          _buildChecklistItem('pump_foundation_bolt_tight'.tr(), _mechanicalSelected),
          _buildChecklistItem('coupling_alignment_checked'.tr(), _mechanicalSelected),
          _buildChecklistItem('bearing_noise_checked'.tr(), _mechanicalSelected),
          _buildChecklistItem('abnormal_sound_checked'.tr(), _mechanicalSelected),
          _buildChecklistItem('mechanical_seal_gland_leakage_checked'.tr(), _mechanicalSelected),
          _buildVibrationItem(),
          _buildChecklistItem('pump_cleaned'.tr(), _mechanicalSelected),
          _buildChecklistItem('pump_not_running_dry'.tr(), _mechanicalSelected, isLast: true),
        ], _mechNA, () => setState(() => _mechNA = !_mechNA)),
        const SizedBox(height: 32),

        _buildChecklistCard('checklist_pipe_title'.tr(), Icons.water_drop_outlined, [
          _buildChecklistItem("suction_line_leakage_checked".tr(), _pipelineSelected),
          _buildChecklistItem("delivery_line_leakage_checked".tr(), _pipelineSelected),
          _buildChecklistItem("valve_working_checked".tr(), _pipelineSelected),
          _buildChecklistItem("strainer_cleaned".tr(), _pipelineSelected),
          _buildChecklistItem("valve_condition_checked".tr(), _pipelineSelected),
          _buildChecklistItem("pressure_switch_checked".tr(), _pipelineSelected, isLast: true),
        ], _pipeNA, () => setState(() => _pipeNA = !_pipeNA)),
        const SizedBox(height: 32),

        _buildChecklistCard('checklist_elec_title'.tr(), Icons.bolt_outlined, [
          _buildChecklistItem("panel_cleaned".tr(), _electricalSelected),
          _buildChecklistItem("contactor_relay_checked".tr(), _electricalSelected),
          _buildChecklistItem("overload_setting_checked".tr(), _electricalSelected),
          _buildChecklistItem("loose_wiring_checked".tr(), _electricalSelected),
          _buildChecklistItem("phase_voltage_current_checked".tr(), _electricalSelected),
          _buildChecklistItem("earthing_checked".tr(), _electricalSelected, isLast: true),
        ], _elecNA, () => setState(() => _elecNA = !_elecNA)),
        const SizedBox(height: 32),

        _buildChecklistCard('checklist_pump_title'.tr(), Icons.monitor_heart_outlined, [
          _buildChecklistItem("pump_started_manual".tr(), _operationSelected),
          _buildChecklistItem("auto_operation_checked".tr(), _operationSelected),
          _buildChecklistItem("water_flow_pressure_checked".tr(), _operationSelected),
          _buildChecklistItem("rotation_direction_checked".tr(), _operationSelected, isLast: true),
        ], _operationNA, () => setState(() => _operationNA = !_operationNA)),
      ],
    );
  }

  Widget _buildChecklistCard(String title, IconData icon, List<Widget> items, bool isNA, VoidCallback onNATap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF0D121F), size: 20),
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
            GestureDetector(
              onTap: onNATap,
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isNA ? const Color(0xFF1565C0) : Colors.white,
                      border: Border.all(
                        color: isNA ? const Color(0xFF1565C0) : const Color(0xFFCDD0D8),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: isNA ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'commissioning_na_paren'.tr(),
                    style: AppFont.style(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF7A8699),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        IgnorePointer(
          ignoring: isNA,
          child: Opacity(
            opacity: isNA ? 0.5 : 1.0,
            child: Column(children: items),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String text, List<String> selectedList, {bool isLast = false}) {
    bool isSelected = selectedList.contains(text);
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedList.remove(text);
            } else {
              selectedList.add(text);
            }
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text.tr(),
                      style: AppFont.style(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF5C6672),
                      ),
                    ),
                     TextSpan(
                      text: 'asterisk'.tr(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1565C0) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFCDD0D8),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVibrationItem() {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'checklist_vibration'.tr() + " :",
                    style: AppFont.style(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5C6672),
                    ),
                  ),
                   TextSpan(
                    text: 'asterisk'.tr(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _vibrationSelected = 'normal'.tr()),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _vibrationSelected == 'normal'.tr() ? const Color(0xFF1565C0) : Colors.white,
                        border: Border.all(
                          color: _vibrationSelected == 'normal'.tr() ? const Color(0xFF1565C0) : const Color(0xFFCDD0D8),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _vibrationSelected == 'normal'.tr() ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'normal'.tr(),
                      style: AppFont.style(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF5C6672),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => setState(() => _vibrationSelected = 'high'.tr()),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _vibrationSelected == 'high'.tr() ? const Color(0xFF1565C0) : Colors.white,
                        border: Border.all(
                          color: _vibrationSelected == 'high'.tr() ? const Color(0xFF1565C0) : const Color(0xFFCDD0D8),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _vibrationSelected == 'high'.tr() ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'high'.tr(),
                      style: AppFont.style(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF5C6672),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Remarks (Technician Side) ─────────────────────────────────
        Text(
          'commissioning_remarks_tech'.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        _buildRemarksBox(
          'enter_technical_remark'.tr(),
          _technicianRemarksController,
        ),
        const SizedBox(height: 28),
        // ── Remarks (Customer Side) ──────────────────────────────────
        Text(
          'commissioning_remarks_customer'.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7180),
          ),
        ),
        const SizedBox(height: 10),
        _buildRemarksBox(
          'enter_customer_remark'.tr(),
          _customerRemarksController,
        ),
        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),
        // ── Recorded By ────────────────────────────────────────────
        Text(
          'amc_report_recorded_by'.tr(),
          style: AppFont.style(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),
        // Technician Rep
        Text(
          'amc_report_technician_rep'.tr(),
          style: AppFont.style(
            fontSize: 9,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: 12,
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
              child: BlocBuilder<AmcAssignedTechniciansBloc, AmcAssignedTechniciansState>(
                bloc: _assignedTechniciansBloc,
                builder: (context, state) {
                  bool isLoading = state is AmcAssignedTechniciansLoadingState;
                  List<dynamic> validItems = [];
                  if (state is AmcAssignedTechniciansSuccessState) {
                    validItems = List.from(state.data.data);
                    // Ensure the logged-in technician is auto-selected if possible
                    if (_selectedTechnicianRepId == null && _loggedInTechnicianId != null) {
                      final matched = validItems.where((e) => e.technicianId == _loggedInTechnicianId).firstOrNull;
                      if (matched != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _selectedTechnicianRepId = matched.assignId;
                            });
                          }
                        });
                      }
                    }
                  }
                  return IgnorePointer(
                    ignoring: true,
                    child: SearchableDropdown<dynamic>(
                      showArrow: false,
                      items: validItems,
                      value: _selectedTechnicianRepId != null
                          ? validItems.firstWhere(
                              (e) => e.assignId == _selectedTechnicianRepId,
                              orElse: () => null,
                            )
                          : null,
                      hintText: 'commissioning_select_technician'.tr(),
                      itemAsString: (item) => item.name,
                      isLoading: isLoading,
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _selectedTechnicianRepId = v.assignId);
                        }
                      },
                    ),
                  );
                },
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
          'amc_report_customer_rep'.tr(),
          style: AppFont.style(
            fontSize: 9,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: 12,
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
                controller: _customerRepNameController,
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'commissioning_enter_name'.tr(),
                  hintStyle: AppFont.style(
                    fontSize: 13,
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
                text: 'amc_report_upload_photos'.tr(),
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
               TextSpan(
                text: 'asterisk'.tr(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ..._existingWorkPhotosUrls.map((url) {
              return Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
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
              );
            }),
            ..._workPhotos.map((file) {
              return Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _workPhotos.remove(file);
                        });
                      },
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
              );
            }),
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final List<XFile> files = await picker.pickMultiImage();
                if (files.isNotEmpty) {
                  setState(() {
                    _workPhotos.addAll(files.map((e) => File(e.path)));
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
                        'upload'.tr(),
                        style: AppFont.style(
                          fontSize: 10,
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
                    _workPhotos.add(File(file.path));
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
                        'capture'.tr(),
                        style: AppFont.style(
                          fontSize: 10,
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
        const SizedBox(height: 40),
      ],
    );
  }

  Future<void> _showSignatureDrawingPad(
    BuildContext context,
    Function(File) onSignatureDrawn,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
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
                          fontSize: 14,
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
                                  fontSize: 10,
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              onSignatureDrawn(file);
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
                                  fontSize: 10,
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
    ).then((_) => signatureController.dispose());
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
            maxLines: 4,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: AppFont.style(
                fontSize: 14,
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
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8E9BAE),
                    ),
                    children: [
                      TextSpan(
                        text: 'asterisk'.tr(),
                        style: AppFont.style(
                          fontSize: 12,
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
                    fontSize: 12,
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
                              fontSize: 12,
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

  Widget _buildSectionTitle(String title, {bool isMandatory = false}) {
    if (!isMandatory) {
      return Text(
        title,
        style: AppFont.style(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF5C6672),
        ),
      );
    }
    
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: AppFont.style(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
        ),
        Text(
          ':',
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String hint, {
    bool showMic = false,
    TextEditingController? controller,
    IconData? prefixIcon,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: const Color(0xFF5C616E), size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
          ),
          if (showMic && controller != null)
            SpeechToTextMicButton(controller: controller),
        ],
      ),
    );
  }

  Widget _buildTextArea(String hint, {TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFA5ABB7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D121F),
            ),
          ),
          if (controller != null)
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

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              if (_currentStep == 1) {
                widget.onBack();
              } else {
                setState(() => _currentStep--);
                if (_currentReportId != null) {
                  if (_currentStep == 1) {
                    _step1AutofillBloc.add(GetAmcReportStep1AutofillEvent(widget.visitId));
                  } else if (_currentStep == 2) {
                    _step2AutofillBloc.add(GetAmcReportStep2AutofillEvent(_currentReportId!));
                  }
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentStep > 1) ...[
                  const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: Color(0xFFA5ABB7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'amc_report_btn_back'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ] else
                  Text(
                    'cancel'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _isLoading
                ? null
                : () async {
                    if (_currentStep == 1) {
                      List<Map<String, dynamic>> selectedTechs = [];
                      List<dynamic> allTechs = [];
                      if (_technicianBloc.state is TechnicianSuccessState) {
                        allTechs = (_technicianBloc.state as TechnicianSuccessState).data.data;
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
                          selectedTechs.add({"id": id, "name": name});
                        }
                      }
                      if (selectedTechs.isEmpty) {
                        appSnackBar(
                          context,
                          AppColor.bright_red,
                          'assign_tech_validation_msg'.tr(),
                        );
                        return;
                      }

                      final step1Data = {
                        "technicianIds": selectedTechs,
                        "memberPresentsCustomerSide": _memberPresentsControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).join(", "),
                        "agenda": _agendaController.text,
                      };
                      setState(() => _isLoading = true);
                      bool isOnline = await NetworkInfo().checkIsConnected;
                      if (_currentStep == 1) {
                        isOnline = true; // Always call API on AMC report step 1, bypass internet check
                      }
                      await OfflineAmcReportsDb.instance.saveStep(
                        _currentReportId ?? "",
                        widget.visitId,
                        1,
                        step1Data,
                      );
                      if (!isOnline) {
                        setState(() {
                          _isLoading = false;
                          _currentReportId = widget.visitId;
                          _currentStep++;
                        });
                        appSnackBar(context, AppColor.green, "Saved offline locally");
                      } else {
                        _step1Bloc.add(PostAmcReportStep1Event(PostAmcReportStep1Params(
                          amcVisitId: widget.visitId,
                          amcReportId: _currentReportId,
                          technicianIds: selectedTechs,
                          memberPresentsCustomerSide: _memberPresentsControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).join(", "),
                          agenda: _agendaController.text,
                        )));
                      }
                    } else if (_currentStep == 2) {
                      final isOnline = await NetworkInfo().checkIsConnected;
                      if (_currentReportId == null) {
                        if (!isOnline) {
                          _currentReportId = widget.visitId;
                        } else {
                          appSnackBar(context, AppColor.bright_red, 'report_id_is_missing'.tr());
                          return;
                        }
                      }

                      if (!_mechNA) {
                        if (!_mechanicalSelected.contains('pump_foundation_bolt_tight'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_pump_foundation'.tr()); return;
                        }
                        if (!_mechanicalSelected.contains('gland_packing_leakage_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_gland_packing'.tr()); return;
                        }
                        if (!_mechanicalSelected.contains('coupling_bush_condition_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_coupling_bush'.tr()); return;
                        }
                        if (!_mechanicalSelected.contains('grease_lubrication_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_grease'.tr()); return;
                        }
                        if (_vibrationSelected == null) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_vibration'.tr()); return;
                        }
                      }
                      if (!_pipeNA) {
                        if (!_pipelineSelected.contains('gate_valve_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_gate_valve'.tr()); return;
                        }
                        if (!_pipelineSelected.contains('nrv_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_nrv'.tr()); return;
                        }
                        if (!_pipelineSelected.contains('foot_valve_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_foot_valve'.tr()); return;
                        }
                        if (!_pipelineSelected.contains('suction_strainer_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_suction_strainer'.tr()); return;
                        }
                        if (!_pipelineSelected.contains('pressure_gauge_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_pressure_gauge'.tr()); return;
                        }
                      }
                      if (!_elecNA) {
                        if (!_electricalSelected.contains('panel_cleaning_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_panel_cleaning'.tr()); return;
                        }
                        if (!_electricalSelected.contains('all_connections_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_connections'.tr()); return;
                        }
                        if (!_electricalSelected.contains('starter_contacts_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_starter'.tr()); return;
                        }
                        if (!_electricalSelected.contains('overload_relay_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_relay'.tr()); return;
                        }
                        if (!_electricalSelected.contains('single_phase_preventer_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_preventer'.tr()); return;
                        }
                        if (!_electricalSelected.contains('voltage_current_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_voltage_current'.tr()); return;
                        }
                      }
                      if (!_operationNA) {
                        if (!_operationSelected.contains('pump_started_manual'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_pump_manual'.tr()); return;
                        }
                        if (!_operationSelected.contains('auto_operation_checked'.tr())) {
                          appSnackBar(context, AppColor.bright_red, 'val_amc_auto_operation'.tr()); return;
                        }
                      }

                      Map<String, String> listToMap(List<String> list) {
                        Map<String, String> map = {};
                        for (var item in list) {
                          String key = item.replaceAll(' :', '');
                          map[key] = 'ok'.tr();
                        }
                        return map;
                      }

                      Map<String, String> mechMap = _mechNA ? {} : listToMap(_mechanicalSelected);
                      if (!_mechNA && _vibrationSelected != null) {
                        mechMap['vibration_checked'.tr()] = _vibrationSelected!.toLowerCase();
                      }

                      final step2Data = {
                        "isMechanicalChecklistNa": _mechNA,
                        "isPipelineHydraulicChecklistNa": _pipeNA,
                        "isElectricalChecklistNa": _elecNA,
                        "operationChecklistNa": _operationNA,
                        "mechanicalChecklist": jsonEncode(mechMap),
                        "pipelineHydraulicChecklist": jsonEncode(_pipeNA ? {} : listToMap(_pipelineSelected)),
                        "electricalChecklist": jsonEncode(_elecNA ? {} : listToMap(_electricalSelected)),
                        "operationChecklist": jsonEncode(_operationNA ? {} : listToMap(_operationSelected)),
                      };

                      setState(() => _isLoading = true);
                      await OfflineAmcReportsDb.instance.saveStep(
                        _currentReportId ?? "",
                        widget.visitId,
                        2,
                        step2Data,
                      );

                      if (!isOnline) {
                        setState(() {
                          _isLoading = false;
                          _currentStep++;
                        });
                        appSnackBar(context, AppColor.green, "Step 2 saved successfully");
                      } else {
                        setState(() {
                          _isLoading = false;
                          _currentStep++;
                        });
                        appSnackBar(context, AppColor.green, "Step 2 saved successfully");
                      }
                    } else if (_currentStep < 3) {
                      setState(() => _currentStep++);
                      if (_currentStep == 3 && _currentReportId != null) {
                        _assignedTechniciansBloc.add(GetAmcAssignedTechniciansEvent(_currentReportId!));
                      }
                    } else {
                      final isOnline = await NetworkInfo().checkIsConnected;
                      if (_currentReportId == null) {
                        if (!isOnline) {
                          _currentReportId = widget.visitId;
                        } else {
                          appSnackBar(context, AppColor.bright_red, "report_id_is_missing".tr());
                          return;
                        }
                      }

                      if (_customerRepNameController.text.trim().isEmpty) {
                        appSnackBar(context, AppColor.bright_red, "customer_rep_name_required".tr());
                        return;
                      }

                      if (_selectedTechnicianRepId == null) {
                        appSnackBar(context, AppColor.bright_red, "technician_rep_required".tr());
                        return;
                      }

                      if (_technicianSignatureFile == null && _existingTechnicianSignatureUrl == null) {
                        appSnackBar(context, AppColor.bright_red, "technician_signature_required".tr());
                        return;
                      }

                      if (_customerSignatureFile == null && _existingCustomerSignatureUrl == null) {
                        appSnackBar(context, AppColor.bright_red, "customer_signature_required".tr());
                        return;
                      }

                      if (_workPhotos.isEmpty && _existingWorkPhotosUrls.isEmpty) {
                        appSnackBar(context, AppColor.bright_red, "work_photos_required".tr());
                        return;
                      }

                      final step3Data = {
                        "technicianRemarks": _technicianRemarksController.text.trim(),
                        "customerRemarks": _customerRemarksController.text.trim(),
                        "workPhotosPaths": _workPhotos.map((f) => f.path).toList(),
                        "technicianRepresentative": _selectedTechnicianRepId!,
                        "technicianSignaturePath": _technicianSignatureFile?.path,
                        "customerRepresentativeName": _customerRepNameController.text.trim(),
                        "customerSignaturePath": _customerSignatureFile?.path,
                      };

                      setState(() => _isLoading = true);
                      await OfflineAmcReportsDb.instance.saveStep(
                        _currentReportId ?? "",
                        widget.visitId,
                        3,
                        step3Data,
                      );

                      if (!isOnline) {
                        setState(() => _isLoading = false);
                        showDialog<bool>(
                          context: context,
                          builder: (context) => AppAlertDialogWidget(
                            title: "Offline Mode",
                            subtitle:
                                "This form will be saved locally on your device. Once an internet connection is available, you will need to manually sync it to upload the data to the server. Would you like to continue?",
                            confirmText: "Yes, Save Locally",
                            cancelText: "No",
                            icon: Icons.wifi_off_rounded,
                            iconBgColor: const Color(0xFFFFF3E0),
                            iconColor: const Color(0xFFFF9800),
                            confirmBtnColor: const Color(0xFFFF9800),
                            onConfirm: () async {
                              Navigator.pop(context, true);
                            },
                          ),
                        ).then((value) async {
                          if (value == true) {
                            appSnackBar(
                              context,
                              AppColor.green,
                              "Report saved offline completely!",
                            );
                            widget.onSubmit();
                          }
                        });
                        return;
                      } else {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(color: AppColor.primaryColor),
                          ),
                        );

                        // Call the offline sync service to submit step 2 to step 3 APIs sequentially
                        final syncResult = await getIt<OfflineAmcSyncService>().syncReport(_currentReportId ?? "");
                        if (mounted) Navigator.pop(context); // Close loading indicator

                        if (syncResult.isRight()) {
                          setState(() => _isLoading = false);
                          widget.onSubmit();
                        } else {
                          final failure = syncResult.getLeft().toNullable()!;
                          appSnackBar(context, AppColor.bright_red, "Submission failed: ${failure.message}");
                          setState(() => _isLoading = false);
                        }
                        return;
                      }
                    }
                  },
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  else ...[
                    if (_currentStep == 3) ...[
                      const Icon(
                        Icons.check_box_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      _currentStep < 3 ? 'amc_report_btn_next'.tr() : 'amc_report_btn_submit'.tr(),
                      style: AppFont.style(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  if (_currentStep < 3) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ],
              ),
            ),
          ),
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
