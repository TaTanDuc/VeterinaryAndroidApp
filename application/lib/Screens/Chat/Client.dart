import 'dart:convert';
import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChatScreen extends StatefulWidget {
  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // Updated to store sender info
  String? session;
  ScrollController _scrollController =
      ScrollController(); // Added ScrollController

  @override
  void initState() {
    super.initState();
    _initializeChat();
    WebSocketManager().onMessageReceived = (Map<String, String> newMessage) {
      setState(() {
        messages.add(newMessage);
      });
      // _saveMessage(newMessage['sender'] ?? '', newMessage['message'] ?? '');
    };
  }

  Future<void> _initializeChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    session = await SessionManager().getSession();

    if (session == null) {
      print('Session expired or not found.');
      return;
    }

    WebSocketManager().onConnectCallback = (frame) {
      setState(() {});
    };

    WebSocketManager().initialize(session!);

    List<String> savedMessages;
    dynamic storedData = prefs.get('chatMessages');
    if (storedData is List) {
      savedMessages = List<String>.from(storedData);
    } else {
      savedMessages = [];
    }
    setState(() {
      messages = savedMessages
          .map((msg) {
            try {
              final parsedMessage = jsonDecode(msg) as Map<String, dynamic>;
              return {
                'message': (parsedMessage['message'] ?? '') as String,
                'sender': (parsedMessage['sender'] ?? 'unknown') as String,
              };
            } catch (e) {
              print("Error decoding message: $msg, error: $e");
              return {
                'message': msg,
                'sender': 'unknown',
              };
            }
          })
          .whereType<Map<String, String>>()
          .toList();
    });
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      final userName = UserManager().username;
      WebSocketManager().sendMessage(userName!, message);
      setState(() {
        messages.add({'message': message, 'sender': 'user'});
      });
      _controller.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      _saveMessage('user', message);
    }
  }

  Future<void> _saveMessage(String sender, String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String>? existingMessages;
      dynamic storedData = prefs.get('chatMessages');
      if (storedData is List) {
        existingMessages = List<String>.from(storedData);
      } else {
        existingMessages = [];
      }
      final combinedMessage = jsonEncode({
        'sender': sender,
        'message': message,
      });
      existingMessages.add(combinedMessage);
      await prefs.setStringList('chatMessages', existingMessages);
      print('Message saved successfully!');
    } catch (e, stackTrace) {
      print('Error saving sent message: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    WebSocketManager().reconnect(session!);
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
                var message = messages[index];
                bool isUserMessage = message['sender'] == 'user';

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: isUserMessage
                          ? Colors.greenAccent
                          : Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(message['message'] ?? ''),
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
                  onPressed: () {
                    String message = _controller.text;
                    _sendMessage(message);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
