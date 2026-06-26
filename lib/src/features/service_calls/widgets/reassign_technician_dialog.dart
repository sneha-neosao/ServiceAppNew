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

class ReassignTechnicianDialog extends StatefulWidget {
  final String complaintId;
  final String complaintNo;
  final String customerName;
  final String customerId;
  final String siteName;
  final String siteId;
  final VoidCallback onSuccess;
  final List<Technician>? initialTechnicians;

  const ReassignTechnicianDialog({
    super.key,
    required this.complaintId,
    required this.complaintNo,
    required this.customerName,
    required this.customerId,
    required this.siteName,
    required this.siteId,
    required this.onSuccess,
    this.initialTechnicians,
  });

  @override
  State<ReassignTechnicianDialog> createState() =>
      _ReassignTechnicianDialogState();
}

class _ReassignTechnicianDialogState extends State<ReassignTechnicianDialog> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
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
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: Container(
                  height: MediaQuery.of(ctx).size.height * 0.6,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFA5ABB7),
                            size: 20,
                          ),
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
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF1565C0),
                            ),
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
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            final isSelected = tempSelectedTechs.any(
                              (tech) => tech.id == item.id,
                            );

                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    tempSelectedTechs.removeWhere(
                                      (tech) => tech.id == item.id,
                                    );
                                  } else {
                                    tempSelectedTechs.add(item);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: isSelected
                                      ? const Border(
                                          left: BorderSide(
                                            color: Color(0xFF1565C0),
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: isSelected
                                      ? const Color(0xFFF8F9FB)
                                      : Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: AppFont.style(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? const Color(0xFF1565C0)
                                                  : const Color(0xFF0D121F),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'TECH ID: ${item.code.isNotEmpty ? item.code : item.id}',
                                            style: AppFont.style(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFFA5ABB7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF1565C0)
                                              : const Color(0xFFE5E7EB),
                                        ),
                                        color: isSelected
                                            ? const Color(0xFF1565C0)
                                            : Colors.white,
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
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
                              _selectedTechnicians = List.from(
                                tempSelectedTechs,
                              );
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            'DONE',
                            style: AppFont.style(
                              color: Colors.white,
                              fontSize: 10,
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
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Color(0xFF1565C0),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Assign Service Technician',
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                        const Spacer(),
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
                    const SizedBox(height: 16),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF1F2F6),
                    ),
                    const SizedBox(height: 16),
                    // Complaint Number
                    RichText(
                      text: TextSpan(
                        text: 'Complaint Number: ',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                        children: [
                          TextSpan(
                            text: widget.complaintNo,
                            style: AppFont.style(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF1F2F6),
                    ),
                    const SizedBox(height: 16),
                    // Customer & Site Name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Name :',
                                style: AppFont.style(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFA5ABB7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.customerName,
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0D121F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Site Name :',
                                style: AppFont.style(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFA5ABB7),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.siteName,
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0D121F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF1F2F6),
                    ),
                    const SizedBox(height: 16),
                    // Select Multiple Technicians
                    Text(
                      'Select Multiple Technicians',
                      style: AppFont.style(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<
                      ActiveTechniciansServiceCallsBloc,
                      ActiveTechniciansServiceCallsState
                    >(
                      bloc: _activeTechsBloc,
                      builder: (context, state) {
                        if (state
                            is ActiveTechniciansServiceCallsLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state
                            is ActiveTechniciansServiceCallsFailureState) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (state
                            is ActiveTechniciansServiceCallsSuccessState) {
                          return GestureDetector(
                            onTap: () {
                              _showMultiSelectTechnicianBottomSheet(
                                state.data.data,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedTechnicians.isEmpty
                                        ? 'Select'
                                        : '${_selectedTechnicians.length} Selected',
                                    style: AppFont.style(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0D121F),
                                    ),
                                  ),
                                  if (_selectedTechnicians.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedTechnicians.clear();
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xFFA5ABB7),
                                        size: 16,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFFA5ABB7),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 32),
                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: AppFont.style(
                              fontSize: 12,
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
                            if (state
                                is AssignTechnicianServiceCallsSuccessState) {
                              widget.onSuccess();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('assign_tech_success_msg'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            } else if (state
                                is AssignTechnicianServiceCallsFailureState) {
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
                                if (state
                                    is AssignTechnicianServiceCallsLoadingState)
                                  return;

                                if (_selectedTechnicians.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                      content: Text(
                                        'assign_tech_validation_msg'.tr(),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final params =
                                    AssignTechnicianServiceCallsParams(
                                      complaintId: widget.complaintId,
                                      technicianIds: _selectedTechnicians
                                          .map((e) => e.id)
                                          .toList(),
                                      customerId: widget.customerId,
                                      siteId: widget.siteId,
                                    );
                                _assignBloc.add(
                                  AssignTechnicianServiceCallsPostEvent(params),
                                );
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child:
                                      state
                                          is AssignTechnicianServiceCallsLoadingState
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Assign',
                                          style: AppFont.style(
                                            fontSize: 12,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
