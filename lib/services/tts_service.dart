import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('ko-KR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<bool> get isSpeaking async {
    final result = await _flutterTts.awaitSpeakCompletion(true);
    return result;
  }

  void dispose() {
    _flutterTts.stop();
  }

  // Set callbacks
  void setStartHandler(Function() handler) {
    _flutterTts.setStartHandler(handler);
  }

  void setCompletionHandler(Function() handler) {
    _flutterTts.setCompletionHandler(handler);
  }

  void setErrorHandler(Function(dynamic) handler) {
    _flutterTts.setErrorHandler(handler);
  }
}
