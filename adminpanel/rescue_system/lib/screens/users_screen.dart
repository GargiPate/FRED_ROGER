import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:html' as html;

class UsersTab extends StatefulWidget {
  @override
  _UsersTabState createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _respondToEmergency(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Respond to Emergency"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('users').doc(docId).update({
                  'emergencyStatus': '✔ Addressed',
                  'active': false,
                  'emergency': false,
                });
                Navigator.pop(context);
              },
              child: Text("Activate Drone"),
            ),
            ElevatedButton(
              onPressed: () {
                _notifyAuthorities(docId);
              },
              child: Text("Notify Authorities"),
            ),
          ],
        ),
      ),
    );
  }

  void _notifyAuthorities(String docId) {
    _firestore.collection('users').doc(docId).get().then((snapshot) {
      var data = snapshot.data();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("User Details"),
          content: Text("Name: ${data?['name']}\nPhone: ${data?['phone_number']}\nLocation: ${data?['latitude']}, ${data?['longitude']}"),
          actions: [
            TextButton(
              onPressed: () {
                _resolveEmergency(docId);
              },
              child: Text("Was the emergency addressed?"),
            ),
            TextButton(
              onPressed: () {
                _firestore.collection('users').doc(docId).update({
                  'emergencyStatus': '❌ Rejected',
                  'active': false,
                });
                Navigator.pop(context);
              },
              child: Text("Reject"),
            ),
          ],
        ),
      );
    });
  }

  void _resolveEmergency(String docId) async {
    await _firestore.collection('users').doc(docId).update({
      'emergencyStatus': '✔ Addressed',
      'active': false,
    });
    Navigator.pop(context);
  }

  void _uploadDroneImage(String docId) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();

        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) async {
          final base64Image = reader.result as String;

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Confirm Image Upload"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Are you sure you want to upload this image?"),
                  SizedBox(height: 10),
                  Image.network(base64Image, height: 200),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Yes, Upload"),
                  onPressed: () async {
                    Navigator.pop(context); // close the dialog
                    await _firestore.collection('users').doc(docId).update({
                      'droneImageBase64': base64Image,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Image uploaded for user.")),
                    );
                  },
                ),
              ],
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final user = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;

            final isActive = user['active'] == true;
            final emergencyStatus = user['emergencyStatus'] ?? '';

            return Card(
              color: isActive ? Colors.red.shade300 : Colors.grey.shade800,
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text(user['name'] ?? 'N/A', style: TextStyle(color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📞 ${user['phone_number'] ?? 'N/A'}", style: TextStyle(color: Colors.white70)),
                    Text("📍 ${user['latitude']}, ${user['longitude']}", style: TextStyle(color: Colors.white70)),
                    if (emergencyStatus.isNotEmpty)
                      Text(emergencyStatus, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _respondToEmergency(docId),
                      child: Text("Respond"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _firestore.collection('users').doc(docId).update({
                          'emergencyStatus': '❌ Rejected',
                          'active':false,
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Reject"),
                    ),
                    ElevatedButton(
                      onPressed: () => _uploadDroneImage(docId),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: Text("Submit Photo"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
