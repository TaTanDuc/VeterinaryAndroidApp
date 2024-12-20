import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  // Send message to WebSocket server
  void sendMessage(String message) {
    channel.sink.add(message);
  }

  // Listen for incoming messages
  Stream<String> get messages =>
      channel.stream.map((message) => message.toString());

  // Close the WebSocket connection
  void close() {
    channel.sink.close();
  }
}
