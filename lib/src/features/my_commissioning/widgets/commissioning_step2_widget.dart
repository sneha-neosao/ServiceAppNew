part of '../presentation/pages/create_commissioning_report_screen.dart';

class Step2Widget extends StatelessWidget {
  final _CreateCommissioningReportScreenState parent;
  const Step2Widget({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Member Context Label ─────────────────────────────────────────
        // parent._buildLabel('commissioning_member_context_label'.tr()),
        const SizedBox(height: 12),
        // const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        // const SizedBox(height: 32),
        // ── Member Presents ─────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'commissioning_customer_members'.tr(),
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5C6672),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                ':',
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE5E7EB),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: parent._representatives.asMap().entries.map((entry) {
                  int idx = entry.key;
                  TextEditingController controller = entry.value;
                  bool isFirst = idx == 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                style: AppFont.style(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF0D121F),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'commissioning_representative'.tr(),
                                  hintStyle: AppFont.style(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFFA5ABB7),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            SpeechToTextMicButton(controller: controller),
                            const SizedBox(width: 12),
                            if (isFirst)
                              AppAddNewTextButtonWidget(
                                  onPressed: () {
                                    parent.updateState(() {
                                      parent._representatives.add(
                                        TextEditingController(),
                                      );
                                    });
                                  }
                              )
                            else
                              GestureDetector(
                                onTap: () {
                                  parent.updateState(() {
                                    var removed = parent._representatives.removeAt(
                                      idx,
                                    );
                                    removed.dispose();
                                  });
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Color(0xFFFF5252),
                                  size: 24,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF1F2F6),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // ── Select Warranty Period (Hidden for Service Report) ───────────
        if (!parent.widget.isServiceReport) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'commissioning_select_warranty_period_label'.tr(),
                        style: AppFont.style(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF5C6672),
                        ),
                      ),
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
              const SizedBox(width: 8),
              Expanded(
                child: SearchableDropdown<String>(
                  items: parent._warrantySearchQuery.isEmpty
                      ? const ['1_year', '2_year', '3_year', '4_year', '5_year']
                      : ['1_year', '2_year', '3_year', '4_year', '5_year']
                          .where((val) =>
                              val.tr().toLowerCase().contains(parent._warrantySearchQuery.toLowerCase()))
                          .toList(),
                  value: parent._selectedWarranty,
                  hintText: 'commissioning_select_period'.tr(),
                  itemAsString: (val) => val.tr(),
                  // icon: const Icon(
                  //   Icons.keyboard_arrow_down,
                  //   color: Color(0xFFA5ABB7),
                  // ),
                  onChanged: (val) {
                    parent.updateState(() {
                      parent._selectedWarranty = val;
                      parent._warrantySearchQuery = '';
                    });
                  },
                  onSearchChanged: (query) {
                    parent.updateState(() {
                      parent._warrantySearchQuery = query;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
        // ── Purpose of Visit Section ─────────────────────────────────────
        parent._buildLabel('commissioning_agenda_title'.tr()),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        // ── Purpose Text Area ────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Stack(
            children: [
              TextField(
                controller: parent._agendaController,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: AppFont.style(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'commissioning_agenda_hint'.tr(),
                  hintStyle: AppFont.style(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: SpeechToTextMicButton(controller: parent._agendaController),
              ),
              const Positioned(
                bottom: 8,
                right: 8,
                child: Icon(
                  Icons.signal_cellular_4_bar,
                  size: 12,
                  color: Color(0xFFA5ABB7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
