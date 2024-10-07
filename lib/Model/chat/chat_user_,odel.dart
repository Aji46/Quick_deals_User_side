class UserModel {
  final String id;
  final String name;
  final String profile;

  UserModel({
    required this.id,
    required this.name,
    required this.profile,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      profile: map['profile'] ?? '',
    );
  }
}
