import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator, localhost for iOS/Web/Desktop
  static String get baseUrl {
    // UPDATED: Use computer's LAN IP so real phones on same WiFi can connect
    const String ipAddress = '192.168.10.4'; 
    return 'http://$ipAddress:8000';
  }

  static Future<Map<String, dynamic>> signup(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=signup'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  static Future<List<dynamic>> getTasks(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks.php?user_id=$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['tasks'];
        }
      }
      return [];
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> addTask(int userId, String title) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks.php?user_id=$userId'),
        body: jsonEncode({'title': title}),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  static Future<Map<String, dynamic>> updateTask(int userId, int taskId, bool isCompleted) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/tasks.php?user_id=$userId'),
        body: jsonEncode({'id': taskId, 'is_completed': isCompleted ? 1 : 0}),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }
}
