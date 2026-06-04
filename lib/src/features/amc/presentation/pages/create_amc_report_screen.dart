import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';

class CreateAmcReportScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const CreateAmcReportScreen({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  State<CreateAmcReportScreen> createState() => _CreateAmcReportScreenState();
}

class _CreateAmcReportScreenState extends State<CreateAmcReportScreen> {
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────────
        _buildHeader(),

        // ── Progress Bar ──────────────────────────────────────────────────
        _buildProgress(),

        // ── Scrollable Body ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _currentStep == 1
                ? _buildStep1()
                : _currentStep == 2
                ? _buildStep2()
                : _buildStep3(),
          ),
        ),

        // ── Bottom Navigation ─────────────────────────────────────────────
        _buildBottomNav(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white, // Or transparent depending on background
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Color(0xFF1565C0),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'AMC REPORT',
            style: AppFont.style(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        Expanded(child: Container(height: 4, color: const Color(0xFF1565C0))),
        const SizedBox(width: 2),
        Expanded(
          child: Container(
            height: 4,
            color: _currentStep >= 2
                ? const Color(0xFF1565C0)
                : const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Container(
            height: 4,
            color: _currentStep >= 3
                ? const Color(0xFF1565C0)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header Row ────────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.business_outlined,
                color: Color(0xFFCDD0D8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flowmax Pumps',
                    style: AppFont.style(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D121F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Main Road, Suite 402, Business District,\nPune - 411045',
                    style: AppFont.style(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7A8699),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Date',
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7A8699),
                  ),
                ),
                Text(
                  '29/05/2026',
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0D121F),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 32),

        // ── Service Provider Name ──────────────────────────────────────────
        _buildSectionTitle('Service Provider Name'),
        const SizedBox(height: 12),
        Text(
          'Flowmax Pumps Corporation',
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),

        const SizedBox(height: 32),

        // ── Technician Name(s) ─────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Technician Name(s) :'),
            _buildAddButton(),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField('Pravin Patil', showMic: false),

        const SizedBox(height: 32),

        // ── Customer Info Rows ─────────────────────────────────────────────
        _buildInfoRow('Customer Name', 'Infosys Campus'),
        const SizedBox(height: 24),
        _buildInfoRow('Project / Site Name', 'Data Center B'),

        const SizedBox(height: 32),

        // ── Member Presents ───────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Member Presents (Customer Side) :'),
            _buildAddButton(),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField('Mr. Sandeep Patil', showMic: true),

        const SizedBox(height: 32),

        // ── Agenda / Purpose ──────────────────────────────────────────────
        _buildSectionTitle('Agenda / Purpose of Visit :'),
        const SizedBox(height: 12),
        _buildTextArea('Enter the main purpose of this visit...'),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inspection Checklist (Check & Tick If Found OK)',
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),

        _buildChecklistCard('MECHANICAL CHECKLIST', [
          _buildChecklistItem('Pump Foundation Bolts Tight:'),
          _buildChecklistItem('Coupling / Alignment Checked:'),
          _buildChecklistItem('Bearing Noise Checked:'),
          _buildChecklistItem('Abnormal Sound Checked:'),
          _buildChecklistItem('Mechanical Seal / Gland Leakage Checked:'),
          _buildVibrationItem(),
          _buildChecklistItem('Pump Cleaned:'),
          _buildChecklistItem('Pump Not Running Dry:'),
        ]),
        const SizedBox(height: 24),

        _buildChecklistCard('PIPELINE / HYDRAULIC CHECKLIST', [
          _buildChecklistItem('Suction Line (Air & Water) Leakage Checked:'),
          _buildChecklistItem('Delivery Line (Air & Water) Leakage Checked:'),
          _buildChecklistItem(
            'NRV / Butterfly Valve / Gate Valve Working Checked:',
          ),
          _buildChecklistItem('Strainer / Foot Valve Cleaned:'),
          _buildChecklistItem(
            'Suction / Delivery Valve Condition & Operation Checked:',
          ),
        ]),
        const SizedBox(height: 24),

        _buildChecklistCard('ELECTRICAL CHECKLIST', [
          _buildChecklistItem('Panel Cleaned:'),
          _buildChecklistItem('Contactor / Relay Condition Checked:'),
          _buildChecklistItem('Overload Setting Checked:'),
          _buildChecklistItem('Loose Wiring / Terminal Tightening Done:'),
          _buildChecklistItem('Phase / Voltage / Current Checked:'),
          _buildChecklistItem('Earthing Checked:'),
        ]),
        const SizedBox(height: 24),

        _buildChecklistCard('PUMP OPERATION CHECKLIST', [
          _buildChecklistItem('Pump Started In Manual Mode:'),
          _buildChecklistItem('Auto Operation Checked:'),
          _buildChecklistItem('Water Flow & Pressure Checked:'),
          _buildChecklistItem('Direction of Rotation Checked:'),
        ]),
      ],
    );
  }

  Widget _buildChecklistCard(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppFont.style(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(NA)',
                  style: AppFont.style(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7A8699),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5C6672),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.circle_outlined, color: Color(0xFFE5E7EB), size: 20),
        ],
      ),
    );
  }

  Widget _buildVibrationItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Vibration Checked:',
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5C6672),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.circle_outlined,
                color: Color(0xFFE5E7EB),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Normal',
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF5C6672),
                ),
              ),
              const SizedBox(width: 24),
              const Icon(
                Icons.circle_outlined,
                color: Color(0xFFE5E7EB),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'High',
                style: AppFont.style(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF5C6672),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Remarks (Technician Side) :'),
        const SizedBox(height: 12),
        _buildTextArea('Technician side remarks...'),
        const SizedBox(height: 32),

        _buildSectionTitle('Remarks (Customer Side) :'),
        const SizedBox(height: 12),
        _buildTextArea('Customer side remarks...'),
        const SizedBox(height: 32),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recorded By:',
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
              const SizedBox(height: 24),
              _buildRepSection(
                'TECHNICIAN REP',
                'Pravin Patil',
                'Digitally Signed',
              ),
              const SizedBox(height: 24),
              const Divider(color: Color(0xFFE5E7EB)),
              const SizedBox(height: 24),
              _buildRepSection(
                'CUSTOMER REP',
                'Enter Name',
                'Signature Area',
                isInput: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Row(
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Color(0xFF1565C0),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Upload / Capture Work Photos :',
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Color(0xFFA5ABB7), size: 24),
              const SizedBox(height: 8),
              Text(
                'Add Photo',
                style: AppFont.style(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFA5ABB7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildRepSection(
    String repType,
    String name,
    String signatureHint, {
    bool isInput = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          repType,
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Name : ',
              style: AppFont.style(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5C6672),
              ),
            ),
            if (isInput)
              Expanded(
                child: Text(
                  name,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFA5ABB7),
                  ),
                ),
              )
            else
              Text(
                name,
                style: AppFont.style(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Sign :',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF5C6672),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            signatureHint,
            style: AppFont.style(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFCDD0D8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppFont.style(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF5C6672),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, size: 14, color: Color(0xFF1565C0)),
          const SizedBox(width: 4),
          Text(
            'Add',
            style: AppFont.style(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
        ),
        Text(
          ':',
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0D121F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String hint, {
    bool showMic = false,
    TextEditingController? controller,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
              style: AppFont.style(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0D121F),
              ),
            ),
          ),
          if (showMic && controller != null)
            SpeechToTextMicButton(controller: controller),
        ],
      ),
    );
  }

  Widget _buildTextArea(String hint, {TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppFont.style(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFA5ABB7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: AppFont.style(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D121F),
            ),
          ),
          if (controller != null)
            Positioned(
              top: 16,
              right: 16,
              child: SpeechToTextMicButton(controller: controller),
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
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              if (_currentStep == 1) {
                widget.onBack();
              } else {
                setState(() => _currentStep--);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentStep > 1) ...[
                  const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: Color(0xFFA5ABB7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
                ] else
                  Text(
                    'Cancel',
                    style: AppFont.style(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentStep < 3) {
                setState(() => _currentStep++);
              } else {
                // Submit action
                widget.onSubmit();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentStep < 3 ? 'NEXT STEP' : 'SUBMIT AMC REPORT',
                  style: AppFont.style(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                if (_currentStep < 3) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
