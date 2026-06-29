part of '../presentation/pages/create_commissioning_report_screen.dart';

class Step5Widget extends StatelessWidget {
  final _CreateCommissioningReportScreenState parent;
  const Step5Widget({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ─────────────────────────────────────────────────────────────
        Text(
          'commissioning_preventive_checklist_title'.tr(),
          textAlign: TextAlign.center,
          style: AppFont.style(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColor.colorFF0D121F,
          ),
        ),
        const SizedBox(height: 28),
        // ── Mechanical Checklist ───────────────────────────────────────────────
        parent._buildCheckSection(
          icon: Icons.settings_outlined,
          title: 'commissioning_mechanical_checklist'.tr(),
          isNA: parent._mechNA,
          onNATap: () => parent.updateState(() => parent._mechNA = !parent._mechNA),
          items: [
            parent._buildCheckItem(
              label: 'chk_bearing_noise'.tr(),
              selected: parent._bearingNoise,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._bearingNoise = v),
            ),
            parent._buildCheckItem(
              label: 'chk_vibration'.tr(),
              selected: parent._vibration,
              options: const ['normal', 'high'],
              labels: ['commissioning_normal'.tr(), 'commissioning_high'.tr()],
              onSelect: (v) => parent.updateState(() => parent._vibration = v),
            ),
            parent._buildCheckItem(
              label: 'chk_mech_seal'.tr(),
              selected: parent._mechSeal,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._mechSeal = v),
            ),
            parent._buildCheckItem(
              label: 'chk_pump_dry'.tr(),
              selected: parent._pumpDry,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._pumpDry = v),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // ── Pipeline / Hydraulic Checklist ────────────────────────────────────
        parent._buildCheckSection(
          icon: Icons.water_drop_outlined,
          title: 'commissioning_pipeline_hydraulic_checklist'.tr(),
          isNA: parent._pipeNA,
          onNATap: () => parent.updateState(() => parent._pipeNA = !parent._pipeNA),
          items: [
            parent._buildCheckItem(
              label: 'chk_nrv'.tr(),
              selected: parent._nrvValve,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._nrvValve = v),
            ),
            parent._buildCheckItem(
              label: 'chk_strainer'.tr(),
              selected: parent._strainerValve,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._strainerValve = v),
            ),
            parent._buildCheckItem(
              label: 'chk_suction_line'.tr(),
              selected: parent._suctionLine,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._suctionLine = v),
            ),
            parent._buildCheckItem(
              label: 'chk_delivery_line'.tr(),
              selected: parent._deliveryLine,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._deliveryLine = v),
            ),
            parent._buildCheckItem(
              label: 'chk_suction_del_valve'.tr(),
              selected: parent._suctionDelivery,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._suctionDelivery = v),
            ),
            parent._buildCheckItem(
              label: 'chk_pressure_switch'.tr(),
              selected: parent._pressureSwitch,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._pressureSwitch = v),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // ── Electrical Checklist ───────────────────────────────────────────────
        parent._buildCheckSection(
          icon: Icons.bolt_outlined,
          title: 'commissioning_electrical_checklist'.tr(),
          isNA: parent._elecNA,
          onNATap: () => parent.updateState(() => parent._elecNA = !parent._elecNA),
          items: [
            parent._buildCheckItem(
              label: 'chk_elec_faults'.tr(),
              selected: parent._elecFaults,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._elecFaults = v),
            ),
            parent._buildCheckItem(
              label: 'chk_voltage'.tr(),
              selected: parent._voltage,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._voltage = v),
            ),
            parent._buildCheckItem(
              label: 'chk_phase'.tr(),
              selected: parent._phase,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._phase = v),
            ),
            parent._buildCheckItem(
              label: 'chk_current'.tr(),
              selected: parent._current,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._current = v),
            ),
            parent._buildCheckItem(
              label: 'chk_panel_wiring'.tr(),
              selected: parent._panelWiring,
              options: const ['ok', 'not_ok'],
              labels: ['commissioning_ok'.tr(), 'commissioning_not_ok'.tr()],
              onSelect: (v) => parent.updateState(() => parent._panelWiring = v),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
