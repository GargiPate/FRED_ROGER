import 'package:flutter/material.dart';
import '../widgets/drones_form.dart';

class DroneManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        color: Colors.blueGrey[900],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Manage Drones",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Divider(color: Colors.grey),
              DroneForm(),
            ],
          ),
        ),
      ),
    );
  }
}
