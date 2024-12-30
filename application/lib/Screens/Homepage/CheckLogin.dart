import 'package:application/Screens/Login/login_screen.dart';
import 'package:application/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Check extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return MainPage();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            } else {
              return LoginScreen();
            }
          }));
}
