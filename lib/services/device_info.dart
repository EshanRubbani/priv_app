import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(home: info()));
}

class info extends StatelessWidget {
  const info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("At Battery screen"),
      ),
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
