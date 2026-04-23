import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;
  UserModel? currentUser;
  bool loading = false;
  String? error;

  AuthController(this._authService);

  Future<UserModel?> login(String username, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    final user = await _authService.login(username, password);
    currentUser = user;
    if (user == null) {
      error = 'Логин же пароль туура эмес';
    }

    loading = false;
    notifyListeners();
    return user;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }
}
