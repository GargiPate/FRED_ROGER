import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GnssInfoScreen extends StatefulWidget {
  @override
  _GnssInfoScreenState createState() => _GnssInfoScreenState();
}

class _GnssInfoScreenState extends State<GnssInfoScreen> {
  static const platform = MethodChannel('gnss_info');
  List<String> satellites = [];
  String errorMessage = "";

  Future<void> getGnssSatellites() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getGnssSatellites');
      setState(() {
        satellites = result.cast<String>();
        errorMessage = "";
      });
    } on PlatformException catch (e) {
      setState(() {
        errorMessage = "Failed to get GNSS satellites: ${e.message}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getGnssSatellites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GNSS Satellite Info")),
      body: Center(
        child: errorMessage.isNotEmpty
            ? Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 18))
            : satellites.isEmpty
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Connected Satellites:", 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ...satellites.map((s) => Text(s, style: const TextStyle(fontSize: 18))),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: getGnssSatellites,
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
      ),
    );
  }
}
