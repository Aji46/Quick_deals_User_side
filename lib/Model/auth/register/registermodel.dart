class UserModel {
  final String username;
  final String email;
  final String phoneNumber;
  final String profilePicture;

  UserModel({
    required this.username,
    required this.email,
    required this.phoneNumber, 
    required this.profilePicture,

  });

  // Convert a UserModel into a map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }

  // Create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      profilePicture: map['profilePicture'],
    );
  }
}
