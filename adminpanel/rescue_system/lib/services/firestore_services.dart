import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateEmergencyStatus(String userId, String status) async {
    await _firestore.collection('users').doc(userId).update({
      'emergencyStatus': status,
    });
  }
}
