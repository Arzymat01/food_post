import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../auth/login_page.dart';
import 'products/product_list_page.dart';
import 'reports/reports_page.dart';
import 'settings/settings_page.dart';

class AdminHomePage extends StatelessWidget {
  final UserModel user;
  const AdminHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Админ: ${user.fullName}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _item(context, 'Товарлар', Icons.fastfood, const ProductListPage()),
          _item(context, 'Отчеттор', Icons.bar_chart, const ReportsPage()),
          _item(context, 'Настройка', Icons.settings, const SettingsPage()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, IconData icon, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
