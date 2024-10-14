import 'package:application/bodyToCallAPI/Service.dart';

import 'package:intl/intl.dart';

class AddComment {
  final int userID;
  final String serviceCODE;
  final int rating; // Use String if the time is sent in a specific format
  final String content;

  AddComment({
    required this.userID,
    required this.serviceCODE,
    required this.rating,
    required this.content,
  });
  factory AddComment.fromJson(Map<String, dynamic> json) {
    return AddComment(
        userID: json['userID'],
        serviceCODE: json['serviceCODE'],
        rating: json['rating'],
        content: json['content']);
  }

  // Convert AppointmentDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'serviceCODE': serviceCODE,
      'rating': rating,
      'content': content
    };
  }
}
