class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? 'N/A',
      email: data['email'] ?? 'N/A',
      phoneNumber: data['phoneNumber'] ?? 'N/A',
    );
  }
}
