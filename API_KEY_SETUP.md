# OpenAI API 키 설정 가이드

## 1. OpenAI API 키 발급받기

1. [OpenAI Platform](https://platform.openai.com/api-keys) 접속
2. 로그인 후 "Create new secret key" 클릭
3. API 키 이름 입력 (예: "Neo Voice Assistant")
4. **전체 API 키를 복사** (한 번만 표시됩니다!)

## 2. API 키 설정하기

API 키는 `sk-proj-` 또는 `sk-` 로 시작하며, 매우 긴 문자열입니다.

### 방법: api_config.dart 파일 수정

1. 파일 열기:
```
C:\spring-tool\neo_voice_assistant\lib\config\api_config.dart
```

2. 다음 줄 찾기:
```dart
static const String openAiApiKey = 'YOUR_API_KEY_HERE';
```

3. `YOUR_API_KEY_HERE` 부분을 실제 API 키로 교체:
```dart
static const String openAiApiKey = 'sk-proj-여기에전체API키입력';
```

4. 파일 저장

## 3. APK 다시 빌드하기

```bash
cd C:\spring-tool\neo_voice_assistant
flutter build apk --release
```

새로운 APK가 생성됩니다:
```
C:\spring-tool\neo_voice_assistant\build\app\outputs\flutter-apk\app-release.apk
```

## API 키 확인 사항

✅ API 키가 완전한지 확인 (보통 100자 이상)
✅ `sk-proj-` 또는 `sk-`로 시작하는지 확인
✅ 공백이나 줄바꿈이 없는지 확인
✅ 따옴표 안에 올바르게 들어있는지 확인

## 문제 해결

### "API 키가 유효하지 않습니다"
- API 키를 다시 확인하세요
- OpenAI 계정에 크레딧이 있는지 확인하세요
- API 키가 활성화되어 있는지 확인하세요

### "API 사용 한도를 초과했습니다"
- 무료 크레딧을 모두 사용했거나 월 한도를 초과했습니다
- [OpenAI Usage](https://platform.openai.com/usage) 페이지에서 확인하세요

### "네트워크 오류"
- 인터넷 연결을 확인하세요
- 방화벽이 OpenAI API를 차단하지 않는지 확인하세요

## 보안 주의사항

⚠️ **중요**: API 키를 공유하거나 공개 저장소에 업로드하지 마세요!
- API 키가 노출되면 타인이 사용할 수 있습니다
- 비용이 발생할 수 있습니다
- 노출된 경우 즉시 키를 재발급하세요
