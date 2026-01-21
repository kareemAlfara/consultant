
class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
  });

  // ✅ From Firebase Document
  factory UserModel.fromFirestore(Map<String, dynamic> doc, String uid) {
    return UserModel(
      id: uid,
      email: doc['email'] ?? '',
      name: doc['name'] ?? '',
      phone: doc['phone'] ?? '',
    );
  }

  // ✅ From JSON (SharedPreferences)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  // ✅ To Firestore
  Map<String, dynamic> toFirestore() => {
        'email': email,
        'name': name,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
      };

  // ✅ To JSON (SharedPreferences)
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'phone': phone,
      };

  // ✅ CopyWith
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone)';
  }
}