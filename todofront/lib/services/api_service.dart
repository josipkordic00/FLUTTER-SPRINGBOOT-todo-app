import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8080/api';

  // Secure storage to store the JWT token
  final _storage = const FlutterSecureStorage();

  // Method to log in and store the token
  Future<bool> login(String username, String password) async {
    var url = Uri.parse('$baseUrl/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['token'];

        // Store the token securely
        await _storage.write(key: 'token', value: token);

        return true; // Login successful
      } else {
        // Handle invalid credentials
        return false;
      }
    } catch (e) {
      // Handle connection errors
      return false;
    }
  }

  // Method to log out and delete the stored token
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  // Helper method to retrieve the token
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Fetch todos
  Future<String> fetchTodos() async {
    var url = Uri.parse('$baseUrl/todos');
    String? token = await getToken();

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // Get current user role
  Future<String> currentUserRole() async {
    var url = Uri.parse('$baseUrl/user/roles');
    String? token = await getToken();

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load user role');
    }
  }

  // Get current user
  Future<String> currentUser() async {
    var url = Uri.parse('$baseUrl/user');
    String? token = await getToken();

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Save a new todo
  Future<String> saveTodo(String title, String task) async {
    var url = Uri.parse('$baseUrl/todos');
    String? token = await getToken();

    var body = jsonEncode({
      'heading': title,
      'description': task,
    });

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to save todo');
    }
  }

  // Delete a todo by ID
  Future<String> deleteTodo(int id) async {
    var url = Uri.parse('$baseUrl/todos/$id');
    String? token = await getToken();

    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  // Update an existing todo
  Future<String> updateTodo(int id, String title, String task) async {
    var url = Uri.parse('$baseUrl/todos');
    String? token = await getToken();

    var body = jsonEncode({
      'id': id,
      'heading': title,
      'description': task,
    });

    var response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update todo');
    }
  }
}
