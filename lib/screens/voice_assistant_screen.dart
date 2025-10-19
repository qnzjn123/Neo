import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../providers/voice_assistant_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/voice_button.dart';

class VoiceAssistantScreen extends StatelessWidget {
  const VoiceAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1F3A),
              const Color(0xFF2A2F4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildChatArea(context)),
              _buildVoiceInterface(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '니오',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Color(0xFF6C63FF),
                          Color(0xFF9C63FF),
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                Text(
                  'AI 음성 비서',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            Consumer<VoiceAssistantProvider>(
              builder: (context, provider, _) {
                return IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  onPressed: provider.messages.isEmpty
                      ? null
                      : () {
                          provider.clearMessages();
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea(BuildContext context) {
    return Consumer<VoiceAssistantProvider>(
      builder: (context, provider, _) {
        if (provider.messages.isEmpty) {
          return _buildWelcomeMessage();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            final message = provider.messages[index];
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: ChatBubble(message: message),
            );
          },
        );
      },
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 1000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6C63FF).withOpacity(0.3),
                    Color(0xFF9C63FF).withOpacity(0.1),
                  ],
                ),
              ),
              child: Icon(
                Icons.mic_none,
                size: 80,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '안녕하세요!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '무엇을 도와드릴까요?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '마이크 버튼을 눌러 말씀해주세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInterface(BuildContext context) {
    return Consumer<VoiceAssistantProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            if (provider.isListening || provider.currentTranscript.isNotEmpty)
              FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF6C63FF).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        provider.isListening ? '듣고 있어요...' : '처리 중...',
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (provider.currentTranscript.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          provider.currentTranscript,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 30),
            if (provider.isListening)
              AvatarGlow(
                glowColor: Color(0xFF6C63FF),
                glowShape: BoxShape.circle,
                curve: Curves.fastOutSlowIn,
                child: VoiceButton(
                  isListening: true,
                  isProcessing: false,
                  onPressed: () => provider.toggleListening(),
                ),
              )
            else
              VoiceButton(
                isListening: false,
                isProcessing: provider.isProcessing || provider.isSpeaking,
                onPressed: () => provider.toggleListening(),
              ),
          ],
        );
      },
    );
  }
}
