import 'package:flutter/material.dart';
import '../../core/db/app_database.dart';
import '../../core/utils/date_utils.dart';

class ReadyOrdersPage extends StatefulWidget {
  const ReadyOrdersPage({super.key});

  @override
  State<ReadyOrdersPage> createState() => _ReadyOrdersPageState();
}

class _ReadyOrdersPageState extends State<ReadyOrdersPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('orders', orderBy: 'id DESC', limit: 50);
    setState(() => orders = rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Акыркы заказдар')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (_, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Заказ №${order['order_number']}'),
            subtitle: Text(AppDateUtils.pretty(order['created_at'] as String)),
            trailing: Text('${order['total_amount']} сом'),
          );
        },
      ),
    );
  }
}
