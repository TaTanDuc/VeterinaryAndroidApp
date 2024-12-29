import 'package:flutter/material.dart';
import 'chatbox_screen.dart'; // Đảm bảo import đúng nơi chứa ChatScreen

class ChatPage extends StatelessWidget {
  // Danh sách người dùng với id và hình ảnh
  final List<User> users = [
    User(
        id: '1',
        name: 'John Doe',
        imageUrl: 'https://www.example.com/images/john.jpg'),
    User(
        id: '2',
        name: 'Jane Smith',
        imageUrl: 'https://www.example.com/images/jane.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.grey.shade300,
        actions: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                '5', // Con số này có thể là số lượng tin nhắn chưa đọc
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(user.imageUrl),
                  ),
                  title: Text(user.name),
                  onTap: () {
                    // Khi người dùng chọn một item, điều hướng đến ChatScreen và truyền userId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(userId: user.id),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                DashLine(), // Đường gạch ngang dưới mỗi item
              ],
            ),
          );
        },
      ),
    );
  }
}

class User {
  final String id;
  final String name;
  final String imageUrl;

  User({required this.id, required this.name, required this.imageUrl});
}

class DashLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 0.5,
        ),
      ),
    );
  }
}
