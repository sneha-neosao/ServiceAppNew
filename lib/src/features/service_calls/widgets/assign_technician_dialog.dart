import 'package:service_app/src/core/theme/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/active_technicians_service_calls_bloc/active_technicians_service_calls_state.dart';
import 'package:service_app/src/features/widgets/app_add_new_text_button_widget.dart';
import 'package:service_app/src/features/widgets/merge_customer_dialogue_widget.dart';
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
import 'package:service_app/src/features/common/bloc/customer_bloc/customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/sites_bloc/sites_bloc.dart';
import 'package:service_app/src/features/common/bloc/create_new_customer_bloc/create_new_customer_bloc.dart';
import 'package:service_app/src/features/common/bloc/create_new_customer_bloc/create_new_customer_event.dart';
import 'package:service_app/src/features/common/bloc/create_new_customer_bloc/create_new_customer_state.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_customer_usecase.dart';
import 'package:service_app/src/features/common/bloc/create_new_site_bloc/create_new_site_bloc.dart';
import 'package:service_app/src/features/common/bloc/create_new_site_bloc/create_new_site_event.dart';
import 'package:service_app/src/features/common/bloc/create_new_site_bloc/create_new_site_state.dart';
import 'package:service_app/src/features/common/domain/usecase/create_new_site_usecase.dart';

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
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late ActiveTechniciansServiceCallsBloc _activeTechsBloc;
  late AssignTechnicianServiceCallsBloc _assignBloc;
  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late final CreateNewCustomerBloc _createNewCustomerBloc =
      getIt<CreateNewCustomerBloc>();
  late final CreateNewSiteBloc _createNewSiteBloc = getIt<CreateNewSiteBloc>();

  List<Technician> _selectedTechnicians = [];
  List<String> _customers = [];
  String? _selectedCustomer;
  List<String> _sites = [];
  String? _selectedSite;

  final Map<String, String> _createdCustomerIds = {};
  final Map<String, String> _createdSiteIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialTechnicians != null) {
      _selectedTechnicians = List.from(widget.initialTechnicians!);
    }

    _activeTechsBloc = getIt<ActiveTechniciansServiceCallsBloc>()
      ..add(const ActiveTechniciansServiceCallsGetEvent());
    _assignBloc = getIt<AssignTechnicianServiceCallsBloc>();
    _customerBloc = getIt<CustomerBloc>()..add(CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
  }

  @override
  void dispose() {
    _activeTechsBloc.close();
    _assignBloc.close();
    _customerBloc.close();
    _sitesBloc.close();
    _createNewCustomerBloc.close();
    _createNewSiteBloc.close();
    super.dispose();
  }

  Future<void> _showAddCustomerDialog() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.business_outlined,
                                color: AppColor.colorFF1565C0,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'add_new_customer'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.colorFF0D121F,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.pop(ctx),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColor.colorFFA5ABB7,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColor.colorFFF1F2F6,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'create_report_customer_name'.tr(),
                            style: AppFont.style(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColor.colorFF424B5C,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'enter_customer_name'.tr(),
                              hintStyle: AppFont.style(
                                fontSize: 12,
                                color: AppColor.colorFFA5ABB7,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColor.colorFFE5E7EB,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColor.colorFFE5E7EB,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColor.colorFF1565C0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'Cancel',
                                  style: AppFont.style(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColor.colorFF6B7280,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              BlocConsumer<
                                CreateNewCustomerBloc,
                                CreateNewCustomerState
                              >(
                                bloc: _createNewCustomerBloc,
                                listener: (context, state) {
                                  if (state is CreateNewCustomerSuccessState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.data.message),
                                        backgroundColor: AppColor.green,
                                      ),
                                    );
                                    final newName =
                                        state.data.data?.name ??
                                        controller.text.trim();
                                    Navigator.pop(ctx);
                                    setState(() {
                                      if (!_customers.contains(newName)) {
                                        _customers.insert(0, newName);
                                      }
                                      if (state.data.data?.id != null) {
                                        _createdCustomerIds[newName] =
                                            state.data.data!.id;
                                      }
                                      _selectedCustomer = newName;
                                      _selectedSite = null;
                                      _sites.clear();
                                    });
                                  } else if (state
                                      is CreateNewCustomerFailureState) {
                                    if (state.message.contains(
                                      'merged_with_existing'.tr(),
                                    )) {
                                      Navigator.pop(ctx);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (dialogCtx) {
                                          return MergeCustomerDialogWidget(
                                            name: controller.text.trim(),
                                            bloc:
                                                _createNewCustomerBloc, // reuse the same bloc
                                          );
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(state.message),
                                          backgroundColor: AppColor.bright_red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading =
                                      state is CreateNewCustomerLoadingState;
                                  return ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            final text = controller.text.trim();
                                            if (text.isNotEmpty) {
                                              _createNewCustomerBloc.add(
                                                CreateNewCustomerSubmitEvent(
                                                  CreateNewCustomerParams(
                                                    name: text,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.colorFF0B68B9,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      minimumSize: const Size(0, 40),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'save_entry'.tr(),
                                            style: AppFont.style(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
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
          ),
        );
      },
    );
  }

  Future<void> _showAddSiteDialog() async {
    if (_selectedCustomer == null) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('please_select_customer'.tr()),
          backgroundColor: AppColor.bright_red,
        ),
      );
      return;
    }

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
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('error_finding_customer_id'.tr()),
          backgroundColor: AppColor.bright_red,
        ),
      );
      return;
    }

    final controller = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white,
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColor.colorFF1565C0,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add Site',
                            style: AppFont.style(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColor.colorFF0D121F,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(ctx),
                            child: const Icon(
                              Icons.close,
                              color: AppColor.colorFFA5ABB7,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColor.colorFFF1F2F6,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${'customer'.tr()} $_selectedCustomer',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColor.colorFFA5ABB7,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'close_call_site_name_label'.tr(),
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColor.colorFF424B5C,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'enter_site_name'.tr(),
                          hintStyle: AppFont.style(
                            fontSize: 12,
                            color: AppColor.colorFFA5ABB7,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColor.colorFFE5E7EB,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColor.colorFFE5E7EB,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColor.colorFF1565C0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'cancel'.tr(),
                              style: AppFont.style(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColor.colorFF6B7280,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          BlocConsumer<CreateNewSiteBloc, CreateNewSiteState>(
                            bloc: _createNewSiteBloc,
                            listener: (context, state) {
                              if (state is CreateNewSiteSuccessState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.data.message),
                                    backgroundColor: AppColor.green,
                                  ),
                                );
                                final newName = controller.text.trim();
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: AppColor.bright_red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading =
                                  state is CreateNewSiteLoadingState;
                              return ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final text = controller.text.trim();
                                        if (text.isNotEmpty) {
                                          _createNewSiteBloc.add(
                                            CreateNewSiteSubmitEvent(
                                              CreateNewSiteParams(
                                                customerId: customerId,
                                                customerName:
                                                    _selectedCustomer!,
                                                siteName: text,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.colorFF0B68B9,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  minimumSize: const Size(0, 40),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'save_entry'.tr(),
                                        style: AppFont.style(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
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
        );
      },
    );
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
                      // Search Field
                      TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'search'.tr(),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColor.colorFFA5ABB7,
                            size: 20,
                          ),
                          hintStyle: AppFont.style(
                            fontSize: 12,
                            color: AppColor.colorFFA5ABB7,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColor.colorFFE5E7EB,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColor.colorFFE5E7EB,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColor.colorFF1565C0,
                            ),
                          ),
                        ),
                        style: AppFont.style(
                          fontSize: 12,
                          color: AppColor.colorFF0D121F,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List View
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
                                            color: AppColor.colorFF1565C0,
                                            width: 4,
                                          ),
                                        )
                                      : null,
                                  color: isSelected
                                      ? AppColor.colorFFF8F9FB
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
                                                  ? AppColor.colorFF1565C0
                                                  : AppColor.colorFF0D121F,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${'tech_id'.tr()} ${item.code.isNotEmpty ? item.code : item.id}',
                                            style: AppFont.style(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.colorFFA5ABB7,
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
                                          color: isSelected
                                              ? AppColor.colorFF1565C0
                                              : AppColor.colorFFE5E7EB,
                                        ),
                                        color: isSelected
                                            ? AppColor.colorFF1565C0
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
                            backgroundColor: AppColor.colorFF1565C0,
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
                            'create_report_btn_done'.tr(),
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
                        color: AppColor.colorFF1565C0,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'assign_tech_dialog_title'.tr(),
                          style: AppFont.style(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColor.colorFF0D121F,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: AppColor.colorFFA5ABB7,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColor.colorFFF1F2F6,
                ),

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
                            color: AppColor.colorFFA5ABB7,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.complaintNo,
                          style: AppFont.style(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColor.colorFF0D121F,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'close_call_customer_name_label'.tr(),
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.colorFF424B5C,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'asterisk'.tr(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            AppAddNewTextButtonWidget(
                              onPressed: _showAddCustomerDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                            return SearchableDropdown<String>(
                              items: _customers,
                              value: _selectedCustomer,
                              hintText: 'service_calls_filter_select_customer'
                                  .tr(),
                              isLoading: isLoading,
                              itemAsString: (item) => item,
                              onClear: () {
                                setState(() {
                                  _selectedCustomer = null;
                                  _selectedSite = null;
                                  _sites.clear();
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _selectedCustomer = val;
                                  _selectedSite = null;
                                  _sites.clear();
                                });
                                if (val != null &&
                                    state is CustomerSuccessState) {
                                  final customer = state.data.data.firstWhere(
                                    (c) => c.name == val,
                                  );
                                  _sitesBloc.add(
                                    SitesGetEvent(customer_id: customer.id),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'close_call_site_name_label'.tr(),
                                style: AppFont.style(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.colorFF424B5C,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'asterisk'.tr(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            AppAddNewTextButtonWidget(
                              onPressed: _showAddSiteDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<SitesBloc, SitesState>(
                          bloc: _sitesBloc,
                          builder: (context, state) {
                            bool isLoading = state is SitesLoadingState;
                            if (state is SitesSuccessState) {
                              _sites.clear();
                              final apiNames = state.data.data
                                  .map((e) => e.name)
                                  .toList();
                              _sites.addAll(apiNames);
                            }
                            return SearchableDropdown<String>(
                              items: _sites,
                              value: _selectedSite,
                              hintText: 'service_calls_filter_select_site'.tr(),
                              isLoading: isLoading,
                              readOnly: _selectedCustomer == null,
                              enabled: _selectedCustomer != null,
                              itemAsString: (item) => item,
                              onClear: () {
                                setState(() {
                                  _selectedSite = null;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  _selectedSite = val;
                                });
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: '${'assign_tech_dialog_select_label'.tr()} ',
                            style: AppFont.style(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColor.colorFF424B5C,
                            ),
                            children: [
                              TextSpan(
                                text: 'asterisk'.tr(),
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
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
                                    is ActiveTechniciansServiceCallsLoadingState ||
                                state
                                    is ActiveTechniciansServiceCallsInitialState) {
                              return Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColor.colorFFE5E7EB,
                                  ),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.colorFF1565C0,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (state
                                is ActiveTechniciansServiceCallsFailureState) {
                              return Text(
                                'Failed to load technicians: ${state.message}',
                                style: AppFont.style(
                                  color: Colors.red,
                                  fontSize: 10,
                                ),
                              );
                            }

                            List<Technician> technicians = [];
                            if (state
                                is ActiveTechniciansServiceCallsSuccessState) {
                              technicians = state.data.data;
                            }

                            int selectedCount = _selectedTechnicians.length;

                            return GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _showMultiSelectTechnicianBottomSheet(
                                  technicians,
                                );
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColor.colorFFE5E7EB,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedCount == 0
                                            ? 'reports_filter_select_technician'
                                                  .tr()
                                            : '$selectedCount ${'selected'.tr()}',
                                        style: AppFont.style(
                                          fontSize: 14,
                                          fontWeight: selectedCount == 0
                                              ? FontWeight.w700
                                              : FontWeight.w900,
                                          color: selectedCount == 0
                                              ? AppColor.colorFFA5ABB7
                                              : AppColor.colorFF0D121F,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor.colorFFA5ABB7,
                                      size: 18,
                                    ),
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

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColor.colorFFF1F2F6,
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'cancel'.tr(),
                          style: AppFont.style(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColor.colorFF6B7280,
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

                            // Show success snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('assign_tech_success_msg'.tr()),
                                backgroundColor: AppColor.green,
                              ),
                            );

                            Navigator.pop(context);
                          } else if (state
                              is AssignTechnicianServiceCallsFailureState) {
                            // Show error snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColor.bright_red,
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
                                    backgroundColor: AppColor.bright_red,
                                  ),
                                );
                                return;
                              }

                              if (_selectedCustomer == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'please_select_customer'.tr(),
                                    ),
                                    backgroundColor: AppColor.bright_red,
                                  ),
                                );
                                return;
                              }
                              if (_selectedSite == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('please_select_site'.tr()),
                                    backgroundColor: AppColor.bright_red,
                                  ),
                                );
                                return;
                              }

                              String customerId = "";
                              if (_createdCustomerIds.containsKey(
                                _selectedCustomer,
                              )) {
                                customerId =
                                    _createdCustomerIds[_selectedCustomer]!;
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
                              if (_createdSiteIds.containsKey(_selectedSite)) {
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

                              if (customerId.isEmpty || siteId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'invalid_customer_or_site_selected'.tr(),
                                    ),
                                    backgroundColor: AppColor.bright_red,
                                  ),
                                );
                                return;
                              }

                              final params = AssignTechnicianServiceCallsParams(
                                complaintId: widget.complaintId,
                                technicianIds: _selectedTechnicians
                                    .map((e) => e.id)
                                    .toList(),
                                customerId: customerId,
                                siteId: siteId,
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
                                color: const Color(
                                  0xFF1565C0,
                                ), // Active button color instead of disabled
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
                                        'assign_tech_dialog_btn'.tr(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
