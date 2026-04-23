import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';

class ReportsController extends ChangeNotifier {
  bool loading = false;
  int totalSales = 0;
  int totalOrders = 0;
  List<Map<String, dynamic>> byProducts = [];

  Future<void> loadDailyReport() async {
    loading = true;
    notifyListeners();

    final db = await AppDatabase.instance.database;
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String();

    final orders = await db.rawQuery(
      '''
      SELECT COUNT(*) as cnt, COALESCE(SUM(total_amount),0) as sum
      FROM orders
      WHERE created_at >= ?
      ''',
      [start],
    );

    totalOrders = (orders.first['cnt'] as int?) ?? 0;
    totalSales = (orders.first['sum'] as int?) ?? 0;

    byProducts = await db.rawQuery('''
      SELECT product_name as name, SUM(qty) as qty, SUM(line_total) as sum
      FROM order_items
      GROUP BY product_name
      ORDER BY sum DESC
    ''');

    loading = false;
    notifyListeners();
  }
}
