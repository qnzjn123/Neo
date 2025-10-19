import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
// API 키가 포함된 로컬 설정 파일
// 이 파일을 생성하려면: api_config.dart를 복사하여 api_config_local.dart로 저장하고
// 실제 API 키를 입력하세요
import '../config/api_config_local.dart' if (dart.library.io) '../config/api_config.dart';

class GPTService {
  static String get apiKey => ApiConfig.claudeApiKey;
  static String get apiUrl => ApiConfig.claudeApiUrl;

  final List<Map<String, dynamic>> _conversationHistory = [];

  Future<String> sendMessage(String message) async {
    try {
      // Add user message to history
      _conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Prepare request body for Claude API
      final requestBody = {
        'model': ApiConfig.claudeModel,
        'max_tokens': ApiConfig.maxTokens,
        'temperature': ApiConfig.temperature,
        'system': '당신은 니오(Neo)라는 이름의 친절하고 도움이 되는 AI 음성 비서입니다. 한국어로 대화하며, 자연스럽고 간결하게 답변해주세요. 음성으로 들려줄 답변이므로 너무 길지 않게 답변해주세요.',
        'messages': _conversationHistory,
      };

      print('Claude API 요청 시작...');
      print('모델: ${ApiConfig.claudeModel}');

      // Make API request to Claude
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': ApiConfig.anthropicVersion,
        },
        body: jsonEncode(requestBody),
      ).timeout(
        ApiConfig.apiTimeout,
        onTimeout: () {
          throw Exception('요청 시간 초과: 네트워크 연결을 확인해주세요');
        },
      );

      print('API 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // Claude API response format
        final assistantMessage = data['content'][0]['text'];

        // Add assistant response to history
        _conversationHistory.add({
          'role': 'assistant',
          'content': assistantMessage,
        });

        // Keep only last 10 messages to avoid token limit
        if (_conversationHistory.length > 10) {
          _conversationHistory.removeRange(0, 2); // Remove user-assistant pair
        }

        return assistantMessage;
      } else if (response.statusCode == 401) {
        print('API 오류 응답: ${response.body}');
        _conversationHistory.removeLast();
        return 'API 키가 유효하지 않습니다. 설정을 확인해주세요.';
      } else if (response.statusCode == 429) {
        print('API 오류 응답: ${response.body}');
        _conversationHistory.removeLast();
        return 'API 사용 한도를 초과했습니다. 잠시 후 다시 시도해주세요.';
      } else if (response.statusCode == 400) {
        print('API 오류 응답: ${response.body}');
        _conversationHistory.removeLast();
        return '잘못된 요청입니다. 다시 시도해주세요.';
      } else {
        print('API 오류 응답: ${response.body}');
        _conversationHistory.removeLast();
        return 'API 오류가 발생했습니다. 상태 코드: ${response.statusCode}';
      }
    } catch (e) {
      print('예외 발생: $e');
      if (_conversationHistory.isNotEmpty && _conversationHistory.last['role'] == 'user') {
        _conversationHistory.removeLast();
      }
      return '죄송합니다. 오류가 발생했습니다. 인터넷 연결을 확인해주세요.';
    }
  }

  void clearHistory() {
    _conversationHistory.clear();
  }
}
