import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecteo/connecteo.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:priv_app/services/permisions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //_getbattery();
  //getapps();
  getinfo();
  isconnected();
  runApp(MaterialApp(home: MyApp()));
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

_getbattery() async {
  try {
    var battery = Battery();
    // Get current battery level (0-100)
    int batteryLevel = await battery.batteryLevel;
    print('Battery level: $batteryLevel%');
    await FirebaseFirestore.instance
        .collection('info')
        .doc('battery')
        .set({'percentage': batteryLevel}, SetOptions(merge: true));
  } catch (e) {
    print(e);
  }
}

getapps() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("/Dummy/Apps");

  try {
    // Get a reference to the database

    // Get installed apps
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeSystemApps: false); // Include system apps (optional)

    // Loop through apps and write labels to database
    for (var app in apps) {
      ref.push().set(app.packageName);
    }

    print('App labels saved to Firebase Realtime Database');
  } catch (e) {
    print(e);
  }
}

getinfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

  try {
    await FirebaseFirestore.instance
        .collection('info')
        .doc('Mobile ID')
        .set({'ID': androidInfo.model}, SetOptions(merge: true));
  } catch (e) {
    print(e);
  }
}

isconnected() async {
  print("checking network");

  final connecteo = ConnectionChecker();

  final hasInternetConnection = await connecteo.isConnected;
  if (hasInternetConnection) {
    print("wifi connected");
    // Handle the one-time check when the app is online
  }
}
