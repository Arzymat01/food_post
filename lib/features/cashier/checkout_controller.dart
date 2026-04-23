import 'package:flutter/material.dart';
import '../../core/db/app_database.dart';
import '../../core/services/printer_service.dart';
import '../../core/services/tts_service.dart';
import '../../core/utils/app_constants.dart';
import 'cart_controller.dart';

class CheckoutController extends ChangeNotifier {
  bool loading = false;
  final PrinterService printerService;
  final TtsService ttsService;

  CheckoutController({required this.printerService, required this.ttsService});

  Future<int> checkout({
    required int cashierId,
    required CartController cart,
  }) async {
    if (cart.isEmpty) throw Exception('Корзина бош');

    loading = true;
    notifyListeners();

    final db = await AppDatabase.instance.database;
    final now = DateTime.now().toIso8601String();

    final currentRow = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [AppConstants.settingLastOrderNumber],
    );
    final last = int.tryParse(currentRow.first['value'] as String) ?? 0;
    final nextNumber = last + 1;

    final orderId = await db.transaction<int>((txn) async {
      await txn.update(
        'settings',
        {'value': nextNumber.toString()},
        where: 'key = ?',
        whereArgs: [AppConstants.settingLastOrderNumber],
      );

      final id = await txn.insert('orders', {
        'order_number': nextNumber,
        'cashier_id': cashierId,
        'total_amount': cart.totalAmount,
        'status': 'paid',
        'created_at': now,
      });

      for (final line in cart.lines) {
        await txn.insert('order_items', {
          'order_id': id,
          'product_id': line.product.id,
          'product_name': line.product.name,
          'qty': line.qty,
          'price': line.product.price,
          'line_total': line.lineTotal,
        });
      }
      return id;
    });

    final receiptText = await printerService.buildReceiptText(
      orderNumber: nextNumber,
      items: cart.lines
          .map(
            (e) => {
              'name': e.product.name,
              'qty': e.qty,
              'line_total': e.lineTotal,
            },
          )
          .toList(),
      total: cart.totalAmount,
    );

    await printerService.printReceipt(receiptText);

    cart.clear();
    loading = false;
    notifyListeners();

    return nextNumber;
  }

  Future<void> announceReady(int orderNumber) async {
    final db = await AppDatabase.instance.database;
    final langRows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [AppConstants.settingTtsLanguage],
    );
    final rateRows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [AppConstants.settingTtsRate],
    );

    final language = langRows.isNotEmpty
        ? langRows.first['value'] as String
        : 'ru-RU';
    final rate = rateRows.isNotEmpty
        ? double.tryParse(rateRows.first['value'] as String) ?? 0.5
        : 0.5;

    await ttsService.speakOrderReady(
      orderNumber: orderNumber,
      language: language,
      rate: rate,
    );
  }
}
