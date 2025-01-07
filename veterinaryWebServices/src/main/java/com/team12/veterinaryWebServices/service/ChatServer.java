package com.team12.veterinaryWebServices.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
public class ChatServer {
    private ServerSocket serverSocket;
    private ExecutorService executor = Executors.newCachedThreadPool();
    private ConcurrentHashMap<Integer, PrintWriter> userSockets = new ConcurrentHashMap<>();

    // Method to start the server
    public void startServer(int port) {
        try {
            serverSocket = new ServerSocket(port);
            System.out.println("Chat server started on port: " + port);

            while (true) {
                Socket clientSocket = serverSocket.accept();
                executor.execute(new ClientHandler(clientSocket));  // Handle each new client connection
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Inner class to handle individual client connections
    private class ClientHandler implements Runnable {
        private Socket socket;
        private PrintWriter out;
        private BufferedReader in;
        private int userId = -1;

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try {
                in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                out = new PrintWriter(socket.getOutputStream(), true);

                // Ask for user ID
                out.println("Enter your User ID:");
                String input = in.readLine();
                try {
                    userId = Integer.parseInt(input); // Parse user ID as integer
                    userSockets.put(userId, out);  // Store user socket in map
                    out.println("Welcome, User ID " + userId);
                } catch (NumberFormatException e) {
                    out.println("Invalid User ID format!");
                    return;
                }

                // Listen for messages from the user
                String message;
                while ((message = in.readLine()) != null) {
                    System.out.println("Received from User ID " + userId + ": " + message);
                    sendMessageToEmployee("User ID " + userId + ": " + message);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    socket.close();
                    if (userId != -1) {
                        userSockets.remove(userId);  // Remove user from active users map
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        private void sendMessageToEmployee(String message) {
            // Broadcast message to all employees (in this case, all users)
            for (PrintWriter writer : userSockets.values()) {
                writer.println(message);
            }
        }
    }
}