import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String _serverIp = '192.168.0.149';
  static const String _ipKey = 'server_ip';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _serverIp = prefs.getString(_ipKey) ?? '192.168.0.149';
  }

  static Future<void> setIp(String ip) async {
    _serverIp = ip;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip);
  }

  static String get serverIp => _serverIp;

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://$_serverIp:8000';
    return 'http://localhost:8000';
  }

  static Future<Map<String, dynamic>> signup(
      String username, String password, {String email = '', String address = ''}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=signup'),
        body: jsonEncode({
          'username': username, 
          'password': password,
          'email': email,
          'address': address,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: Please check if backend is running at $baseUrl'};
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: Please check if backend is running at $baseUrl'};
    }
  }

  static Future<List<dynamic>> getTasks(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks.php?user_id=$userId'))
          .timeout(const Duration(seconds: 10));
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
      ).timeout(const Duration(seconds: 10));
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
      ).timeout(const Duration(seconds: 10));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }

  static Future<Map<String, dynamic>> deleteTask(int userId, int taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks.php?user_id=$userId&id=$taskId'),
      ).timeout(const Duration(seconds: 10));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error'};
    }
  }
}
