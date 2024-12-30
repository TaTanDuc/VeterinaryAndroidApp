import 'package:application/Screens/Chat/WebSocketService.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EmployeeChatScreen extends StatefulWidget {
  final WebSocketService webSocketService;

  EmployeeChatScreen({required this.webSocketService});

  @override
  _EmployeeChatScreenState createState() => _EmployeeChatScreenState();
}

class _EmployeeChatScreenState extends State<EmployeeChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> userList = []; // List of active users
  String? selectedUser; // Currently selected user
  List<String> messages = []; // Chat history with the selected user

  @override
  void initState() {
    super.initState();
    _initializePublicSubscription();
  }

  void _initializePublicSubscription() {
    // Subscribe to the general queue to monitor incoming messages
    widget.webSocketService.subscribe('/queue/messages', (frame) {
      final messageData = jsonDecode(frame.body ?? '{}');
      final userId = messageData['senderName'];

      setState(() {
        if (!userList.contains(userId)) {
          userList.add(userId); // Add user to active list
        }
      });
    });
  }

  void _joinPrivateRoom(String userId) {
    setState(() {
      selectedUser = userId;
      messages.clear(); // Clear previous chat messages
    });

    widget.webSocketService.subscribe('/user/$userId/queue/messages', (frame) {
      final messageData = jsonDecode(frame.body ?? '{}');
      setState(() {
        messages.add(messageData['message']); // Append received message
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && selectedUser != null) {
      final messageJson = jsonEncode({
        "recipientId": selectedUser,
        "content": _controller.text,
      });

      widget.webSocketService.sendMessage('/app/messages', messageJson);
      setState(() {
        messages.add("You: ${_controller.text}"); // Show the sent message
      });
      _controller.clear();
    }
  }

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
          // Display active users
          if (userList.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final userId = userList[index];
                  return GestureDetector(
                    onTap: () => _joinPrivateRoom(userId),
                    child: Card(
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "User: $userId",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Display messages for the selected user
          Expanded(
            child: selectedUser != null
                ? ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index]),
                      );
                    },
                  )
                : Center(child: Text("Select a user to start chatting")),
          ),

          // Message input and send button
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
