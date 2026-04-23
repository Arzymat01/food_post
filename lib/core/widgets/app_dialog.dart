import 'package:flutter/material.dart';

class AppDialog {
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Жок'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ооба'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
