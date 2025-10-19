# 니오 (Neo) - AI 음성 비서

Claude 3.5 Sonnet 기반의 한국어 AI 음성 비서 애플리케이션입니다.

## 기능

- 🎤 **음성 인식**: 한국어 음성을 텍스트로 변환
- 🤖 **Claude 3.5 Sonnet AI**: Anthropic의 최신 AI 모델을 사용한 지능형 대화
- 🔊 **음성 출력**: 텍스트를 한국어 음성으로 변환
- 💬 **대화 기록**: 이전 대화 내용을 기억하는 컨텍스트 기반 대화
- 🎨 **모던 UI**: 그라데이션과 애니메이션을 활용한 세련된 디자인

## 시작하기

### 사전 요구사항

- Flutter SDK (3.9.2 이상)
- Dart SDK
- Android Studio / Xcode (iOS 개발시)
- Claude API 키 ([Anthropic Console](https://console.anthropic.com/)에서 발급)

### 설치

1. 저장소 클론:
```bash
git clone https://github.com/qnzjn123/Neo.git
cd Neo
```

2. 의존성 설치:
```bash
flutter pub get
```

3. **API 키 설정** (중요!):
   - `lib/config/api_config.dart` 파일을 복사하여 `lib/config/api_config_local.dart` 생성
   - `api_config_local.dart` 파일의 `claudeApiKey`에 실제 API 키 입력
   
```dart
class ApiConfig {
  static const String claudeApiKey = '여기에_실제_API_키_입력';
  // ...
}
```

**주의**: `api_config_local.dart`는 .gitignore에 포함되어 있어 GitHub에 업로드되지 않습니다.
```

3. 앱 실행:
```bash
flutter run
```

## 사용 방법

1. 앱을 실행합니다
2. 마이크 버튼을 탭합니다
3. 질문이나 요청사항을 말합니다
4. 니오가 음성으로 답변합니다

## 주요 기술 스택

- **Flutter**: 크로스 플랫폼 모바일 앱 프레임워크
- **Provider**: 상태 관리
- **speech_to_text**: 음성 인식
- **flutter_tts**: 텍스트 음성 변환
- **GPT-4o API**: OpenAI의 최신 AI 모델
- **animate_do**: 애니메이션
- **avatar_glow**: 글로우 효과

## 프로젝트 구조

```
lib/
├── main.dart                           # 앱 진입점
├── models/
│   └── chat_message.dart              # 채팅 메시지 모델
├── providers/
│   └── voice_assistant_provider.dart   # 상태 관리
├── screens/
│   └── voice_assistant_screen.dart     # 메인 화면
├── services/
│   ├── gpt_service.dart               # GPT-4o API 서비스
│   ├── speech_service.dart            # 음성 인식 서비스
│   └── tts_service.dart               # TTS 서비스
└── widgets/
    ├── chat_bubble.dart               # 채팅 버블 위젯
    └── voice_button.dart              # 음성 버튼 위젯
```

## 권한

### Android
- `RECORD_AUDIO`: 음성 인식
- `INTERNET`: API 호출
- `BLUETOOTH`: 블루투스 오디오

### iOS
- `NSMicrophoneUsageDescription`: 마이크 접근
- `NSSpeechRecognitionUsageDescription`: 음성 인식

## 라이선스

이 프로젝트는 개인 사용 목적으로 제작되었습니다.

## 주의사항

- API 키는 보안을 위해 환경 변수로 관리하는 것을 권장합니다
- 음성 인식은 인터넷 연결이 필요합니다
- GPT-4o API 사용에는 비용이 발생할 수 있습니다
