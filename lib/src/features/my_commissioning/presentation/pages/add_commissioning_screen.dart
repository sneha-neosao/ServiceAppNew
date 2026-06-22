import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/features/common/bloc/technician_bloc/technician_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_create_bloc/commissioning_work_create_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_details_bloc/commissioning_work_details_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_details_bloc/commissioning_work_details_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_details_bloc/commissioning_work_details_state.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_update_bloc/commissioning_work_update_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_update_bloc/commissioning_work_update_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_update_bloc/commissioning_work_update_state.dart';
import 'package:service_app/src/features/common/bloc/create_new_customer_bloc/create_new_customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/create_new_customer_bloc/create_new_customer_event.dart';
import 'package:service_app/src/features/common/bloc/create_new_customer_bloc/create_new_customer_state.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_customer_usecase.dart';
import 'package:service_app/src/features/common/bloc/create_new_site_bloc/create_new_site_bloc.dart';
import 'package:service_app/src/features/common/bloc/create_new_site_bloc/create_new_site_event.dart';
import 'package:service_app/src/features/common/bloc/create_new_site_bloc/create_new_site_state.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_site_usecase.dart';
import 'package:service_app/src/features/widgets/add_new_entry_bottomshhet_widget.dart';
import 'package:service_app/src/features/widgets/app_add_new_text_button_widget.dart';
import 'package:service_app/src/features/widgets/merge_customer_dialogue_widget.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';
import 'package:shimmer/shimmer.dart';

class AddCommissioningScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String? editWorkId;

  const AddCommissioningScreen({
    super.key,
    required this.onBack,
    this.editWorkId,
  });

  @override
  State<AddCommissioningScreen> createState() => _AddCommissioningScreenState();
}

class _AddCommissioningScreenState extends State<AddCommissioningScreen> {
  // ── Customer ──────────────────────────────────────────────────────────────
  List<String> _customers = [];
  String? _selectedCustomer;
  final Map<String, String> _createdCustomerIds = {};

  // ── Site / Location ───────────────────────────────────────────────────────
  List<String> _sites = [];
  String? _selectedSite;
  final Map<String, String> _createdSiteIds = {};

  // ── Equipment ─────────────────────────────────────────────────────────────
  late TextEditingController _equipmentController;

  // ── Technicians ───────────────────────────────────────────────────────────
  List<TextEditingController> _technicianControllers = [
    TextEditingController(),
  ];

  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late TechnicianBloc _technicianBloc;
  late CommissioningWorkCreateBloc _createBloc;
  late CommissioningWorkDetailsBloc _detailsBloc;
  late CommissioningWorkUpdateBloc _updateBloc;
  late CreateNewCustomerBloc _createNewCustomerBloc;
  late CreateNewSiteBloc _createNewSiteBloc;

  @override
  void initState() {
    super.initState();

    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _technicianBloc = getIt<TechnicianBloc>()..add(TechnicianGetEvent());
    _createBloc = getIt<CommissioningWorkCreateBloc>();
    _detailsBloc = getIt<CommissioningWorkDetailsBloc>();
    _updateBloc = getIt<CommissioningWorkUpdateBloc>();
    _createNewCustomerBloc = getIt<CreateNewCustomerBloc>();
    _createNewSiteBloc = getIt<CreateNewSiteBloc>();
    _equipmentController = TextEditingController();

    if (widget.editWorkId != null) {
      _detailsBloc.add(CommissioningWorkDetailsGetEvent(widget.editWorkId!));
    }
  }

  @override
  void dispose() {
    _customerBloc.close();
    _sitesBloc.close();
    _technicianBloc.close();
    _createBloc.close();
    _detailsBloc.close();
    _updateBloc.close();
    _createNewCustomerBloc.close();
    _createNewSiteBloc.close();
    _equipmentController.dispose();
    super.dispose();
  }

  String _pendingNewCustomerName = "";

  Future<void> _showAddCustomerBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocConsumer<CreateNewCustomerBloc, CreateNewCustomerState>(
          bloc: _createNewCustomerBloc,
          listener: (ctx, state) {
            if (state is CreateNewCustomerSuccessState) {
              appSnackBar(context, const Color(0xFF4CAF50), state.data.message);
              final newName = state.data.data?.name ?? _pendingNewCustomerName;
              Navigator.pop(ctx);
              setState(() {
                if (!_customers.contains(newName)) {
                  _customers.insert(0, newName);
                }
                if (state.data.data?.id != null) {
                  _createdCustomerIds[newName] = state.data.data!.id;
                }
                _selectedCustomer = newName;
                _selectedSite = null;
                _sites.clear();
              });
            } else if (state is CreateNewCustomerFailureState) {
              if (state.message.contains('merged_with_existing'.tr())) {
                Navigator.pop(ctx); // Close the bottom sheet immediately
                _showMergeCustomerDialog(context, _pendingNewCustomerName);
              } else {
                appSnackBar(ctx, const Color(0xFFF44336), state.message);
              }
            }
          },
          builder: (ctx, state) {
            return AddNewEntryBottomSheet(
              title: "add_new_customer".tr(),
              label: "close_call_customer_name_label".tr(),
              hint: "enter_customer_name".tr(),
              isLoading: state is CreateNewCustomerLoadingState,
              onClose: () => Navigator.pop(ctx),
              onSubmit: (name) {
                _pendingNewCustomerName = name;
                _createNewCustomerBloc.add(
                  CreateNewCustomerSubmitEvent(
                    CreateNewCustomerParams(name: name),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _showAddSiteBottomSheet() async {
    if (_selectedCustomer == null) {
      appSnackBar(
        context,
        const Color(0xFFF44336),
        'merged_with_existing'.tr(),
      );
      return;
    }

    // Resolve customerId
    String customerId = "";
    if (_createdCustomerIds.containsKey(_selectedCustomer)) {
      customerId = _createdCustomerIds[_selectedCustomer]!;
    } else {
      final customerState = _customerBloc.state;
      if (customerState is CustomerSuccessState) {
        for (var c in customerState.data.data) {
          if (c.name == _selectedCustomer) {
            customerId = c.id;
            break;
          }
        }
      }
    }

    if (customerId.isEmpty) {
      appSnackBar(
        context,
        const Color(0xFFF44336),
        'invalid_customer_selector'.tr(),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocConsumer<CreateNewSiteBloc, CreateNewSiteState>(
          bloc: _createNewSiteBloc,
          listener: (ctx, state) {
            if (state is CreateNewSiteSuccessState) {
              appSnackBar(ctx, const Color(0xFF4CAF50), state.data.message);
              final newName = state.data.data?.sites.first.name ?? "";
              Navigator.pop(ctx);
              setState(() {
                if (!_sites.contains(newName)) {
                  _sites.insert(0, newName);
                }
                if (state.data.data != null) {
                  for (var s in state.data.data!.sites) {
                    if (s.name == newName) {
                      _createdSiteIds[newName] = s.id;
                      break;
                    }
                  }
                }
                _selectedSite = newName;
              });
            } else if (state is CreateNewSiteFailureState) {
              appSnackBar(ctx, const Color(0xFFF44336), state.message);
            }
          },
          builder: (ctx, state) {
            final isLoading = state is CreateNewSiteLoadingState;
            return AddNewEntryBottomSheet(
              title: "add_new_site".tr(),
              label: "site_name".tr(),
              hint: "enter_site_name".tr(),
              isLoading: isLoading,
              onClose: () => Navigator.pop(ctx),
              onSubmit: (siteName) {
                _createNewSiteBloc.add(
                  CreateNewSiteSubmitEvent(
                    CreateNewSiteParams(
                      customerId: customerId,
                      customerName: _selectedCustomer!,
                      siteName: siteName,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Assign button handler ──────────────────────────────────────────────────
  void _onAssign() {
    String customerId = "";
    if (_selectedCustomer != null &&
        _createdCustomerIds.containsKey(_selectedCustomer)) {
      customerId = _createdCustomerIds[_selectedCustomer]!;
    } else {
      final customerState = _customerBloc.state;
      if (customerState is CustomerSuccessState) {
        for (var c in customerState.data.data) {
          if (c.name == _selectedCustomer) {
            customerId = c.id;
            break;
          }
        }
      }
    }

    String siteId = "";
    if (_selectedSite != null && _createdSiteIds.containsKey(_selectedSite)) {
      siteId = _createdSiteIds[_selectedSite]!;
    } else {
      final siteState = _sitesBloc.state;
      if (siteState is SitesSuccessState) {
        for (var s in siteState.data.data) {
          if (s.name == _selectedSite) {
            siteId = s.id;
            break;
          }
        }
      }
    }

    final appOfEquipment = _equipmentController.text.trim();

    List<String> technicianIds = _technicianControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => c.text)
        .toSet()
        .toList();

    if (technicianIds.isEmpty) {
      appSnackBar(
        context,
        const Color(0xFFF44336),
        "assign_tech_validation_msg".tr(),
      );
      return;
    }

    if (widget.editWorkId != null) {
      _updateBloc.add(
        CommissioningWorkUpdateSubmitEvent(
          workId: widget.editWorkId!,
          customerId: customerId,
          siteId: siteId,
          applicationOfEquipment: appOfEquipment,
          technicians: technicianIds,
        ),
      );
    } else {
      _createBloc.add(
        CommissioningWorkCreateSubmitEvent(
          customerId: customerId,
          siteId: siteId,
          applicationOfEquipment: appOfEquipment,
          technicians: technicianIds,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CommissioningWorkCreateBloc, CommissioningWorkCreateState>(
          bloc: _createBloc,
          listener: (context, state) {
            if (state is CommissioningWorkCreateSuccessState) {
              appSnackBar(context, const Color(0xFF4CAF50), state.data.message);
              widget.onBack();
            } else if (state is CommissioningWorkCreateFailureState) {
              appSnackBar(context, const Color(0xFFF44336), state.message);
            }
          },
        ),
        BlocListener<CommissioningWorkUpdateBloc, CommissioningWorkUpdateState>(
          bloc: _updateBloc,
          listener: (context, state) {
            if (state is CommissioningWorkUpdateSuccessState) {
              appSnackBar(context, const Color(0xFF4CAF50), state.data.message);
              widget.onBack();
            } else if (state is CommissioningWorkUpdateFailureState) {
              appSnackBar(context, const Color(0xFFF44336), state.message);
            }
          },
        ),
      ],
      child: PopScope(
        // Intercept Android system back button
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) widget.onBack();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
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
                          widget.editWorkId != null
                              ? 'edit_commissioning_work'.tr()
                              : 'assign_for_new_commissioning_work'.tr(),
                          style: AppFont.style(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0D121F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F2F6),
                ),

                // ── Form body ────────────────────────────────────────────────
                Expanded(
                  child: BlocConsumer<CommissioningWorkDetailsBloc, CommissioningWorkDetailsState>(
                    bloc: _detailsBloc,
                    listener: (context, state) {
                      if (state is CommissioningWorkDetailsSuccessState) {
                        final data = state.data.data;
                        setState(() {
                          _selectedCustomer = data.customer.name;
                          if (!_customers.contains(data.customer.name)) {
                            _customers.insert(0, data.customer.name);
                          }
                          _createdCustomerIds[data.customer.name] =
                              data.customer.id;

                          _selectedSite = data.site.name;
                          if (!_sites.contains(data.site.name)) {
                            _sites.insert(0, data.site.name);
                          }
                          _createdSiteIds[data.site.name] = data.site.id;

                          _equipmentController.text =
                              data.applicationOfEquipment;

                          if (data.assignedTechnicians.isNotEmpty) {
                            _technicianControllers.clear();
                            for (var t in data.assignedTechnicians) {
                              _technicianControllers.add(
                                TextEditingController(text: t.id),
                              );
                            }
                          }
                        });
                      } else if (state
                          is CommissioningWorkDetailsFailureState) {
                        appSnackBar(
                          context,
                          const Color(0xFFF44336),
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (widget.editWorkId != null &&
                          (state is CommissioningWorkDetailsInitialState ||
                              state is CommissioningWorkDetailsLoadingState)) {
                        return _buildFormShimmer();
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            // ── STEP 1: SELECT CUSTOMER ──────────────────────────
                            _buildSectionHeader(
                              label: 'commissioning_step_1',
                              onAddTap: _showAddCustomerBottomSheet,
                            ),
                            BlocBuilder<CustomerBloc, CustomerState>(
                              bloc: _customerBloc,
                              builder: (context, state) {
                                bool isLoading = state is CustomerLoadingState;
                                if (state is CustomerSuccessState) {
                                  _customers.clear();
                                  final apiNames = state.data.data
                                      .map((e) => e.name)
                                      .toList();
                                  _customers.addAll(apiNames);
                                }
                                return _buildDropdown(
                                  hint: 'select_customer'.tr(),
                                  value: _selectedCustomer,
                                  items: _customers,
                                  isLoading: isLoading,
                                  filterFn: (item, filter) => true,
                                  onSearchChanged: (v) {
                                    _customerBloc.add(
                                      CustomerGetEvent(
                                        search: v,
                                        page: 1,
                                        pageSize: 10,
                                      ),
                                    );
                                  },
                                  onLoadMore: (lastSearch) {
                                    _customerBloc.add(
                                      CustomerGetEvent(
                                        search: lastSearch,
                                        page: 2,
                                        pageSize: 10,
                                      ),
                                    );
                                  },
                                  onChanged: (v) {
                                    setState(() {
                                      _selectedCustomer = v;
                                      _selectedSite = null;
                                      _sites.clear();
                                    });
                                    if (v != null) {
                                      String? customerId;
                                      if (_createdCustomerIds.containsKey(v)) {
                                        customerId = _createdCustomerIds[v];
                                      } else if (state
                                          is CustomerSuccessState) {
                                        final cList = state.data.data.where(
                                          (x) => x.name == v,
                                        );
                                        if (cList.isNotEmpty) {
                                          customerId = cList.first.id;
                                        }
                                      }
                                      if (customerId != null) {
                                        _sitesBloc.add(
                                          SitesGetEvent(customer_id: customerId),
                                        );
                                      }
                                    }
                                  },
                                  onClear: () {
                                    setState(() {
                                      _selectedCustomer = null;
                                      _selectedSite = null;
                                      _sites.clear();
                                      _equipmentController.clear();
                                      _technicianControllers = [
                                        TextEditingController()
                                      ];
                                    });
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 32),

                            // ── STEP 2: SELECT SITE ──────────────────────────────
                            _buildSectionHeader(
                              label: 'commissioning_step_2',
                              onAddTap: _selectedCustomer != null
                                  ? _showAddSiteBottomSheet
                                  : null,
                            ),
                            BlocBuilder<SitesBloc, SitesState>(
                              bloc: _sitesBloc,
                              builder: (context, state) {
                                bool isLoading = state is SitesLoadingState;
                                if (state is SitesSuccessState) {
                                  final apiNames = state.data.data
                                      .map((e) => e.name)
                                      .toList();
                                  for (var name in apiNames) {
                                    if (!_sites.contains(name))
                                      _sites.add(name);
                                  }
                                }
                                return _buildDropdown(
                                  hint: 'select_site'.tr(),
                                  value: _selectedSite,
                                  items: _sites,
                                  isLoading: isLoading,
                                  filterFn: (item, filter) => true,
                                  onSearchChanged: _selectedCustomer != null
                                      ? (v) {
                                          String? customerId =
                                              _createdCustomerIds[_selectedCustomer!];
                                          if (customerId == null &&
                                              _customerBloc.state
                                                  is CustomerSuccessState) {
                                            final list =
                                                (_customerBloc.state
                                                        as CustomerSuccessState)
                                                    .data
                                                    .data
                                                    .where(
                                                      (x) =>
                                                          x.name ==
                                                          _selectedCustomer,
                                                    );
                                            if (list.isNotEmpty)
                                              customerId = list.first.id;
                                          }
                                          if (customerId != null) {
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
                                  onLoadMore: _selectedCustomer != null
                                      ? (lastSearch) {
                                          String? customerId =
                                              _createdCustomerIds[_selectedCustomer!];
                                          if (customerId == null &&
                                              _customerBloc.state
                                                  is CustomerSuccessState) {
                                            final list =
                                                (_customerBloc.state
                                                        as CustomerSuccessState)
                                                    .data
                                                    .data
                                                    .where(
                                                      (x) =>
                                                          x.name ==
                                                          _selectedCustomer,
                                                    );
                                            if (list.isNotEmpty)
                                              customerId = list.first.id;
                                          }
                                          if (customerId != null) {
                                            _sitesBloc.add(
                                              SitesGetEvent(
                                                customer_id: customerId,
                                                search: lastSearch,
                                                page: 2,
                                                pageSize: 10,
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  onChanged: _selectedCustomer != null
                                      ? (v) => setState(() => _selectedSite = v)
                                      : null,
                                  onClear: () {
                                    setState(() {
                                      _selectedSite = null;
                                      _equipmentController.clear();
                                      _technicianControllers = [
                                        TextEditingController()
                                      ];
                                    });
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 32),

                            // ── STEP 3: APPLICATION OF EQUIPMENT ─────────────────
                            _buildSectionHeader(
                              label: 'commissioning_step_3',
                              showAdd: false,
                            ),
                            _buildTextField(
                              hint: 'enter_application_of_equipment'.tr(),
                              controller: _equipmentController,
                              enabled: _selectedSite != null,
                            ),

                            const SizedBox(height: 32),

                            // ── STEP 4: ASSIGN TECHNICIANS ───────────────────────
                            _buildSectionHeader(
                              label: 'commissioning_step_4',
                              showAdd: false,
                            ),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _equipmentController,
                              builder: (context, equipmentValue, _) {
                                final bool isTechnicianEnabled = equipmentValue.text.trim().isNotEmpty;
                                return IgnorePointer(
                                  ignoring: !isTechnicianEnabled,
                                  child: BlocBuilder<TechnicianBloc, TechnicianState>(
                                    bloc: _technicianBloc,
                                    builder: (context, state) {
                                      bool isLoading = state is TechnicianLoadingState;

                                      if (isLoading) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[200]!,
                                          highlightColor: Colors.grey[50]!,
                                          child: Container(
                                            height: 56,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: const Color(0xFFE5E7EB)),
                                            ),
                                          ),
                                        );
                                      }

                                      int selectedCount = _technicianControllers.where((c) => c.text.isNotEmpty).length;

                                      return GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          if (state is TechnicianSuccessState) {
                                            _showMultiSelectTechnicianBottomSheet(state.data.data);
                                          }
                                        },
                                        child: Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: isTechnicianEnabled ? Colors.white : const Color(0xFFF1F2F6),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFE5E7EB)),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  selectedCount == 0
                                                      ? 'select_technician'.tr()
                                                      : '$selectedCount ${'selected'.tr()}',
                                                  style: AppFont.style(
                                                    fontSize: 15,
                                                    fontWeight: selectedCount == 0
                                                        ? FontWeight.w500
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
                                );
                              },
                            ),

                            const SizedBox(height: 48),

                            // ── Assign Button ──────────────────────────────────
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF1565C0,
                                    ).withOpacity(0.18),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child:
                                  BlocBuilder<
                                    CommissioningWorkCreateBloc,
                                    CommissioningWorkCreateState
                                  >(
                                    bloc: _createBloc,
                                    builder: (context, state) {
                                      return BlocBuilder<
                                        CommissioningWorkUpdateBloc,
                                        CommissioningWorkUpdateState
                                      >(
                                        bloc: _updateBloc,
                                        builder: (context, updateState) {
                                          final isLoading =
                                              state
                                                  is CommissioningWorkCreateLoadingState ||
                                              updateState
                                                  is CommissioningWorkUpdateLoadingState;
                                          return ElevatedButton(
                                            onPressed: isLoading
                                                ? null
                                                : _onAssign,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF1565C0,
                                              ),
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2.5,
                                                        ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.editWorkId !=
                                                                null
                                                            ? 'save_changes'.tr()
                                                            : 'assign'.tr(),
                                                        style: AppFont.style(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white,
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Icon(
                                                        Icons.arrow_forward,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Section header with optional "+" button ────────────────────────────────
  Widget _buildSectionHeader({
    required String label,
    bool showAdd = true,
    VoidCallback? onAddTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: label.tr(),
              style: AppFont.style(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFA2AEC0),
                letterSpacing: 0.8,
              ),
              children: [
                TextSpan(
                  text: 'asterisk'.tr(),
                  style: AppFont.style(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          if (showAdd && onAddTap != null)
            AppAddNewTextButtonWidget(
                onPressed: onAddTap
            )
        ],
      ),
    );
  }

  // ── Styled dropdown ────────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    bool isLoading = false,
    void Function(String)? onSearchChanged,
    void Function(String)? onLoadMore,
    bool Function(String, String)? filterFn,
    VoidCallback? onClear,
  }) {
    // Make sure current value is in items to avoid DropdownButton error
    List<String> validItems = List.from(items);
    if (value != null && !validItems.contains(value)) {
      validItems.add(value);
    }

    final bool isEnabled = onChanged != null;

    return IgnorePointer(
      ignoring: !isEnabled,
      child: SearchableDropdown<String>(
        items: validItems,
        value: value,
        hintText: hint,
        itemAsString: (item) => item,
        onChanged: onChanged,
        onSearchChanged: onSearchChanged,
        onLoadMore: onLoadMore,
        filterFn: filterFn,
        isLoading: isLoading,
        onClear: onClear,
        enabled: isEnabled,
      ),
    );
  }

  // ── Styled text field ──────────────────────────────────────────────────────
  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F2F6)),
        ),
        child: TextField(
          controller: controller,
          style: AppFont.style(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D121F),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFA5ABB7),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // STEP 1: SELECT CUSTOMER
            _buildShimmerSectionHeader(),
            _buildShimmerDropdown(),
            const SizedBox(height: 32),

            // STEP 2: SELECT SITE
            _buildShimmerSectionHeader(),
            _buildShimmerDropdown(),
            const SizedBox(height: 32),

            // STEP 3: APPLICATION OF EQUIPMENT
            _buildShimmerSectionHeader(showAdd: false),
            _buildShimmerDropdown(),
            const SizedBox(height: 32),

            // STEP 4: ASSIGN TECHNICIANS
            _buildShimmerSectionHeader(showAdd: false),
            _buildShimmerDropdown(),
            const SizedBox(height: 48),

            // Assign Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerSectionHeader({bool showAdd = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          if (showAdd)
            Container(
              width: 60,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShimmerDropdown() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
    );
  }

  void _showMergeCustomerDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MergeCustomerDialogWidget(
        name: name,
        bloc: _createNewCustomerBloc,
      ),
    );
  }

  void _showMultiSelectTechnicianBottomSheet(List<dynamic> allTechnicians) {
    List<String> tempSelectedIds = _technicianControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => c.text)
        .toList();

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
                     (t.id?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
            }).toList();

            return SafeArea(
              bottom: true,
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
                          hintText: 'search'.tr(),
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
                            final isSelected = tempSelectedIds.contains(item.id);

                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    tempSelectedIds.remove(item.id);
                                  } else {
                                    tempSelectedIds.add(item.id);
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
                                            '${'tech_id'.tr()} ${item.code ?? item.id}',
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
                              _technicianControllers.clear();
                              if (tempSelectedIds.isEmpty) {
                                _technicianControllers.add(TextEditingController());
                              } else {
                                for (var id in tempSelectedIds) {
                                  _technicianControllers.add(TextEditingController(text: id));
                                }
                              }
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
                            'create_report_btn_done'.tr(),
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
}
