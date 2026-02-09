import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await ApiService.login(username, password);

    _isLoading = false;
    if (result['success'] == true) {
      _user = result['user'];
      notifyListeners();
      return true;
    } else {
      _error = result['message'];
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await ApiService.signup(username, password);

    _isLoading = false;
    if (result['success'] == true) {
      // Auto login after signup? Or just return true to redirect to login
      notifyListeners();
      return true;
    } else {
      _error = result['message'];
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
