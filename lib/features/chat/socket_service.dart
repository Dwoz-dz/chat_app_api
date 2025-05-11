import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket _socket;

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket get socket => _socket;

  void connect() {
    _socket = IO.io(
      'https://YOUR_NGROK_URL_HERE/api', // غيّر هذا بـ ngrok أو رابط السيرفر
      IO.OptionBuilder()
          .setTransports(['websocket']) // ضروري
          .enableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      print('✅ Socket متصل!');
    });

    _socket.onDisconnect((_) {
      print('❌ Socket انقطع!');
    });

    _socket.onError((data) {
      print('⚠️ Socket Error: $data');
    });
  }

  void sendMessage(String message) {
    _socket.emit('chat_message', message);
  }

  void onMessage(Function(String) callback) {
    _socket.on('chat_message', (data) {
      callback(data.toString());
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
