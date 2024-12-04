import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intellifarm/providers/crop_provider.dart';
import 'package:intellifarm/providers/farmer_provider.dart';
import 'package:intellifarm/providers/field_provider.dart';
import 'package:intellifarm/providers/planting_provider.dart';
import 'package:intellifarm/providers/search_provider.dart';
import 'package:provider/provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CropProvider()..fetchCropsData()),
        ChangeNotifierProvider(create: (_) => FarmerProvider()..fetchFarmersData()),
        ChangeNotifierProvider(create: (_) => FieldProvider()..fetchFieldsData()),
        ChangeNotifierProvider(create: (_) => PlantingProvider()..fetchPlantings()),
      ],
      child: MyApp(),
    ),
  );
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

// Farmer and Landlord profiles.
// Plantings and Harvest screen has some type issues. Mainly crop name is not coming from backend in planting screen.
// thyme new ki variety sahi jaga upload nh hwi.
// Providers on remaining activities screens
// Activities screen per freezing screen feature lagana hai
// Type issues in transactions/transactions_screen.dart in income tab. and also provider in both tabs
// field status screen has type issues
// Share Rule backend implementation:
// State:
// PDF on every page.
