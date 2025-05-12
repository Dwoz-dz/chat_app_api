import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class MessageInput extends StatefulWidget {
  final IO.Socket socket;
  final Function(String) onSend;

  const MessageInput({super.key, required this.socket, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _isTyping = false;
  String username = 'مستخدم';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'مستخدم';
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.socket.emit('chat_message', text);
    widget.socket.emit('stop_typing', username);
    widget.onSend(text);
    _controller.clear();
    _isTyping = false;
  }

  void _handleTyping(String text) {
    if (text.isNotEmpty && !_isTyping) {
      widget.socket.emit('typing', username);
      _isTyping = true;
    } else if (text.isEmpty && _isTyping) {
      widget.socket.emit('stop_typing', username);
      _isTyping = false;
    }
  }

  @override
  void dispose() {
    widget.socket.emit('stop_typing', username);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: _handleTyping,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
