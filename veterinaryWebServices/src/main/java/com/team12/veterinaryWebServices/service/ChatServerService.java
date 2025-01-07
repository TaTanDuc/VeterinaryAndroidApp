package com.team12.veterinaryWebServices.service;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

@Service
public class ChatServerService {

    @PostConstruct
    public void startChatServer() {
        int chatServerPort = 8081; // Specify the port for your chat server
        ChatServer chatServer = new ChatServer();

        // Start the chat server in a new thread
        new Thread(() -> chatServer.startServer(chatServerPort)).start();

        System.out.println("Chat Server started on port " + chatServerPort);
    }
}