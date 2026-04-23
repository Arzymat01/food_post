import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../db/app_database.dart';
import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String username, String password) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND is_active = 1',
      whereArgs: [username],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final user = UserModel.fromMap(result.first);
    final incoming = sha256.convert(utf8.encode(password)).toString();
    if (incoming == user.passwordHash) return user;
    return null;
  }

  Future<void> changePassword(int userId, String newPassword) async {
    final db = await AppDatabase.instance.database;
    final hash = sha256.convert(utf8.encode(newPassword)).toString();
    await db.update(
      'users',
      {'password_hash': hash},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
