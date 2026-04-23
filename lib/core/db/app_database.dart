import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../utils/app_constants.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orderflow_pos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, filePath);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(version: 1, onCreate: _createDB),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    final batch = db.batch();

    batch.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        image_path TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number INTEGER NOT NULL,
        cashier_id INTEGER NOT NULL,
        total_amount INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        qty INTEGER NOT NULL,
        price INTEGER NOT NULL,
        line_total INTEGER NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    final now = DateTime.now().toIso8601String();
    String hash(String raw) => sha256.convert(utf8.encode(raw)).toString();

    batch.insert('users', {
      'full_name': 'Administrator',
      'username': 'admin',
      'password_hash': hash('admin123'),
      'role': 'admin',
      'is_active': 1,
      'created_at': now,
    });

    batch.insert('users', {
      'full_name': 'Cashier',
      'username': 'cashier',
      'password_hash': hash('cashier123'),
      'role': 'cashier',
      'is_active': 1,
      'created_at': now,
    });

    batch.insert('settings', {
      'key': AppConstants.settingLastOrderNumber,
      'value': '0',
    });

    batch.insert('settings', {
      'key': AppConstants.settingTtsLanguage,
      'value': 'ru-RU',
    });

    batch.insert('settings', {
      'key': AppConstants.settingTtsRate,
      'value': '0.5',
    });

    await batch.commit(noResult: true);
  }
}
