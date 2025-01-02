import 'dart:convert';
import 'package:application/Screens/Chat/InactivityTimerService%20.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  StompClient? _client;
  bool isConnected = false;

  Function? onConnectCallback;

  Future<void> initialize(String session, {Function? onConnectCallback}) async {
    if (_client != null) return;

    _client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.137.1:8080/veterinaryCustomerService',
        webSocketConnectHeaders:
            session.isNotEmpty ? {'Cookie': session} : null,
        onConnect: (frame) => _onConnect(frame, onConnectCallback),
        onWebSocketError: (error) => print('WebSocket error: $error'),
        onStompError: (frame) => print('STOMP error: ${frame.body}'),
        onDisconnect: (frame) {
          print('Disconnected from WebSocket');
          isConnected = false;
        },
        heartbeatOutgoing: Duration(seconds: 10),
        heartbeatIncoming: Duration(seconds: 10),
      ),
    );

    _client?.activate();
  }

  void _onConnect(StompFrame frame, Function? onConnectCallback) {
    isConnected = true;
    print("WebSocket Connected: ${frame.body}");

    if (onConnectCallback != null) {
      onConnectCallback(frame);
    }

    _subscribeToMessages();
  }

  Function(Map<String, String>)? onMessageReceived;

  void subscribeToMessages(Map<String, String> message) {
    if (onMessageReceived != null) {
      onMessageReceived!(message);
    }
  }

  void _subscribeToMessages() {
    _client?.subscribe(
      destination: '/queue/messages',
      callback: (userFrame) {
        final messageData = jsonDecode(userFrame.body ?? '{}');
      },
    );
    _client?.subscribe(
      destination: '/user/queue/messages',
      callback: (userFrame) {
        final messageData = jsonDecode(userFrame.body ?? '{}');
        print('ducshjshjshsjjhjsffjhff: $messageData');
        final senderName = messageData['senderName'] ?? 'Anonymous';
        _saveReceivedMessage('employee', senderName, messageData['message']);
        InactivityTimerService().resetTimer();
        print('data sendibng: $messageData');
        if (onMessageReceived != null) {
          onMessageReceived!({
            'sender': 'employee',
            'senderName': senderName,
            'message': messageData['message']
          });
        }
      },
    );
  }

  Future<void> _saveReceivedMessage(
      String sender, String senderName, String message) async {
    if (message.isEmpty) {
      print('Received message is empty, not saving.');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> existingMessages = prefs.getStringList('chatMessages') ?? [];

      final combinedMessage = jsonEncode(
          {'sender': sender, 'senderName': senderName, 'message': message});
      existingMessages.add(combinedMessage);

      await prefs.setStringList('chatMessages', existingMessages);
      print('messages receive $existingMessages');
      print('Message saved successfully!');
    } catch (e, stackTrace) {
      print('Error saving received message: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void sendMessage(String sender, String message) {
    if (isConnected) {
      _client?.send(
          destination: '/app/message',
          body: jsonEncode({'senderName': sender, 'message': message}));
    } else {
      print('Not connected to WebSocket');
    }
  }

  void disconnect() {
    _client?.deactivate();
  }

  Future<void> reconnect(String session, bool connect) async {
    if (connect == false) {
      disconnect();
      await initialize(session);
    }
  }
}
