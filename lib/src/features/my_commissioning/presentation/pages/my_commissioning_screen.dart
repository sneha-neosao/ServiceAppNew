import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/features/widgets/app_alert_dialogue_widget.dart';
import 'package:service_app/src/features/widgets/list_card_shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_list_bloc/commissioning_work_list_bloc.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/add_commissioning_screen.dart';
import 'package:service_app/src/features/my_commissioning/widgets/commissioning_card.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_delete_bloc/commissioning_work_delete_bloc.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_delete_bloc/commissioning_work_delete_event.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_delete_bloc/commissioning_work_delete_state.dart';
import 'package:service_app/src/features/widgets/snackbar_widget.dart';

import 'package:service_app/src/features/home/presentation/pages/home_screen.dart';
import 'create_commissioning_report_screen.dart';

class MyCommissioningScreen extends StatefulWidget {
  const MyCommissioningScreen({super.key});

  @override
  State<MyCommissioningScreen> createState() => MyCommissioningScreenState();
}

class MyCommissioningScreenState extends State<MyCommissioningScreen> {
  late CommissioningWorkListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CommissioningWorkListBloc>()
      ..add(CommissioningWorkListGetEvent());
  }

  void refreshList() {
    _bloc.add(CommissioningWorkListGetEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'commissioning_section_title'.tr(),
                      style: AppFont.style(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D121F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Count badge
                  BlocBuilder<CommissioningWorkListBloc, CommissioningWorkListState>(
                    bloc: _bloc,
                    builder: (context, state) {
                      if (state is CommissioningWorkListInitialState ||
                          state is CommissioningWorkListLoadingState) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                      
                      int count = 0;
                      if (state is CommissioningWorkListSuccessState) {
                        count = state.data.data.length;
                      }

                      return Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1565C0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: AppFont.style(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── List ─────────────────────────────────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0B68B9),
                onRefresh: () async {
                  _bloc.add(CommissioningWorkListGetEvent());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: BlocBuilder<CommissioningWorkListBloc, CommissioningWorkListState>(
                  bloc: _bloc,
                  builder: (context, state) {
                  if (state is CommissioningWorkListInitialState ||
                      state is CommissioningWorkListLoadingState) {
                    return ListView.separated(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 100),
                      itemCount: 3,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => const ListCardShimmer(),
                    );
                  } else if (state is CommissioningWorkListFailureState) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Text(
                              state.message,
                              style: AppFont.style(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is CommissioningWorkListSuccessState) {
                    final items = state.data.data;
                    
                    if (items.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: Text(
                                'no_commissioning_work_message'.tr(),
                                style: AppFont.style(
                                  fontSize: 14,
                                  color: const Color(0xFFA5ABB7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 100),
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final membersString = item.assignedTechnicians.isNotEmpty
                            ? item.assignedTechnicians
                                  .map((t) => t.name)
                                  .join(', ')
                            : 'no_technician_assigned'.tr();

                        return CommissioningCard(
                          companyName: item.customer.name,
                          equipmentName: item.applicationOfEquipment,
                          location: item.site.name,
                          members: membersString,
                          onEdit: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCommissioningScreen(
                                  editWorkId: item.id,
                                  onBack: () => Navigator.pop(context),
                                ),
                              ),
                            );
                            _bloc.add(CommissioningWorkListGetEvent());
                          },
                          onDelete: () => _showDeleteDialog(context, item.id),
                          onSubmit: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateCommissioningReportScreen(
                                      commissioningWorkId: item.id,
                                      onBack: () => Navigator.pop(context),
                                    ),
                              ),
                            );
                            _bloc.add(CommissioningWorkListGetEvent());
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String workId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (_) => getIt<CommissioningWorkDeleteBloc>(),
          child: BlocConsumer<CommissioningWorkDeleteBloc, CommissioningWorkDeleteState>(
            listener: (context, state) {
              if (state is CommissioningWorkDeleteSuccessState) {
                Navigator.pop(dialogContext);
                appSnackBar(
                  context,
                  const Color(0xFF4CAF50),
                  state.message,
                );
                _bloc.add(CommissioningWorkListGetEvent());
              } else if (state is CommissioningWorkDeleteFailureState) {
                Navigator.pop(dialogContext);
                appSnackBar(
                  context,
                  const Color(0xFFF44336),
                  state.message,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is CommissioningWorkDeleteLoadingState;
              return AppAlertDialogWidget(
                title: 'delete_work'.tr(),
                subtitle: 'delete_work_subtitle'.tr(),
                confirmText: 'delete_now'.tr(),
                cancelText: 'cancel'.tr(),
                icon: Icons.error_outline,
                iconBgColor: const Color(0xFFFFF1F0),
                iconColor: const Color(0xFFFF4D4F),
                confirmBtnColor: const Color(0xFFE30000),
                isLoading: isLoading,
                onConfirm: isLoading
                    ? () {}
                    : () {
                  context.read<CommissioningWorkDeleteBloc>().add(
                    CommissioningWorkDeleteSubmitEvent(workId),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

}



