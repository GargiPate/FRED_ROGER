import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();


  // Sign up user and store details in Firestore
  Future<User?> signUp({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        print("User created: ${user.uid}");

        // Store user details in Firestore using DatabaseService
        await _databaseService.createUser(
          uid: user.uid,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
        );
      }

      return user;
    } catch (e) {
      log('Signup Error: $e');
      return null;
    }
  }
}
