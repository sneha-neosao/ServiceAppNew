part of '../presentation/pages/create_commissioning_report_screen.dart';

class Step3Widget extends StatelessWidget {
  final _CreateCommissioningReportScreenState parent;
  const Step3Widget({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Technical Details ───────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'commissioning_technical_details'.tr(),
              style: AppFont.style(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => parent.updateState(
                    () => parent._isTechnicalDetailsNA = !parent._isTechnicalDetailsNA,
                  ),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: parent._isTechnicalDetailsNA
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFA5ABB7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: parent._isTechnicalDetailsNA
                          ? const Color(0xFF1565C0)
                          : Colors.white,
                    ),
                    child: parent._isTechnicalDetailsNA
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'commissioning_na_paren'.tr(),
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 32),
        // ── Input Fields ────────────────────────────────────────────────
        IgnorePointer(
          ignoring: parent._isTechnicalDetailsNA,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: parent._isTechnicalDetailsNA ? 0.38 : 1.0,
            child: Column(
              children: [
                parent._buildTechField(
                  'commissioning_pump_make'.tr(),
                  parent._pumpMakeController,
                ),
                parent._buildTechField(
                  'commissioning_pump_model'.tr(),
                  parent._pumpModelController,
                ),
                parent._buildTechField(
                  'commissioning_pump_serial_number'.tr(),
                  parent._pumpSerialNumberController,
                ),
                parent._buildTechMultiField(
                  'commissioning_pump_flow'.tr(),
                  ['lpm'.tr(), 'm3_hr'.tr(), 'lps'.tr(), 'usgpm'.tr()],
                  [
                    parent._pumpFlowLPMController,
                    parent._pumpFlowM3HRController,
                    parent._pumpFlowLPSController,
                    parent._pumpFlowUSGPMController,
                  ],
                ),
                parent._buildTechMultiField(
                  'commissioning_pump_head'.tr(),
                  ['mtr'.tr()],
                  [parent._pumpHeadMTRController],
                ),
                parent._buildTechField(
                  'commissioning_driver_make'.tr(),
                  parent._driverMakeController,
                ),
                parent._buildTechField(
                  'commissioning_driver_serial_number'.tr(),
                  parent._driverSerialNumberController,
                ),
                parent._buildTechMultiField(
                  'commissioning_rating'.tr(),
                  ['kw'.tr(), 'hp'.tr()],
                  [parent._ratingKWController, parent._ratingHPController],
                ),
                parent._buildTechField('commissioning_rpm'.tr(), parent._rpmController),
                parent._buildTechField(
                  'commissioning_control_panel_make'.tr(),
                  parent._controlPanelMakeController,
                ),
                parent._buildTechField(
                  'commissioning_panel_serial_model'.tr(),
                  parent._panelSerialModelController,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
