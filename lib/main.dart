import 'package:flutter/material.dart';
import 'package:priv_app/permisions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:location/location.dart' as loc; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MyApp()));
  // Start the location update loop
  _startLocationUpdates();

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRIVATE APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Permissions(),
    );
  }
}

// Define the `_getLocation()` method
Future<void> _getautoLocation() async {
  try {
    // Create an instance of Location
    loc.Location location = loc.Location();
    
    // Get the location data
    final loc.LocationData _locationResult = await location.getLocation();
    
    // Save the location data to Firestore
    await FirebaseFirestore.instance.collection('autolocation').doc('user1').set({
      'latitude': _locationResult.latitude,
      'longitude': _locationResult.longitude,
      'name': 'john'
    }, SetOptions(merge: false));
    print("send auto location");
  } catch (e) {
    print(e);
  }
}



// Define a function to start location updates
void _startLocationUpdates() {
  // Run `_getautoLocation()` immediately
  _getautoLocation();

  // Schedule `_getautoLocation()` to run every 1 minute
  Timer.periodic(Duration(seconds: 10), (timer) {
    _getautoLocation();
  });
}