import 'dart:io';
import 'dart:convert';
import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:application/bodyToCallAPI/UserManager.dart';
import 'package:application/bodyToCallAPI/User.dart';

class UserChatScreen extends StatefulWidget {
  final WebSocketService webSocketService;

  UserChatScreen({required this.webSocketService});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    widget.webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Chat")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<String>(
              stream: widget.webSocketService.messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: [Text(snapshot.data ?? '')],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
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
                    widget.webSocketService.sendMessage(_controller.text);
                    _controller.clear();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
