import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatelessWidget {
  const ProjectDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      appBar: AppBar(
        title: const Text('Project Details'),
        backgroundColor:
            const Color.fromARGB(255, 250, 250, 250), // Black AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Title
            Text(
              'Project: FRED, ROGER THAT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade600, // Yellow title
              ),
            ),
            const SizedBox(height: 16),
            // Project Description
            Text(
              'This project aims to develop nano-drones for enhancing human safety, focusing on two systems: '
              'FRED (Fast Response Emergency Drone) and ROGER (Rapid Observation and Geospatial Emergency Response). '
              'The project involves creating drones that can respond to emergency situations by gathering real-time data and transmitting it to authorities.',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 24),
            // Project Goals
            Text(
              'Project Goals:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade600, // Yellow subtitle
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '- Enhance human safety using drones\n'
              '- Provide real-time location tracking and evidence gathering\n'
              '- Support authorities with accurate and timely information\n'
              '- Use cutting-edge drone technology for efficient emergency response',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 24),
            // Team Members
            Text(
              'Team Members:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade600, // Yellow subtitle
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '- Gayathri G. Nair (Project Lead)\n'
              '- Gargi Pate (Developer)\n'
              '- Hardi Patil (Developer)',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 24),
            // Project Status
            Text(
              'Project Status:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade600, // Yellow subtitle
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Currently in development phase. The project is being tested for real-time data transmission and drone functionality.',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // White text
              ),
            ),
            const SizedBox(height: 32),
            // Update Button (Optional)
            ElevatedButton(
              onPressed: () {
                // Optional functionality (e.g., update project status or details)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade600, // Yellow background
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Update Project Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text on yellow button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
