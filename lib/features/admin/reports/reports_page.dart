import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/excel_service.dart';
import 'reports_controller.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsController()..loadDailyReport(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReportsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Күндүк отчет'),
        actions: [
          IconButton(
            onPressed: () async {
              final service = ExcelService();
              final path = await service.exportSalesReport(
                rows: controller.byProducts,
                total: controller.totalSales,
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    path == null ? 'Сакталган жок' : 'Сакталды: $path',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.file_download),
          ),
        ],
      ),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Жалпы заказ саны'),
                      trailing: Text('${controller.totalOrders}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Жалпы сатуу'),
                      trailing: Text('${controller.totalSales} сом'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Товарлар боюнча',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.byProducts.length,
                      itemBuilder: (_, index) {
                        final row = controller.byProducts[index];
                        return Card(
                          child: ListTile(
                            title: Text('${row['name']}'),
                            subtitle: Text('Саны: ${row['qty']}'),
                            trailing: Text('${row['sum']} сом'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
