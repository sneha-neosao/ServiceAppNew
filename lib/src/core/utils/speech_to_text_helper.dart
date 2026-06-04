import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextHelper extends ChangeNotifier {
  static final SpeechToTextHelper _instance = SpeechToTextHelper._internal();
  factory SpeechToTextHelper() => _instance;
  SpeechToTextHelper._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  TextEditingController? _activeController;

  /// Initialize the speech-to-text service
  Future<void> initSpeech() async {
    if (!_speechEnabled) {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
             _activeController = null;
          }
          notifyListeners();
        },
        onError: (errorNotification) {
          debugPrint('Speech error: $errorNotification');
          _activeController = null;
          notifyListeners();
        },
      );
    }
  }

  /// Start listening and append recognized text to the given [controller]
  Future<void> startListening({
    required TextEditingController controller,
    required BuildContext context,
  }) async {
    // Check permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required.')),
        );
      }
      return;
    }

    await initSpeech();

    if (_speechEnabled) {
      // Store the initial text so we can append to it
      final initialText = controller.text;
      _activeController = controller;

      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          // Append the new recognized words to the initial text
          final newText = result.recognizedWords;
          if (initialText.isNotEmpty) {
            controller.text = '$initialText $newText';
          } else {
            controller.text = newText;
          }
          // Move cursor to end
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        },
      );
      notifyListeners();
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
    _activeController = null;
    notifyListeners();
  }

  /// Toggle listening state
  Future<void> toggleListening({
    required TextEditingController controller,
    required BuildContext context,
  }) async {
    if (_speechToText.isListening) {
      await stopListening();
    } else {
      await startListening(
        controller: controller,
        context: context,
      );
    }
  }

  bool isListeningTo(TextEditingController controller) {
    return _speechToText.isListening && _activeController == controller;
  }
}
