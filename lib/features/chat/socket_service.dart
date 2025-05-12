import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  void connect(String url) {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket']) // WebSocket protocol
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();
    socket!.onConnect((_) => print('🟢 Connected to WebSocket'));
    socket!.onDisconnect((_) => print('🔴 Disconnected from WebSocket'));
  }

  void sendMessage(String message) {
    socket?.emit('chat_message', message);
  }

  void onMessage(Function(String) callback) {
    socket?.on('chat_message', (data) {
      callback(data);
    });
  }

  void disconnect() {
    socket?.disconnect();
  }
}
