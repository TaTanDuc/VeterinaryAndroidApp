import 'dart:convert';
import 'package:application/bodyToCallAPI/Pet.dart';
import 'package:http/http.dart' as http; // Make sure to import your User model

Future<Pet> fetchUserData() async {
  final url = Uri.parse(
      'http://localhost:8080/api/pet/getUserPets'); // Replace with actual API endpoint
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return Pet.fromJson(
        jsonResponse); // Parse the JSON response into a User object
  } else {
    throw Exception('Failed to load user data');
  }
}
