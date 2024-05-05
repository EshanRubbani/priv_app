import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:priv_app/services/stream/call.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyHome()));
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
    listenForCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Scaffold(), // Placeholder - build your actual body here
    );
  }

  Future<void> listenForCall() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final docRef = db.collection("call").doc("value");

    try {
      print("Listening For Call");
      await docRef.snapshots().listen((event) {
        print("data changed");
        print("current data: ${event.data()}");
        // Check if the 'true' field exists and is true
        if (event.data().toString().contains("true")) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CallPage(callID: "1")));
        }
      }, onError: (error) => print("Listen failed: $error"));
    } catch (e) {
      print(e);
    }
  }
}
