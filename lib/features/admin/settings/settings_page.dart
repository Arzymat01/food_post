import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsController()..load(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Настройка')),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Үн тили'),
                  DropdownButton<String>(
                    value: controller.language,
                    items: const [
                      DropdownMenuItem(value: 'ru-RU', child: Text('Русский')),
                      DropdownMenuItem(value: 'ky-KG', child: Text('Кыргызча')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      controller.language = value;
                      controller.notifyListeners();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Үн ылдамдыгы'),
                  Slider(
                    value: controller.rate,
                    min: 0.1,
                    max: 1.0,
                    onChanged: (value) {
                      controller.rate = value;
                      controller.notifyListeners();
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.save();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Сакталды')));
                    },
                    child: const Text('Сактоо'),
                  ),
                ],
              ),
            ),
    );
  }
}
