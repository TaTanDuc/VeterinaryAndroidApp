import 'package:application/bodyToCallAPI/SessionManager.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

String? session;

// Function to load session before using it
Future<void> loadSession() async {
  session = await SessionManager().getSession();
  print('Session loaded: $session');
}

void main() async {
  await loadSession();
  StompClient client = StompClient(
    config: StompConfig(
      url: 'ws://192.168.137.1:8080/veterinaryCustomerService',
      onConnect: onConnectCallback,
      webSocketConnectHeaders: {'Cookie': session ?? ''},
      onWebSocketError: (e) => print(e.toString()),
      onStompError: (d) => print('error stomp'),
      onDisconnect: (f) => print('disconnected'),
    ),
  );

  // Activate the client
  client.activate();
}

// Callback for successful connection
void onConnectCallback(StompFrame connectFrame) {
  print("Connected to WebSocket with session: $connectFrame");
}
