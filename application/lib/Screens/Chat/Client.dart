import 'dart:convert';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class UserChatScreen extends StatefulWidget {
  final WebSocketService webSocketService;

  UserChatScreen({required this.webSocketService});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController _controller = TextEditingController();
  String? session;
  List<Map<String, String>> messages = [];
  late StompClient client;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    session = await SessionManager().getSession();

    client = StompClient(
      config: StompConfig(
        url: 'ws://192.168.137.1:8080/veterinaryCustomerService',
        webSocketConnectHeaders: session != null ? {'Cookie': session} : null,
        onConnect: onConnectCallback,
        onWebSocketError: (error) => print('WebSocket error: $error'),
        onStompError: (frame) => print('STOMP error: ${frame.body}'),
        onDisconnect: (frame) => print('Disconnected from WebSocket'),
        heartbeatOutgoing: Duration(seconds: 10),
        heartbeatIncoming: Duration(seconds: 10),
      ),
    );
    print('Initializing WebSocket connection...');
    try {
      client.activate();
      print("Client activated, awaiting connection...");
    } catch (e) {
      print('Error activating client: $e');
    }
  }

  void onConnectCallback(StompFrame frame) {
    print("WebSocket Connected: ${frame.body}");

    client.subscribe(
        destination: '/queue/messages',
        callback: (userFrame) {
          print('joint message received: ${userFrame.body}');
          setState(() {
            messages.add({
              'sender': 'user',
              'message': jsonDecode(userFrame.body ?? '{}')['message'],
            });
          });
        });
    client.subscribe(
        destination: '/user/queue/messages',
        callback: (userFrame) {
          print('Private message received: ${userFrame.body}');
          setState(() {
            messages.add({
              'sender': 'employee',
              'message': jsonDecode(userFrame.body ?? '{}')['message'],
            });
          });
        });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final username = UserManager().username;
      final messageJson = jsonEncode({
        "receiver": "",
        "senderName": "$username",
        "message": _controller.text,
      });

      client.send(destination: '/app/message', body: messageJson);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var messageData = messages[index];
                bool isUserMessage = messageData['sender'] == 'user';

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color:
                          isUserMessage ? Colors.blueAccent : Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          messageData['message'] ?? '',
                          style: TextStyle(
                              color:
                                  isUserMessage ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Enter message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
