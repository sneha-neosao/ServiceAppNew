import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_font.dart';
import 'package:service_app/src/core/utils/speech_to_text_mic_button.dart';

class ReportLabel extends StatelessWidget {
  final String text;
  const ReportLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFont.style(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFA5ABB7),
      ),
    );
  }
}

class ReportTextField extends StatelessWidget {
  final String hint;
  final bool isLarge;

  const ReportTextField({super.key, required this.hint, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Text(
        hint,
        style: AppFont.style(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFA5ABB7),
        ),
      ),
    );
  }
}

class ReportDropdownField extends StatelessWidget {
  final String hint;

  const ReportDropdownField({super.key, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFA5ABB7),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFA5ABB7)),
        ],
      ),
    );
  }
}

class ReportInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ReportInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C6672),
            ),
          ),
        ),
        Text(
          ':',
          style: AppFont.style(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFA5ABB7),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: AppFont.style(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0D121F),
            ),
          ),
        ),
      ],
    );
  }
}

class ReportRemarksBox extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;

  const ReportRemarksBox({super.key, required this.placeholder, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  style: AppFont.style(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D121F),
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: AppFont.style(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFA5ABB7),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (controller != null)
                SpeechToTextMicButton(controller: controller!),
            ],
          ),
          const SizedBox(height: 80),
          const Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.format_indent_increase, size: 16, color: Color(0xFF0D121F)),
          ),
        ],
      ),
    );
  }
}
