import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/product_model.dart';
import '../../../core/widgets/app_dialog.dart';
import 'product_controller.dart';
import 'product_form_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductController()..loadProducts(),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Товарлар'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductFormPage()),
              );
              if (context.mounted) {
                context.read<ProductController>().loadProducts();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (_, index) {
                final product = controller.products[index];
                return _ProductTile(product: product);
              },
            ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: product.imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(product.imagePath!),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(Icons.fastfood, size: 40),
      title: Text(product.name),
      subtitle: Text('${product.price} сом'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductFormPage(product: product),
                ),
              );
              if (context.mounted) {
                context.read<ProductController>().loadProducts();
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              final ok = await AppDialog.confirm(
                context,
                title: 'Өчүрүү',
                content: 'Бул товарды өчүрөсүзбү?',
              );
              if (!ok || !context.mounted) return;
              await context.read<ProductController>().deleteProduct(
                product.id!,
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
