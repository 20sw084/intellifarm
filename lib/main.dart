import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'wrapper.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For monitoring network status

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence
  enableOfflinePersistence();

  // Monitor network status
  monitorNetworkStatus();

  runApp(const MyApp());
}

// Function to enable offline persistence
void enableOfflinePersistence() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Enables caching of data locally
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Optional: unlimited cache
  );
}

// Function to monitor network connectivity
void monitorNetworkStatus() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      print('You are offline');
    } else {
      print('You are online');
      // Optional: Add custom sync logic if needed, e.g., notifying users or triggering specific actions
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
    );
  }
}
