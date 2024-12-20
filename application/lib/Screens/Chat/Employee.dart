import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class EmployeeChatScreen extends StatefulWidget {
  final WebSocketService webSocketService;

  EmployeeChatScreen({required this.webSocketService});

  @override
  _EmployeeChatScreenState createState() => _EmployeeChatScreenState();
}

class _EmployeeChatScreenState extends State<EmployeeChatScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    widget.webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee Chat")),
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
