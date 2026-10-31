import 'package:speech_to_text/speech_to_text.dart';

class QuizVoiceService {
  final SpeechToText _speech = SpeechToText();

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    return await _speech.initialize(
      onStatus: (status) {
        print("Speech Status => $status");
      },
      onError: (error) {
        print("Speech Error => $error");
      },
    );
  }

  Future<void> startListening({
    required Function(String text) onResult,
  }) async {
    final available = await initialize();

    if (!available) {
      print("Speech recognition unavailable");
      return;
    }

    await _speech.listen(
      localeId: "ar_EG",
      listenMode: ListenMode.confirmation,
      partialResults: false,
      cancelOnError: true,
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }
}