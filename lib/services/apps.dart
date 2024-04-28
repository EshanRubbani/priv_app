import 'package:device_apps/device_apps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getapps();
}

getapps() async {
  try {
    // Get a reference to the database

    DatabaseReference ref = FirebaseDatabase.instance.ref("/Dummy/Apps");

    // Get installed apps
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeSystemApps: true); // Include system apps (optional)

    // Loop through apps and write labels to database
    for (var app in apps) {
      ref.child('apps/${app.packageName}').set(app.appName);
    }

    print('App labels saved to Firebase Realtime Database');
  } catch (e) {
    print(e);
  }
}
