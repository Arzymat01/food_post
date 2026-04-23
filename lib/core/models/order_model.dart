class OrderModel {
  final int? id;
  final int orderNumber;
  final int cashierId;
  final int totalAmount;
  final String status;
  final String createdAt;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.cashierId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'cashier_id': cashierId,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int?,
      orderNumber: map['order_number'] as int,
      cashierId: map['cashier_id'] as int,
      totalAmount: map['total_amount'] as int,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }
}
