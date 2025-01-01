import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  // Map to store messages by user (username -> list of messages)
  Map<String, List<String>> userMessages = {};
  String? selectedUser;
  List<String> selectedUserMessages = [];

  @override
  void initState() {
    super.initState();
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    String? session = await SessionManager().getSession();

    if (session == null) {
      print('Session expired or not found.');
      return;
    }

    WebSocketManager().onMessageReceived = (Map<String, String> newMessage) {
      setState(() {
        String sender = newMessage['sender']!;
        String message = newMessage['message']!;

        if (userMessages.containsKey(sender)) {
          userMessages[sender]!.add(message);
        } else {
          userMessages[sender] = [message];
        }

        if (selectedUser == sender) {
          selectedUserMessages = userMessages[sender]!;
        }
      });
    };

    WebSocketManager().initialize(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee - Respond to Users'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: userMessages.keys.length,
              itemBuilder: (context, index) {
                String user = userMessages.keys.elementAt(index);
                String latestMessage = userMessages[user]!.last;

                return ListTile(
                  title: Text('User: $user'),
                  subtitle: Text('Latest Message: $latestMessage'),
                  onTap: () {
                    setState(() {
                      selectedUser = user;
                      selectedUserMessages = userMessages[user]!;
                    });
                  },
                );
              },
            ),
          ),
          if (selectedUser != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Messages from $selectedUser:'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedUserMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedUserMessages[index]),
                  );
                },
              ),
            ),
            _buildResponseInput(),
          ]
        ],
      ),
    );
  }

  Widget _buildResponseInput() {
    TextEditingController responseController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: responseController,
              decoration: InputDecoration(
                hintText: 'Type your response...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (responseController.text.isNotEmpty) {
                _sendResponse(responseController.text);
                responseController.clear();
              }
            },
          )
        ],
      ),
    );
  }

  void _sendResponse(String responseMessage) {
    if (selectedUser != null && responseMessage.isNotEmpty) {
      WebSocketManager().sendMessage('employee', responseMessage);
      setState(() {
        userMessages[selectedUser]!.add(responseMessage);
        selectedUserMessages = userMessages[selectedUser]!;
      });
    } else {
      print("No user selected or response is empty.");
    }
  }
}
