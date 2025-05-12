import 'package:flutter/material.dart';
import 'package:chat_app_clean/features/chat/message_input.dart';
import 'package:chat_app_clean/features/chat/message_bubble.dart';
import 'package:chat_app_clean/features/chat/socket_service.dart';
import 'package:chat_app_clean/core/config/app_config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    socketService.connect(AppConfig.baseUrl); // ربط WebSocket
    socketService.onMessage((message) {
      setState(() {
        _messages.add({'text': message, 'isMe': false});
      });
    });
  }

  void _handleSend(String message) {
    socketService.sendMessage(message);
    setState(() {
      _messages.add({'text': message, 'isMe': true});
    });
  }

  @override
  void dispose() {
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('الدردشة الحية'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/brp_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return MessageBubble(
                    message: message['text'],
                    isMe: message['isMe'],
                  );
                },
              ),
            ),
            MessageInput(socket: socketService.socket!, onSend: _handleSend),
          ],
        ),
      ),
    );
  }
}
