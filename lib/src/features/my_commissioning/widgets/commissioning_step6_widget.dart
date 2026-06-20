part of '../presentation/pages/create_commissioning_report_screen.dart';

class Step6Widget extends StatelessWidget {
  final _CreateCommissioningReportScreenState parent;
  const Step6Widget({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Remarks (Technician Side) ─────────────────────────────────
        Text(
          'commissioning_remarks_tech'.tr(),
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 10),
        parent._buildRemarksBox(
          'enter_technical_remark'.tr(),
          parent._technicianRemarksController,
        ),
        const SizedBox(height: 28),
        // ── Remarks (Customer Side) ──────────────────────────────────
        Text(
          'commissioning_remarks_customer'.tr(),
          style: AppFont.style(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF6B7180),
          ),
        ),
        const SizedBox(height: 10),
        parent._buildRemarksBox(
          'enter_customer_remark'.tr(),
          parent._customerRemarksController,
        ),
        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),
        // ── Recorded By ────────────────────────────────────────────
        Text(
          'commissioning_recorded_by'.tr(),
          style: AppFont.style(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0D121F),
          ),
        ),
        const SizedBox(height: 24),
        // Technician Rep
        Text(
          'commissioning_tech_rep'.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'commissioning_name'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                     TextSpan(
                      text: 'asterisk'.tr(),
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
             Text(':', style: TextStyle(color: Color(0xFF8E9BAE))),
            const SizedBox(width: 8),
            Expanded(
              child: parent.widget.isServiceReport
                  ? SearchableDropdown<service_tech_model.AssignedTechnician>(
                      items: parent._assignedServiceCallTechniciansList,
                      itemAsString: (t) => t.name,
                      value: parent._assignedServiceCallTechniciansList
                          .where((t) => t.assignId == parent._selectedTechnicianRepId)
                          .firstOrNull,
                      onChanged: (val) {
                        parent.updateState(() {
                          parent._selectedTechnicianRepId = val?.assignId;
                        });
                      },
                      hintText: 'commissioning_select_technician'.tr(),
                      readOnly: true,
                    )
                  : SearchableDropdown<AssignedTechnician>(
                      items: parent._assignedTechniciansList,
                      itemAsString: (t) => t.name,
                      value: parent._assignedTechniciansList
                          .where((t) => t.assignId == parent._selectedTechnicianRepId)
                          .firstOrNull,
                      onChanged: (val) {
                        parent.updateState(() {
                          parent._selectedTechnicianRepId = val?.assignId;
                        });
                      },
                      hintText: 'commissioning_select_technician'.tr(),
                      readOnly: true,
                    ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        parent._buildSignatureBox(
          label: 'commissioning_sign_star'.tr(),
          placeholder: 'commissioning_tap_sign'.tr(),
          signatureFile: parent._technicianSignatureFile,
          existingUrl: parent._existingTechnicianSignatureUrl,
          onTap: () {
            parent._showSignatureDrawingPad(context, (file) {
              parent.updateState(() {
                parent._technicianSignatureFile = file;
              });
            });
          },
          onClear: () {
            parent.updateState(() {
              parent._technicianSignatureFile = null;
              parent._existingTechnicianSignatureUrl = null;
            });
          },
        ),
        const SizedBox(height: 36),
        // Customer Rep
        Text(
          'commissioning_customer_rep'.tr(),
          style: AppFont.style(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFA5ABB7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 16),
        // Editable name field
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'commissioning_name'.tr(),
                      style: AppFont.style(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF8E9BAE),
                      ),
                    ),
                     TextSpan(
                      text: 'asterisk'.tr(),
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
              child: TextField(
                controller: parent._customerRepNameController,
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D121F),
                ),
                decoration: InputDecoration(
                  hintText: 'commissioning_enter_name'.tr(),
                  hintStyle: AppFont.style(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA5ABB7),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD8DCE6)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF1565C0),
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            SpeechToTextMicButton(controller: parent._customerRepNameController),
          ],
        ),
        const SizedBox(height: 16),
        parent._buildSignatureBox(
          label: 'commissioning_sign_star'.tr(),
          placeholder: 'commissioning_tap_sign'.tr(),
          signatureFile: parent._customerSignatureFile,
          existingUrl: parent._existingCustomerSignatureUrl,
          onTap: () {
            parent._showSignatureDrawingPad(context, (file) {
              parent.updateState(() {
                parent._customerSignatureFile = file;
              });
            });
          },
          onClear: () {
            parent.updateState(() {
              parent._customerSignatureFile = null;
              parent._existingCustomerSignatureUrl = null;
            });
          },
        ),
        const SizedBox(height: 36),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F2F6)),
        const SizedBox(height: 28),
        // ── Upload / Capture Work Photos ──────────────────────────────
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'commissioning_upload_work_photos'.tr(),
                style: AppFont.style(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0D121F),
                ),
              ),
              const TextSpan(
                text: 'asterisk',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Render existing network photos
            ...parent._existingWorkPhotosUrls.map((url) {
              return Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        parent.updateState(() {
                          parent._existingWorkPhotosUrls.remove(url);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            // Render selected local photos
            ...parent._workPhotos.map((file) {
              return Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        parent.updateState(() {
                          parent._workPhotos.remove(file);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            // Upload Photo tile
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final List<XFile> files = await picker.pickMultiImage();
                if (files.isNotEmpty) {
                  parent.updateState(() {
                    parent._workPhotos.addAll(files.map((e) => File(e.path)));
                  });
                }
              },
              child: CustomPaint(
                painter: _DashedBorderPainter(color: const Color(0xFFCDD0D8)),
                child: Container(
                  width: 110,
                  height: 110,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 28, color: Color(0xFFA5ABB7)),
                      const SizedBox(height: 6),
                      Text(
                        'upload'.tr(),
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Capture Photo tile
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  parent.updateState(() {
                    parent._workPhotos.add(File(file.path));
                  });
                }
              },
              child: CustomPaint(
                painter: _DashedBorderPainter(color: const Color(0xFFCDD0D8)),
                child: Container(
                  width: 110,
                  height: 110,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFFA5ABB7)),
                      const SizedBox(height: 6),
                      Text(
                        'capture'.tr(),
                        style: AppFont.style(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFA5ABB7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
