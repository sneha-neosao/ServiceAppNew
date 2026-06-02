import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/src/configs/injector/injector_conf.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/bloc/commissioning_work_list_bloc/commissioning_work_list_bloc.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/add_commissioning_screen.dart';
import 'package:service_app/src/features/my_commissioning/widgets/commissioning_card.dart';
import 'package:service_app/src/features/my_commissioning/widgets/delete_job_dialog.dart';

import 'create_commissioning_report_screen.dart';

class MyCommissioningScreen extends StatefulWidget {
  const MyCommissioningScreen({super.key});

  @override
  State<MyCommissioningScreen> createState() => _MyCommissioningScreenState();
}

class _MyCommissioningScreenState extends State<MyCommissioningScreen> {
  late CommissioningWorkListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<CommissioningWorkListBloc>()
      ..add(CommissioningWorkListGetEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddCommissioningScreen(onBack: () => Navigator.pop(context)),
            ),
          );
          _bloc.add(CommissioningWorkListGetEvent());
        },
        backgroundColor: const Color(0xFF0B68B9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: BlocBuilder<CommissioningWorkListBloc, CommissioningWorkListState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is CommissioningWorkListInitialState ||
              state is CommissioningWorkListLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            );
          } else if (state is CommissioningWorkListFailureState) {
            return Center(
              child: Text(
                state.message,
                style: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            );
          } else if (state is CommissioningWorkListSuccessState) {
            final items = state.data.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section header ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'commissioning_section_title'.tr(),
                          style: AppFont.style(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Count badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1565C0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${items.length}',
                            style: AppFont.style(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── List ─────────────────────────────────────────────────────────────
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final membersString = item.assignedTechnicians.isNotEmpty
                          ? item.assignedTechnicians
                                .map((t) => t.name)
                                .join(', ')
                          : 'No technicians assigned';

                      return CommissioningCard(
                        companyName: item.customer.name,
                        location: item.site.name,
                        members: membersString,
                        onEdit: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCommissioningScreen(
                                initialCustomer: item.customer.name,
                                initialSite: item.site.name,
                                initialTechnicians: membersString,
                                onBack: () => Navigator.pop(context),
                              ),
                            ),
                          );
                          _bloc.add(CommissioningWorkListGetEvent());
                        },
                        onDelete: () => _showDeleteDialog(context),
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
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DeleteJobDialog(
          onConfirm: () {
            // Handle deletion
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
