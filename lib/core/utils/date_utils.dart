import 'package:intl/intl.dart';

class AppDateUtils {
  static String nowIso() => DateTime.now().toIso8601String();

  static String pretty(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return DateFormat('dd.MM.yyyy HH:mm').format(dt);
  }

  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
