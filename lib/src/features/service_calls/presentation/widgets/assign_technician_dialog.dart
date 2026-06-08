import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_state.dart';
import 'package:service_app/src/remote/models/active_technicians_service_calls_model/active_technicians_service_calls_reponse.dart';
import 'package:service_app/src/features/service_calls/bloc/assign_technician_service_calls_bloc/assign_technician_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assign_technician_service_calls_bloc/assign_technician_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/assign_technician_service_calls_bloc/assign_technician_service_calls_state.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/assign_technician_service_calls_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_event.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';

class AssignTechnicianDialog extends StatefulWidget {
  final String complaintId;
  final String complaintNo;
  final VoidCallback onSuccess;
  final List<Technician>? initialTechnicians;

  const AssignTechnicianDialog({
    super.key,
    required this.complaintId,
    required this.complaintNo,
    required this.onSuccess,
    this.initialTechnicians,
  });

  @override
  State<AssignTechnicianDialog> createState() => _AssignTechnicianDialogState();
}

class _AssignTechnicianDialogState extends State<AssignTechnicianDialog> {
  late ActiveTechniciansServiceCallsBloc _activeTechsBloc;
  late AssignTechnicianServiceCallsBloc _assignBloc;
  List<Technician> _selectedTechnicians = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTechnicians != null) {
      _selectedTechnicians = List.from(widget.initialTechnicians!);
    }
    _activeTechsBloc = getIt<ActiveTechniciansServiceCallsBloc>()
      ..add(const ActiveTechniciansServiceCallsGetEvent());
    _assignBloc = getIt<AssignTechnicianServiceCallsBloc>();
  }

  @override
  void dispose() {
    _activeTechsBloc.close();
    _assignBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: Color(0xFF1565C0),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Assign Service Technician',
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFFA5ABB7),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

          // Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'assign_tech_dialog_complaint_label'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.complaintNo,
                    style: AppFont.style(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'assign_tech_dialog_select_label'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF424B5C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<
                    ActiveTechniciansServiceCallsBloc,
                    ActiveTechniciansServiceCallsState
                  >(
                    bloc: _activeTechsBloc,
                    builder: (context, state) {
                      if (state is ActiveTechniciansServiceCallsLoadingState ||
                          state is ActiveTechniciansServiceCallsInitialState) {
                        return Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),
                        );
                      }

                      if (state is ActiveTechniciansServiceCallsFailureState) {
                        return Text(
                          'Failed to load technicians: ${state.message}',
                          style: AppFont.style(color: Colors.red, fontSize: 12),
                        );
                      }

                      List<Technician> technicians = [];
                      if (state is ActiveTechniciansServiceCallsSuccessState) {
                        technicians = state.data.data;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedTechnicians.isNotEmpty) ...[
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _selectedTechnicians.map((tech) {
                                return Chip(
                                  label: Text(
                                    tech.name,
                                    style: AppFont.style(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFF1565C0),
                                  deleteIcon: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  deleteIconColor: Colors.white,
                                  onDeleted: () {
                                    setState(() {
                                      _selectedTechnicians.remove(tech);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                          ],
                          SearchableDropdown<Technician>(
                            items: technicians
                                .where(
                                  (tech) => !_selectedTechnicians.any(
                                    (selected) => selected.id == tech.id,
                                  ),
                                )
                                .toList(),
                            value: null,
                            hintText: 'assign_tech_dialog_choose_hint'.tr(),
                            itemAsString: (tech) => tech.name,
                            onChanged: (tech) {
                              if (tech != null) {
                                setState(() {
                                  _selectedTechnicians.add(tech);
                                });
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'assign_tech_dialog_cancel'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                BlocConsumer<
                  AssignTechnicianServiceCallsBloc,
                  AssignTechnicianServiceCallsState
                >(
                  bloc: _assignBloc,
                  listener: (context, state) {
                    if (state is AssignTechnicianServiceCallsSuccessState) {
                      widget.onSuccess();

                      // Show success snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('assign_tech_success_msg'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context);
                    } else if (state
                        is AssignTechnicianServiceCallsFailureState) {
                      // Show error snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        if (state is AssignTechnicianServiceCallsLoadingState)
                          return;

                        if (_selectedTechnicians.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select at least one technician',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final params = AssignTechnicianServiceCallsParams(
                          complaintId: widget.complaintId,
                          technicianIds: _selectedTechnicians
                              .map((e) => e.id)
                              .toList(),
                        );
                        _assignBloc.add(
                          AssignTechnicianServiceCallsPostEvent(params),
                        );
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1565C0,
                          ), // Active button color instead of disabled
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child:
                              state is AssignTechnicianServiceCallsLoadingState
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'assign_tech_dialog_btn'.tr(),
                                  style: AppFont.style(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
