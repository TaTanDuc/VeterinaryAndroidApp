
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile's name")),

        body: const Center(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Card(child: _ProfileItem1()),
                Card(child: _ProfileItem())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem();
  @override
  Widget build(BuildContext context){
    return const SizedBox(
        width: double.infinity,
        height: 200,
      );
  }
}

class _ProfileItem1 extends StatelessWidget {
  const _ProfileItem1();
  @override
  Widget build(BuildContext context){
    return const SizedBox(
        width: double.infinity,
        height: 200,
        child: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Profile's Name"),
                  Text('Sign out')
                ],
              ),
          ],
        ),
      );
  }
}