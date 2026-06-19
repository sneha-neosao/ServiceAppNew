part of '../presentation/pages/create_commissioning_report_screen.dart';

class Step1Widget extends StatelessWidget {
  final _CreateCommissioningReportScreenState parent;
  final dynamic data;
  const Step1Widget({Key? key, required this.parent, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dealer Information Card ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   width: 48,
              //   height: 48,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF8F9FB),
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(color: const Color(0xFFF1F2F6)),
              //   ),
              //   child: const Icon(
              //     Icons.business_outlined,
              //     color: Color(0xFFA5ABB7),
              //     size: 24,
              //   ),
              // ),
              // const SizedBox(width: 12),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         data?.dealerName ??
              //             'commissioning_dealer_name_fallback'.tr(),
              //         style: AppFont.style(
              //           fontSize: 16,
              //           fontWeight: FontWeight.w900,
              //           color: const Color(0xFF0D121F),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'commissioning_date'.tr(),
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF8E9BAE),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMMM yyyy').format(DateTime.now()),
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // ── Technician Name(s) ──────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'commissioning_technician_names'.tr(),
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5C6672),
                    ),
                  ),
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            AppAddNewTextButtonWidget(
                onPressed: () {
                  parent.updateState(() {
                    parent._technicians.add(TextEditingController());
                    parent._technicianIds.add(null);
                  });
                }
            )
          ],
        ),
        const SizedBox(height: 16),
        ...parent._technicians.asMap().entries.map((entry) {
          int idx = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<TechnicianBloc, TechnicianState>(
                    bloc: parent._technicianBloc,
                    builder: (context, state) {
                      bool isLoading = state is TechnicianLoadingState;
                      List<dynamic> validItems = [];
                      if (state is TechnicianSuccessState) {
                        validItems = List.from(state.data.data);
                      }
                      final otherSelected = parent._technicians
                          .where((c) => c != controller && c.text.isNotEmpty)
                          .map((c) => c.text)
                          .toSet();
                      validItems.removeWhere(
                        (item) => otherSelected.contains(item.name),
                      );
                      
                      return Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: controller,
                            onChanged: (val) {
                              parent._technicianIds[idx] = ''; // Manual input, clear ID
                            },
                            decoration: InputDecoration(
                              hintText: 'commissioning_select_technician'.tr(),
                              hintStyle: AppFont.style(
                                fontSize: 16,
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
                                        parent._showTechnicianBottomSheet(
                                          context,
                                          validItems,
                                          controller,
                                          idx,
                                        );
                                      },
                                    ),
                            ),
                            style: AppFont.style(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0D121F),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (parent._technicians.length > 1) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      parent.updateState(() {
                        var removed = parent._technicians.removeAt(idx);
                        parent._technicianIds.removeAt(idx);
                        removed.dispose();
                      });
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFFF5252),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
        // ── Customer & Project Details ───────────────────────────────────
        parent._buildInfoRow(
          'commissioning_customer_name_label'.tr(),
          data?.customerName ?? 'commissioning_customer_name_fallback'.tr(),
        ),
        const SizedBox(height: 24),
        parent._buildInfoRow(
          'commissioning_project_site_name_label'.tr(),
          data?.siteName ?? 'commissioning_project_site_name_fallback'.tr(),
        ),
        const SizedBox(height: 24),
        if (parent.widget.isServiceReport)
          parent._buildInfoRow(
            'commissioning_complaint_number_label'.tr(),
            parent.widget.complaintNo ??
                'commissioning_complaint_number_fallback'.tr(),
          ),
        const SizedBox(height: 40),
      ],
    );
  }
}
