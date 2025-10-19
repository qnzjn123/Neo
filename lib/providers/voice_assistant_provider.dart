import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gpt_service.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';

class VoiceAssistantProvider extends ChangeNotifier {
  final GPTService _gptService = GPTService();
  final SpeechService _speechService = SpeechService();
  final TtsService _ttsService = TtsService();

  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isProcessing = false;
  String _currentTranscript = '';

  List<ChatMessage> get messages => _messages;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isProcessing => _isProcessing;
  String get currentTranscript => _currentTranscript;

  VoiceAssistantProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _speechService.initialize();
    await _ttsService.initialize();
  }

  Future<void> toggleListening() async {
    if (_isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> startListening() async {
    _currentTranscript = '';
    _isListening = true;
    notifyListeners();

    await _speechService.startListening(
      onResult: (text) {
        _currentTranscript = text;
        notifyListeners();
      },
      onComplete: () async {
        await _processUserInput(_currentTranscript);
      },
    );
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    _isListening = false;
    notifyListeners();
  }

  Future<void> _processUserInput(String text) async {
    if (text.isEmpty) {
      _isListening = false;
      notifyListeners();
      return;
    }

    _isListening = false;
    _isProcessing = true;

    // Add user message
    _messages.add(ChatMessage(text: text, isUser: true));
    notifyListeners();

    try {
      // Get response from GPT
      final response = await _gptService.sendMessage(text);

      // Add assistant message
      _messages.add(ChatMessage(text: response, isUser: false));
      notifyListeners();

      // Speak the response
      _isSpeaking = true;
      _isProcessing = false;
      notifyListeners();

      await _ttsService.speak(response);

      _isSpeaking = false;
      notifyListeners();
    } catch (e) {
      _isProcessing = false;
      _isSpeaking = false;
      _messages.add(
        ChatMessage(
          text: '죄송합니다. 오류가 발생했습니다.',
          isUser: false,
        ),
      );
      notifyListeners();
    }

    _currentTranscript = '';
  }

  void clearMessages() {
    _messages.clear();
    _gptService.clearHistory();
    notifyListeners();
  }

  @override
  void dispose() {
    _speechService.dispose();
    _ttsService.dispose();
    super.dispose();
  }
}
