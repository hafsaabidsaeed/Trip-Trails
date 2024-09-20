// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/user model.dart';

class UserService {
  final String apiUrl = 'http://192.168.18.60:5009/api/auth';  // Update with your server URL

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/get-users'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser(String id, String name, String email, String password) async {
    final response = await http.put(
      Uri.parse('$apiUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
