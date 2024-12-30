import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  late StompClient client;
  final String url;
  String? session;

  WebSocketService(this.url);

  // Initialize the STOMP client
  void initialize(String? session, Function(StompFrame) onConnectCallback) {
    this.session = session;

    client = StompClient(
      config: StompConfig(
        url: url,
        webSocketConnectHeaders: session != null ? {'Cookie': session} : null,
        onConnect: onConnectCallback,
        onWebSocketError: (error) => print('WebSocket error: $error'),
        onStompError: (frame) => print('STOMP error: $frame'),
        onDisconnect: (frame) => print('Disconnected from WebSocket'),
        heartbeatOutgoing: Duration(seconds: 10),
        heartbeatIncoming: Duration(seconds: 10),
      ),
    );
  }

  void sendMessage(String destination, String message) {
    if (client.connected) {
      client.send(
        destination: destination,
        body: message,
      );
    } else {
      print('Cannot send message, client is not connected.');
    }
  }

  void subscribe(String destination, Function(StompFrame) callback) {
    if (client.connected) {
      client.subscribe(
        destination: destination,
        callback: callback,
      );
    } else {
      print('Cannot subscribe, client is not connected.');
    }
  }

  void close() {
    if (client.connected) {
      client.deactivate();
    }
  }
}
