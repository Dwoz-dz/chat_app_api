import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat_app_clean/core/config/app_config.dart';

class SocketService {
  IO.Socket? socket;

  void connect() {
    socket = IO.io(
      AppConfig.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) => print('🟢 WebSocket متصل'));
    socket!.onDisconnect((_) => print('🔴 WebSocket مفصول'));
    socket!.onConnectError((data) => print('⚠️ خطأ في الاتصال: $data'));
    socket!.onError((data) => print('❌ خطأ عام: $data'));
  }

  void sendMessage(String message) {
    if (socket != null && socket!.connected) {
      socket!.emit('chat_message', message);
    }
  }

  void onMessage(Function(String) callback) {
    socket?.on('chat_message', (data) {
      callback(data.toString());
    });
  }

  void onTyping(Function(String) callback) {
    socket?.on('typing', (data) {
      callback(data.toString());
    });
  }

  void onStopTyping(Function(String) callback) {
    socket?.on('stop_typing', (data) {
      callback(data.toString());
    });
  }

  void emitTyping(String username) {
    if (socket != null && socket!.connected) {
      socket!.emit('typing', username);
    }
  }

  void emitStopTyping(String username) {
    if (socket != null && socket!.connected) {
      socket!.emit('stop_typing', username);
    }
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
