class UserModel {
  final int? id;
  final String fullName;
  final String username;
  final String passwordHash;
  final String role;
  final int isActive;
  final String createdAt;

  UserModel({
    this.id,
    required this.fullName,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'password_hash': passwordHash,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'],
      username: map['username'],
      passwordHash: map['password_hash'],
      role: map['role'],
      isActive: map['is_active'],
      createdAt: map['created_at'],
    );
  }
}
