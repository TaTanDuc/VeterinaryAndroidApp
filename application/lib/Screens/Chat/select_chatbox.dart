import 'dart:convert';

import 'package:application/Screens/Chat/Client.dart';
import 'package:application/Screens/Chat/EmployeeChat.dart';
import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chatbox_screen.dart'; // Đảm bảo import đúng nơi chứa ChatScreen

class ChatPage extends StatefulWidget {
 const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
   List<User> users = [];

   @override
  void initState() {
    super.initState();
    check();
  }
  Future <void> check() async{
    final sm = await SessionManager().getSession();
    final response = await http.get(Uri.parse('http://192.168.137.1:8080/getCurrent'), headers: {'cookie':'$sm'});
    try{
        if(response.statusCode == 200){
          final List<dynamic> temp = jsonDecode(response.body)['returned'];
          // final List<dynamic> userList = temp['returned'];

          setState(() {
            users = temp.map((json) => User.fromJson(json)).toList();
          });
          
        }
        else{
        }
    }catch(ex)
    {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(users);
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
                  title: Text(user.name),
                  onTap: () {
                    // Khi người dùng chọn một item, điều hướng đến ChatScreen và truyền userId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeChatScreen(userID: user.id,),
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
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userID'],
      name: json['userName']
    );
  }
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
