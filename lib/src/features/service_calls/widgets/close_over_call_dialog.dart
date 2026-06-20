import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/assigned_service_calls_bloc/assigned_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/pending_service_calls_bloc/pending_service_calls_event.dart';
import 'package:service_app/src/features/service_calls/domain/usecase/close_over_call_usecase.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_bloc.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_event.dart';
import 'package:service_app/src/features/service_calls/bloc/close_over_call_bloc/close_over_call_state.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';
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
import 'package:service_app/src/features/widgets/app_add_new_text_button_widget.dart';
import 'package:service_app/src/features/widgets/merge_customer_dialogue_widget.dart';
import 'package:service_app/src/features/widgets/searchable_dropdown.dart';

class CloseOverCallDialog extends StatefulWidget {
  final String complaintId;
  final String complaintNo;
  final String customerName;
  final String siteName;
  final VoidCallback onSuccess;

  const CloseOverCallDialog({
    super.key,
    required this.complaintId,
    required this.complaintNo,
    required this.customerName,
    required this.siteName,
    required this.onSuccess,
  });

  @override
  State<CloseOverCallDialog> createState() => _CloseOverCallDialogState();
}

class _CloseOverCallDialogState extends State<CloseOverCallDialog> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _resolutionController = TextEditingController();
  bool _isError = false;
  late CloseOverCallBloc _bloc;
  late CustomerBloc _customerBloc;
  late SitesBloc _sitesBloc;
  late CreateNewCustomerBloc _createNewCustomerBloc;
  late CreateNewSiteBloc _createNewSiteBloc;

  List<String> _customers = [];
  String? _selectedCustomer;
  
  List<String> _sites = [];
  String? _selectedSite;
  
  final Map<String, String> _createdCustomerIds = {};
  final Map<String, String> _createdSiteIds = {};

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CloseOverCallBloc>();
    _customerBloc = getIt<CustomerBloc>()..add(const CustomerGetEvent());
    _sitesBloc = getIt<SitesBloc>();
    _createNewCustomerBloc = getIt<CreateNewCustomerBloc>();
    _createNewSiteBloc = getIt<CreateNewSiteBloc>();
  }

  void _submit() {
    if (_resolutionController.text.trim().length < 10) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('please_enter_resolution_details'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isError = true;
      });
      return;
    }

    if (_selectedCustomer == null) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('please_select_customer'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedSite == null) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('please_select_site'.tr()),
          backgroundColor: Colors.red,
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
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('invalid_customer_or_site_selected'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final params = CloseOverCallParams(
      complaintId: widget.complaintId,
      serviceCallDetails: _resolutionController.text.trim(),
      customerId: customerId,
      siteId: siteId,
    );
    _bloc.add(CloseOverCallPostEvent(params));
  }

  @override
  void dispose() {
    _bloc.close();
    _customerBloc.close();
    _sitesBloc.close();
    _createNewCustomerBloc.close();
    _createNewSiteBloc.close();
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_disabled_outlined,
                    color: Color(0xFF1565C0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'close_call_dialog_title'.tr(),
                        style: AppFont.style(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0D121F),
                        ),
                      ),
                      Text(
                        '${widget.complaintNo} - ${widget.customerName}',
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
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
            const SizedBox(height: 20),

            // Info Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F2F6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoColumn('close_call_complaint_no_label'.tr(), widget.complaintNo),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      'close_call_customer_name_label'.tr(),
                      widget.customerName,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoColumn('close_call_site_name_label'.tr(), widget.siteName),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'create_report_customer_name'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF424B5C),
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
                  onPressed: _showAddCustomerDialog
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
                  final apiNames = state.data.data.map((e) => e.name).toList();
                  _customers.addAll(apiNames);
                }
                return SearchableDropdown<String>(
                  items: _customers,
                  value: _selectedCustomer,
                  hintText: 'service_calls_filter_select_customer'.tr(),
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
                    if (val != null && state is CustomerSuccessState) {
                      final customer = state.data.data.firstWhere((c) => c.name == val);
                      _sitesBloc.add(SitesGetEvent(customer_id: customer.id));
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
                      color: const Color(0xFF424B5C),
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
                  onPressed: _showAddSiteDialog
                )
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<SitesBloc, SitesState>(
              bloc: _sitesBloc,
              builder: (context, state) {
                bool isLoading = state is SitesLoadingState;
                if (state is SitesSuccessState) {
                  _sites.clear();
                  final apiNames = state.data.data.map((e) => e.name).toList();
                  _sites.addAll(apiNames);
                }
                return Opacity(
                  opacity: _selectedCustomer == null ? 0.5 : 1.0,
                  child: SearchableDropdown<String>(
                    items: _sites,
                    value: _selectedSite,
                    hintText: 'reports_filter_select_site'.tr(),
                    isLoading: isLoading,
                    readOnly: _selectedCustomer == null,
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
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Resolution Text Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: '${'close_call_resolution_label'.tr()} ',
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                    children: const [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SpeechToTextMicButton(controller: _resolutionController),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _resolutionController,
              minLines: 3,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: AppFont.style(fontSize: 14, color: Colors.black),
              onChanged: (val) {
                if (_isError && val.trim().length >= 10) {
                  setState(() => _isError = false);
                }
              },
              decoration: InputDecoration(
                hintText:
                    'close_call_resolution_hint'.tr(),
                hintStyle: AppFont.style(
                  fontSize: 14,
                  color: const Color(0xFFD1D5DB),
                ),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isError ? Colors.red : const Color(0xFFE5E7EB),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isError ? Colors.red : const Color(0xFF1565C0),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 14,
                  color: _isError ? Colors.red : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  'close_call_min_chars'.tr(),
                  style: AppFont.style(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _isError ? Colors.red : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel'.tr(),
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                BlocConsumer<CloseOverCallBloc, CloseOverCallState>(
                  bloc: _bloc,
                  listener: (context, state) {
                    if (state is CloseOverCallSuccessState) {
                      widget.onSuccess();

                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text(state.data.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is CloseOverCallFailureState) {
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
                        if (state is! CloseOverCallLoadingState) {
                          _submit();
                        }
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1565C0,
                          ), // Make it primary blue when active
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (state is CloseOverCallLoadingState)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else
                              const Icon(
                                Icons.phone_disabled_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              'close_call_btn'.tr(),
                              style: AppFont.style(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFont.style(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
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
            body: Center(
              child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    const Icon(Icons.business_outlined, color: Color(0xFF1565C0), size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'add_new_customer'.tr(),
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close, color: Color(0xFFA5ABB7), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                const SizedBox(height: 16),
                Text(
                  'close_call_customer_name_label'.tr(),
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF424B5C),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'enter_customer_name'.tr(),
                    hintStyle: AppFont.style(
                      fontSize: 14,
                      color: const Color(0xFFA5ABB7),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    BlocConsumer<CreateNewCustomerBloc, CreateNewCustomerState>(
                      bloc: _createNewCustomerBloc,
                      listener: (context, state) {
                        if (state is CreateNewCustomerSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.data.message), backgroundColor: Colors.green),
                          );
                          final newName = state.data.data?.name ?? controller.text.trim();
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
                            Navigator.pop(ctx);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogCtx) {
                                return MergeCustomerDialogWidget(
                                  name: controller.text.trim(),
                                  bloc: _createNewCustomerBloc,
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is CreateNewCustomerLoadingState;
                        return ElevatedButton(
                          onPressed: isLoading ? null : () {
                            final text = controller.text.trim();
                            if (text.isNotEmpty) {
                              _createNewCustomerBloc.add(
                                CreateNewCustomerSubmitEvent(
                                  CreateNewCustomerParams(name: text),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B68B9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            minimumSize: const Size(0, 40),
                          ),
                          child: isLoading 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(
                                  'save_entry'.tr(),
                                  style: AppFont.style(
                                    color: Colors.white,
                                    fontSize: 14,
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

  Future<void> _showAddSiteDialog() async {
    if (_selectedCustomer == null) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(content: Text('please_select_customer'.tr()), backgroundColor: Colors.red),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('invalid_customer_or_site_selected'.tr()), backgroundColor: Colors.red),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    const Icon(Icons.location_on_outlined, color: Color(0xFF1565C0), size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'add_new_site'.tr(),
                      style: AppFont.style(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close, color: Color(0xFFA5ABB7), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
                const SizedBox(height: 16),
                Text(
                  '${'customer'.tr()} $_selectedCustomer',
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'close_call_site_name_label'.tr(),
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF424B5C),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'enter_site_name'.tr(),
                    hintStyle: AppFont.style(
                      fontSize: 14,
                      color: const Color(0xFFA5ABB7),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    BlocConsumer<CreateNewSiteBloc, CreateNewSiteState>(
                      bloc: _createNewSiteBloc,
                      listener: (context, state) {
                        if (state is CreateNewSiteSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.data.message), backgroundColor: Colors.green),
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
                            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is CreateNewSiteLoadingState;
                        return ElevatedButton(
                          onPressed: isLoading ? null : () {
                            final text = controller.text.trim();
                            if (text.isNotEmpty) {
                              _createNewSiteBloc.add(
                                CreateNewSiteSubmitEvent(
                                  CreateNewSiteParams(
                                    customerId: customerId,
                                    customerName: _selectedCustomer!,
                                    siteName: text,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B68B9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            minimumSize: const Size(0, 40),
                          ),
                          child: isLoading 
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(
                                  'save_entry'.tr(),
                                  style: AppFont.style(
                                    color: Colors.white,
                                    fontSize: 14,
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
}