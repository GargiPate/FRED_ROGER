import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyCttkWQ13tiM39o8wmklhe-uLrHsGixMjo",
  authDomain: "roger-ba6ea.firebaseapp.com",
  projectId: "roger-ba6ea",
  storageBucket: "roger-ba6ea.firebasestorage.app",
  messagingSenderId: "535597228686",
  appId: "1:535597228686:web:7f55d685a8377901709fdf" ));
  }else{
    await Firebase.initializeApp();
  }
  FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: false, // Disable offline persistence for debugging
);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FRED, ROGER That',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
