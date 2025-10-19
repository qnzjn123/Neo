import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? LinearGradient(
                        colors: [
                          Color(0xFF6C63FF),
                          Color(0xFF9C63FF),
                        ],
                      )
                    : null,
                color: message.isUser ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(message.isUser ? 20 : 5),
                  topRight: Radius.circular(message.isUser ? 5 : 20),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                border: !message.isUser
                    ? Border.all(
                        color: Colors.white.withOpacity(0.1),
                      )
                    : null,
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (message.isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: message.isUser
            ? LinearGradient(
                colors: [
                  Color(0xFF6C63FF).withOpacity(0.3),
                  Color(0xFF9C63FF).withOpacity(0.3),
                ],
              )
            : LinearGradient(
                colors: [
                  Color(0xFF00D4FF).withOpacity(0.3),
                  Color(0xFF00FFFF).withOpacity(0.3),
                ],
              ),
      ),
      child: Icon(
        message.isUser ? Icons.person : Icons.smart_toy,
        color: message.isUser ? Color(0xFF6C63FF) : Color(0xFF00D4FF),
        size: 24,
      ),
    );
  }
}
