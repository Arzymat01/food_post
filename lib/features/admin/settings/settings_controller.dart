import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../../../core/utils/app_constants.dart';

class SettingsController extends ChangeNotifier {
  String language = 'ru-RU';
  double rate = 0.5;
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();

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

    if (langRows.isNotEmpty) language = langRows.first['value'] as String;
    if (rateRows.isNotEmpty)
      rate = double.tryParse(rateRows.first['value'] as String) ?? 0.5;

    loading = false;
    notifyListeners();
  }

  Future<void> save() async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'settings',
      {'value': language},
      where: 'key = ?',
      whereArgs: [AppConstants.settingTtsLanguage],
    );
    await db.update(
      'settings',
      {'value': rate.toString()},
      where: 'key = ?',
      whereArgs: [AppConstants.settingTtsRate],
    );
  }
}
