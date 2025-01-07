import 'package:application/bodyToCallAPI/Service.dart';

import 'package:intl/intl.dart';

class AddComment {
  final String serviceCODE;
  final int
      serviceRating; // Use String if the time is sent in a specific format
  final String content;

  AddComment({
    required this.serviceCODE,
    required this.serviceRating,
    required this.content,
  });
  factory AddComment.fromJson(Map<String, dynamic> json) {
    return AddComment(
        serviceCODE: json['serviceCODE'],
        serviceRating: json['serviceRating'],
        content: json['content']);
  }

  // Convert AppointmentDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceCODE': serviceCODE,
      'serviceRating': serviceRating,
      'content': content
    };
  }
}
