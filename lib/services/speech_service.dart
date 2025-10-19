import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    // Request microphone permission
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      return false;
    }

    _isInitialized = await _speech.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );

    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function() onComplete,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized && !_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
          if (result.finalResult) {
            onComplete();
          }
        },
        localeId: 'ko_KR',
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  bool get isListening => _speech.isListening;

  bool get isAvailable => _isInitialized;

  void dispose() {
    _speech.cancel();
  }
}
