import 'package:flutter/material.dart';

class DroneForm extends StatefulWidget {
  @override
  _DroneFormState createState() => _DroneFormState();
}

class _DroneFormState extends State<DroneForm> {
  String droneId = "";
  String status = "";
  String latitude = "";
  String longitude = "";

  void updateDroneDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Drone details updated manually.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField("Drone ID", (value) => droneId = value),
        _buildTextField("Status", (value) => status = value),
        _buildTextField("Latitude", (value) => latitude = value),
        _buildTextField("Longitude", (value) => longitude = value),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: updateDroneDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text(
            "Update Drone",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.yellow, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
