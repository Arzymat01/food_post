class OrderItemModel {
  final int? id;
  final int orderId;
  final int productId;
  final String productName;
  final int qty;
  final int price;
  final int lineTotal;

  OrderItemModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.lineTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'qty': qty,
      'price': price,
      'line_total': lineTotal,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as int?,
      orderId: map['order_id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      qty: map['qty'] as int,
      price: map['price'] as int,
      lineTotal: map['line_total'] as int,
    );
  }
}
