import 'dart:async';
import 'dart:convert';
import 'package:application/Screens/Chat/InactivityTimerService%20.dart';
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
  List<Map<String, String>> messages = [];
  String? session;
  ScrollController _scrollController = ScrollController();
  DateTime? lastMessageTime;
  bool isConnected = true;
  int? userId;
  @override
  void initState() {
    super.initState();
    _initializeChat();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    });
    WebSocketManager().onMessageReceived = (Map<String, String> newMessage) {
      setState(() {
        messages.add(newMessage);
      });
      InactivityTimerService().resetTimer();
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      });
    };
    InactivityTimerService().onInactivityTimeout = _deleteChat;

    InactivityTimerService().startTimer();
  }

  void _deleteChat() async {
    if (!mounted) return; // Ensure the widget is still mounted

    setState(() {
      messages.clear();
      isConnected = false;
      WebSocketManager().reconnect(userId!,session!, isConnected);
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('chatMessages');
      print(
          'Chat messages deleted from storage and client deactivated due to inactivity.');
    } catch (e) {
      print('Error clearing chat messages from storage: $e');
    }
    print('Chat messages deleted and client deactivated due to inactivity.');
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

    userId = await UserManager().id;
    WebSocketManager().initialize(session!,userId!);

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
                'senderName': (parsedMessage['senderName'] ?? '') as String,
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
      final id = UserManager().id;
      print("CAI CCNDJAJSDKOSNCDKJLFJAIO $id");
      WebSocketManager().sendMessage(userId!, userName!, message);
      // setState(() {
      //   messages.add({'message': message, 'senderName': userName, 'sender': 'user'});
      // });
      _controller.clear();

      InactivityTimerService().resetTimer();
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
      });
      //_saveMessage('user', userName, message);
    }
  }

  Future<void> _saveMessage(
      String sender, String userName, String message) async {
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
        'senderName': userName,
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
    WebSocketManager().reconnect(userId!,session!, isConnected);

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
              controller: _scrollController,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isUserMessage = message['senderName'] == UserManager().username;
                print("merejirejreij: $message");
                return Column(
                  crossAxisAlignment: isUserMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        message['senderName'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Align(
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
                    ),
                  ],
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
