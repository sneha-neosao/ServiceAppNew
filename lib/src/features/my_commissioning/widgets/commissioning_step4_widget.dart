part of '../presentation/pages/create_commissioning_report_screen.dart';

class Step4Widget extends StatelessWidget {
  final _CreateCommissioningReportScreenState parent;
  const Step4Widget({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Work Description Label ──────────────────────────────────────
        Center(
          child: Text(
            (parent.widget.isServiceReport
                    ? 'service_work_description'
                    : 'commissioning_work_description')
                .tr(),
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColor.colorFFA5ABB7,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: AppColor.colorFFF1F2F6),
        const SizedBox(height: 24),
        // ── Work Description Fields ──────────────────────────────────────
        ...List.generate(
          parent._workDescriptionControllers.length,
          (index) => parent._buildWorkDescriptionField(
            index + 1,
            parent._workDescriptionControllers[index],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AppAddNewTextButtonWidget(
              onPressed: () {
                parent.updateState(() {
                  parent._workDescriptionControllers.add(TextEditingController());
                });
              }
          )
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
