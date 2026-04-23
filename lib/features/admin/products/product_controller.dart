import 'package:flutter/material.dart';
import '../../../core/db/app_database.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/date_utils.dart';

class ProductController extends ChangeNotifier {
  List<ProductModel> products = [];
  bool loading = false;

  Future<void> loadProducts() async {
    loading = true;
    notifyListeners();

    final db = await AppDatabase.instance.database;
    final result = await db.query('products', orderBy: 'id DESC');
    products = result.map((e) => ProductModel.fromMap(e)).toList();

    loading = false;
    notifyListeners();
  }

  Future<void> saveProduct({
    int? id,
    required String name,
    required int price,
    required String? imagePath,
    int isActive = 1,
    String? createdAt,
  }) async {
    final db = await AppDatabase.instance.database;
    final now = AppDateUtils.nowIso();

    if (id == null) {
      await db.insert(
        'products',
        ProductModel(
          name: name,
          price: price,
          imagePath: imagePath,
          isActive: isActive,
          createdAt: now,
          updatedAt: now,
        ).toMap(),
      );
    } else {
      await db.update(
        'products',
        ProductModel(
          id: id,
          name: name,
          price: price,
          imagePath: imagePath,
          isActive: isActive,
          createdAt: createdAt ?? now,
          updatedAt: now,
        ).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
    await loadProducts();
  }
}
