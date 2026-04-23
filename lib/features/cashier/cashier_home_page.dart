import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/db/app_database.dart';
import '../../core/models/product_model.dart';
import '../../core/models/user_model.dart';
import '../../core/services/printer_service.dart';
import '../../core/services/tts_service.dart';
import '../../core/widgets/app_button.dart';
import '../auth/login_page.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';
import 'ready_orders_page.dart';

class CashierHomePage extends StatelessWidget {
  final UserModel user;

  const CashierHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(
          create: (_) => CheckoutController(
            printerService: PrinterService(),
            ttsService: TtsService(),
          ),
        ),
      ],
      child: _CashierHomeView(user: user),
    );
  }
}

class _CashierHomeView extends StatefulWidget {
  final UserModel user;

  const _CashierHomeView({required this.user});

  @override
  State<_CashierHomeView> createState() => _CashierHomeViewState();
}

class _CashierHomeViewState extends State<_CashierHomeView> {
  List<ProductModel> products = [];
  int? lastOrderNumber;
  bool loadingProducts = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => loadingProducts = true);

    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'products',
      where: 'is_active = 1',
      orderBy: 'name ASC',
    );

    setState(() {
      products = result.map((e) => ProductModel.fromMap(e)).toList();
      loadingProducts = false;
    });
  }

  Future<void> _checkout() async {
    final cart = context.read<CartController>();
    final checkout = context.read<CheckoutController>();

    try {
      final orderNumber = await checkout.checkout(
        cashierId: widget.user.id!,
        cart: cart,
      );

      setState(() => lastOrderNumber = orderNumber);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Заказ №$orderNumber сакталды')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ката: $e')));
    }
  }

  Future<void> _announce() async {
    if (lastOrderNumber == null) return;
    await context.read<CheckoutController>().announceReady(lastOrderNumber!);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();
    final checkout = context.watch<CheckoutController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Кассир: ${widget.user.fullName}'),
        actions: [
          IconButton(
            tooltip: 'Акыркы заказдар',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReadyOrdersPage()),
              );
            },
            icon: const Icon(Icons.receipt_long),
          ),
          IconButton(
            tooltip: 'Чыгуу',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: loadingProducts
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(
                    child: Text('Товарлар жок', style: TextStyle(fontSize: 20)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (_, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () => cart.addProduct(product),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (product.imagePath != null &&
                                    product.imagePath!.isNotEmpty)
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(product.imagePath!),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.fastfood,
                                              size: 60,
                                            ),
                                      ),
                                    ),
                                  )
                                else
                                  const Expanded(
                                    child: Icon(Icons.fastfood, size: 60),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('${product.price} сом'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Корзина',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: cart.lines.isEmpty
                        ? const Center(
                            child: Text(
                              'Корзина бош',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cart.lines.length,
                            itemBuilder: (_, index) {
                              final line = cart.lines[index];
                              return Card(
                                child: ListTile(
                                  title: Text(line.product.name),
                                  subtitle: Text('${line.product.price} сом'),
                                  leading: IconButton(
                                    onPressed: () => cart.decrement(line),
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 140,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('${line.qty}'),
                                        IconButton(
                                          onPressed: () => cart.increment(line),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                        Text('${line.lineTotal}'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Text(
                    'ЖАЛПЫ: ${cart.totalAmount} сом',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: checkout.loading ? 'Сакталууда...' : 'ТӨЛӨНДҮ / ЧЕК',
                    onPressed: checkout.loading || cart.isEmpty
                        ? null
                        : _checkout,
                    icon: Icons.print,
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    text: 'ДАЯР ДЕП ЧАКЫРУУ',
                    onPressed: lastOrderNumber == null ? null : _announce,
                    icon: Icons.volume_up,
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    text: 'ТАЗАЛОО',
                    onPressed: cart.isEmpty ? null : cart.clear,
                    icon: Icons.clear,
                  ),
                  if (lastOrderNumber != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Акыркы заказ №$lastOrderNumber',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
