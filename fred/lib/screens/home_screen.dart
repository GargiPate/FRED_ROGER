import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_details_page.dart';
import 'project_details_page.dart';
import 'package:fred/services/database_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }
  final DatabaseService _databaseService = DatabaseService();


  // ✅ Fetch and reload the user to get updated details
  Future<void> _fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh the user
    setState(() {
      _currentUser = FirebaseAuth.instance.currentUser; // Get updated user
    });
  }

  // ✅ Get current location with better error handling
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showDialog('Location Disabled', 'Please enable location services.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          _showDialog('Permission Denied', 'Location permission is required.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });

       // ✅ Update Firestore with the location
    if (_currentUser != null) {
      DatabaseService().updateUserLocation(
        uid: _currentUser!.uid,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }

      _showDialog(
        'Help Called',
        'Coordinates:\nLat: ${position.latitude}, Long: ${position.longitude}',
      );
    } catch (e) {
      _showDialog('Error', 'Could not fetch location. Try again.');
    }
  }

  // ✅ Reusable alert dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ✅ Logout and navigate to login screen
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Ensure proper navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.yellow.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // ✅ Logout function
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.yellow.shade800,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_currentUser?.displayName ?? 'No Name'),
              accountEmail: Text(_currentUser?.email ?? 'No Email'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              decoration: BoxDecoration(color: Colors.yellow.shade600),
            ),
            ListTile(
              title: const Text('Edit Details'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditDetailsPage()),
              ),
            ),
            ListTile(
              title: const Text('Project Details'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProjectDetailsPage()),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: ElevatedButton(
            onPressed: _getCurrentLocation, // ✅ Fetch location on press
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              elevation: 12,
              shadowColor: Colors.black.withOpacity(0.5),
            ),
            child: Text(
              'ROGER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 32,
                letterSpacing: 2,
                fontFamily: 'Roboto',
                shadows: [
                  for (var offset in [
                    Offset(1.5, 1.5),
                    Offset(-1.5, -1.5),
                    Offset(1.5, -1.5),
                    Offset(-1.5, 1.5)
                  ])
                    Shadow(offset: offset, color: Colors.white, blurRadius: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
