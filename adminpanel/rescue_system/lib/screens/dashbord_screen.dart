import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'users_screen.dart';
import 'drones_screen.dart';
import '../widgets/blinking_text.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 5,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: const TabBar(
                labelColor: Colors.yellow,
                unselectedLabelColor: Colors.white54,
                indicatorColor: Colors.yellow,
                tabs: [
                  Tab(icon: Icon(Icons.dashboard), text: "Dashboard"),
                  Tab(icon: Icon(Icons.people), text: "Users"),
                  Tab(icon: Icon(Icons.airplanemode_active), text: "Drones"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // --- DASHBOARD TAB ---
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .where('emergency', isEqualTo: true)
                        .where('active', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final emergencies = snapshot.data!.docs;

                      if (emergencies.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              color: Colors.blueGrey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Dashboard Overview\n\nNo active emergencies.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      // If there are active emergencies
                      return ListView.builder(
                        itemCount: emergencies.length,
                        itemBuilder: (context, index) {
                          final data = emergencies[index].data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              color: Colors.red[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: BlinkingText(
                                  text:
                                      '🚨 Emergency Alert!\nFrom: ${data['name']} (${data['phone_number']})\nLocation: ${data['latitude']}, ${data['longitude']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // --- USERS TAB ---
                  UsersTab(),

                  // --- DRONES TAB ---
                  DroneManagementScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
