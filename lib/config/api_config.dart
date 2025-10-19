class ApiConfig {
  // Claude API 키
  // API 키는 https://console.anthropic.com/ 에서 생성할 수 있습니다
  // 보안을 위해 실제 API 키는 여기에 직접 입력하지 마세요!
  // 실제 사용 시 환경 변수나 별도의 설정 파일을 사용하세요
  static const String claudeApiKey = 'YOUR_CLAUDE_API_KEY_HERE';

  // API 엔드포인트
  static const String claudeApiUrl = 'https://api.anthropic.com/v1/messages';

  // Claude 모델 설정
  static const String claudeModel = 'claude-3-5-sonnet-20241022';

  // API 버전
  static const String anthropicVersion = '2023-06-01';

  // 기타 설정
  static const double temperature = 0.7;
  static const int maxTokens = 1024;
  static const Duration apiTimeout = Duration(seconds: 30);
}
