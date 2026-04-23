import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/db/app_database.dart';
import '../../../core/models/product_model.dart';

class ProductFormPage extends StatefulWidget {
  final ProductModel? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      imagePath = widget.product!.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => imagePath = file.path);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;

    if (name.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Туура маалымат киргизиңиз')),
      );
      return;
    }

    final db = await AppDatabase.instance.database;
    final now = DateTime.now().toIso8601String();

    if (widget.product == null) {
      await db.insert(
        'products',
        ProductModel(
          name: name,
          price: price,
          imagePath: imagePath,
          isActive: 1,
          createdAt: now,
          updatedAt: now,
        ).toMap(),
      );
    } else {
      await db.update(
        'products',
        ProductModel(
          id: widget.product!.id,
          name: name,
          price: price,
          imagePath: imagePath,
          isActive: widget.product!.isActive,
          createdAt: widget.product!.createdAt,
          updatedAt: now,
        ).toMap(),
        where: 'id = ?',
        whereArgs: [widget.product!.id],
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Товар кошуу' : 'Товар өзгөртүү'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Товар аты'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Баасы'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Сүрөт тандоо'),
                ),
                const SizedBox(width: 12),
                if (imagePath != null)
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.file(File(imagePath!), fit: BoxFit.cover),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Сактоо')),
          ],
        ),
      ),
    );
  }
}
