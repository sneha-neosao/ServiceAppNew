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

  void _showMultiSelectTechnicianBottomSheet(List<Technician> allTechnicians) {
    List<Technician> tempSelectedTechs = List.from(_selectedTechnicians);
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredList = allTechnicians.where((t) {
              return t.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                     t.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
                     t.id.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(ctx).size.height * 0.6,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      // Search Field
                      TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFA5ABB7), size: 20),
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
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF1565C0)),
                          ),
                        ),
                        style: AppFont.style(
                          fontSize: 14,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List View
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            final isSelected = tempSelectedTechs.any((tech) => tech.id == item.id);

                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    tempSelectedTechs.removeWhere((tech) => tech.id == item.id);
                                  } else {
                                    tempSelectedTechs.add(item);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: isSelected ? const Border(
                                    left: BorderSide(color: Color(0xFF1565C0), width: 4),
                                  ) : null,
                                  color: isSelected ? const Color(0xFFF8F9FB) : Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: AppFont.style(
                                              fontSize: 16,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                              color: isSelected ? const Color(0xFF1565C0) : const Color(0xFF0D121F),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'TECH ID: ${item.code.isNotEmpty ? item.code : item.id}',
                                            style: AppFont.style(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFA5ABB7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Checkbox
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFE5E7EB),
                                        ),
                                        color: isSelected ? const Color(0xFF1565C0) : Colors.white,
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _selectedTechnicians = List.from(tempSelectedTechs);
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            'DONE',
                            style: AppFont.style(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
      },
    );
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

                      int selectedCount = _selectedTechnicians.length;

                      return GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _showMultiSelectTechnicianBottomSheet(technicians);
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedCount == 0
                                      ? 'Select Technicians'
                                      : '$selectedCount Selected',
                                  style: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: selectedCount == 0
                                        ? FontWeight.w700
                                        : FontWeight.w900,
                                    color: selectedCount == 0
                                        ? const Color(0xFFA5ABB7)
                                        : const Color(0xFF0D121F),
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7), size: 18),
                            ],
                          ),
                        ),
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
