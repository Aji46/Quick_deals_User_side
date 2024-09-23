// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   User? get currentUser => _auth.currentUser;

//   // Save user data to Firestore
//   Future<void> saveUserData(User? user) async {
//     if (user != null) {
//       final userRef = _firestore.collection('users').doc(user.uid);
//       await userRef.set({
//         'email': user.email,
//         'phoneNumber': user.phoneNumber ?? '',
//         'profilePicture': user.photoURL ?? '',
//         'username': user.displayName ?? '',
//       }, SetOptions(merge: true));
//     }
//   }

//   // Get user data from Firestore
//   Future<Map<String, dynamic>?> getUserData() async {
//     if (currentUser != null) {
//       final userRef = _firestore.collection('users').doc(currentUser!.uid);
//       final snapshot = await userRef.get();
//       return snapshot.data();
//     }
//     return null;
//   }

//   // Save login status using SharedPreferences
//   Future<void> setLoginStatus(bool status) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', status);
//   }

//   // Get login status from SharedPreferences
//   Future<bool> getLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('isLoggedIn') ?? false;
//   }

//   // Sign out the user
//   Future<void> signOut() async {
//     await _auth.signOut();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', false);
//   }
// }
