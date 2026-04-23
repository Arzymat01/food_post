class ProductModel {
  final int? id;
  final String name;
  final int price;
  final String? imagePath;
  final int isActive;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    this.imagePath,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_path': imagePath,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imagePath: map['image_path'],
      isActive: map['is_active'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
