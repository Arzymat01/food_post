import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';

class CartLine {
  final ProductModel product;
  int qty;

  CartLine({required this.product, this.qty = 1});

  int get lineTotal => product.price * qty;
}

class CartController extends ChangeNotifier {
  final List<CartLine> lines = [];

  void addProduct(ProductModel product) {
    final existing = lines.where((e) => e.product.id == product.id).firstOrNull;
    if (existing != null) {
      existing.qty += 1;
    } else {
      lines.add(CartLine(product: product));
    }
    notifyListeners();
  }

  void increment(CartLine line) {
    line.qty += 1;
    notifyListeners();
  }

  void decrement(CartLine line) {
    if (line.qty > 1) {
      line.qty -= 1;
    } else {
      lines.remove(line);
    }
    notifyListeners();
  }

  void clear() {
    lines.clear();
    notifyListeners();
  }

  int get totalAmount => lines.fold(0, (sum, e) => sum + e.lineTotal);
  bool get isEmpty => lines.isEmpty;
}
