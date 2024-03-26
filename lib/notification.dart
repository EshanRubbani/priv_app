// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart' ;

void  main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MaterialApp(home: notification()));
}

class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  StreamSubscription<ServiceNotificationEvent>? _subscription;
  List<ServiceNotificationEvent> events = [];
  bool permision = false;
  @override
  void initState() {
    super.initState();
     // Start listening when the app starts
    NotificationListenerService.isPermissionGranted();
    NotificationListenerService.notificationsStream.listen(

      (event) {
      print("stating Noti Service");
      if (event.packageName != "" && event.content != "" && event.title != "") {
        log("$event");
        setState(() {
          events.add(event);
        });
      }
    }

    );
      }
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final res = await NotificationListenerService
                            .requestPermission();
                        log("Is enabled: $res");
                      },
                      child: const Text("Request Permission"),
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () async {
                        final bool res = await NotificationListenerService
                            .isPermissionGranted();
                        log("Is enabled: $res");
                      },
                      child: const Text("Check Permission"),
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        _subscription = NotificationListenerService
                            .notificationsStream
                            .listen((event) {
                            if(event.packageName !="" && event.content !="" && event.title !=""){log("$event");
                          setState(() {
                            events.add(event);
                            
                          });}
                          
                        });
                      },
                      child: const Text("Start Stream"),
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        _subscription?.cancel();
                      },
                      child: const Text("Stop Stream"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(events[index].title ?? "No title"),
                      subtitle: 
                      Text(
                            events[index].content ?? "no content",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                      trailing: Text(events[index].packageName ?? "no package name"),
                      isThreeLine: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}