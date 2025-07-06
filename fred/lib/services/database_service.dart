import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fred/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Store user details in Firestore
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'created_at': FieldValue.serverTimestamp(),
      });
      log("User details added to Firestore");
    } catch (e) {
      log("Firestore Error: $e");
    }
  }

   /// Fetch user details from Firestore
  Future<Map<String, dynamic>?> getUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        }
      } catch (e) {
        log("Firestore Error: $e");
      }
    }
    return null;
  }

  /// Update user details in Firestore
  Future<void> updateUserDetails({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
          'phone_number': phoneNumber,
        });
        log("User details updated successfully");
      } catch (e) {
        log("Firestore Error: $e");
      }
    }
  }
  // Update user location in Firestore
Future<void> updateUserLocation({
  required String uid,
  required double latitude,
  required double longitude,
}) async {
  try {
    await _firestore.collection('users').doc(uid).update({
      'latitude': latitude,
      'longitude': longitude,
      'location_updated_at': FieldValue.serverTimestamp(),
      'emergency':true,
      'active': true,
      'emergencyStatus': '⚠️ Active Emergency',
    });
    log("User location updated in Firestore");
  } catch (e) {
    log("Firestore Error: $e");
  }
}

}
