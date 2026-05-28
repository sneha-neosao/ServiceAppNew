import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/features/my_commissioning/presentation/pages/add_commissioning_screen.dart';
import 'package:service_app/src/features/my_commissioning/presentation/widgets/commissioning_card.dart';
import 'package:service_app/src/features/my_commissioning/presentation/widgets/delete_job_dialog.dart';
import 'package:service_app/src/remote/models/commissioning_model.dart';

import 'create_commissioning_report_screen.dart';

class MyCommissioningScreen extends StatefulWidget {
  const MyCommissioningScreen({super.key});

  @override
  State<MyCommissioningScreen> createState() => _MyCommissioningScreenState();
}

class _MyCommissioningScreenState extends State<MyCommissioningScreen> {
  bool _isEditing = false;
  bool _isCreating = false;
  CommissioningModel? _selectedItem;

  @override
  Widget build(BuildContext context) {
    if (_isEditing && _selectedItem != null) {
      return AddCommissioningScreen(
        initialCustomer: _selectedItem!.companyName,
        initialSite: _selectedItem!.location,
        initialTechnicians: _selectedItem!.members,
        onBack: () => setState(() {
          _isEditing = false;
          _selectedItem = null;
        }),
      );
    }

    if (_isCreating) {
      return CreateCommissioningReportScreen(
        onBack: () => setState(() {
          _isCreating = false;
        }),
      );
    }

    final List<CommissioningModel> items = CommissioningModel.dummyList;

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return CommissioningCard(
                companyName: item.companyName,
                location: item.location,
                members: item.members,
                onEdit: () => setState(() {
                  _selectedItem = item;
                  _isEditing = true;
                }),
                onDelete: () => _showDeleteDialog(context),
                onSubmit: () => setState(() {
                  _isCreating = true;
                }),
              );
            },
          ),
        ),
      ],
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
