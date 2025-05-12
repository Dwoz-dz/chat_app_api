import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          gradient:
              isMe
                  ? const LinearGradient(
                    colors: [Color(0xFF7B1FA2), Color(0xFF512DA8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : const LinearGradient(
                    colors: [Color(0x22FFFFFF), Color(0x11FFFFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMe ? 14 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SelectableText(
          message,
          style: TextStyle(
            fontSize: 15,
            color: isMe ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
