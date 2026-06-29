import 'package:flutter/material.dart';
import 'package:service_app/src/core/theme/app_color.dart';
import 'package:service_app/src/core/utils/speech_to_text_helper.dart';

class SpeechToTextMicButton extends StatelessWidget {
  final TextEditingController controller;

  const SpeechToTextMicButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SpeechToTextHelper(),
      builder: (context, child) {
        final isListening = SpeechToTextHelper().isListeningTo(controller);
        return GestureDetector(
          onTap: () {
            SpeechToTextHelper().toggleListening(
              controller: controller,
              context: context,
            );
          },
          child: Icon(
            isListening ? Icons.mic : Icons.mic_off_outlined,
            color: isListening
                ? AppColor.primaryColor
                : AppColor.gray,
            size: 20,
          ),
        );
      },
    );
  }
}
